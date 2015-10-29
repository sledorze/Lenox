package ;

/**
 * ...
 * @author sledorze
 */

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

import ah.BaseTypes;
import ah.Types;
using Lambda;

#if macro

typedef LenseField = {
  name : String,
  type : Type,
}

class Helper {

  static function classFieldsToLenseFields(cf : Array<ClassField>) : Array<LenseField> return
    cf.map(function (cf) return {
      name : cf.name,
      type : cf.type
    }).array();

  static function classFieldsForClassType(c : ClassType) : Array<LenseField> return
    classFieldsToLenseFields(c.fields.get());

  inline static function writeTypeName(name : String, params : Array<String>) : String return
    if (params.length > 0)
      name + "<" + params.join(",") + ">";
    else
      name;

  private static function getFullPathForType(t:Type):Null<String>{
    return BaseTypes.getFullPath(Types.getBaseType(t));
  }
  public static function nameForClassField(cf : ClassField) : String return
    cf.name + " : " + displayForType(cf.type);

  public static function displayForType(x : Type) : String {
    var maybe_name = getFullPathForType(x);
    return switch (x) {
      case TType(t, params)
        : writeTypeName(maybe_name, params.map(displayForType));
      case TInst(t, params)
        : writeTypeName(maybe_name, params.map(displayForType));
      case TAnonymous(a)
        : "{" + a.get().fields.map(nameForClassField).join(",") + "}";
      case TFun(args, ret)
        : args.map(function (x) return x.t).concat([ret]).map(displayForType).join(" -> ");
      case TEnum(t, params) : writeTypeName(maybe_name, params.map(displayForType));
    case TAbstract(ref, params) : writeTypeName(maybe_name,params.map(displayForType)); // throw 'lenses do not support abstracts $ref $params';
      default : throw "not allowed " + Std.string(x);
    };
  }
  public static function classFieldsFor(t : Type) : Array<LenseField> return
    switch (t) {
      case TMono( t ) : classFieldsFor(t.get());
	    case TEnum( t,  params ) : [];
	    case TInst( t,  params ) : classFieldsForClassType(t.get());
	    case TType( t , params ) : classFieldsFor(t.get().type);
      case TFun( args , ret ) : throw "lenses for function do not makes sense";
	    case TAnonymous( a ) : classFieldsToLenseFields(a.get().fields);
	    case TDynamic( t ) : throw "lenses for Dynamic do not make sense"; // or a dynamic way to support it
	    case TLazy( f ) : classFieldsFor(f());
      case TAbstract(ref, params) : classFieldsToLenseFields(ref.get().array);
    };

  public static function lenseForClassField(extensionType : Type, lense_field : LenseField, pos : Position) : Field {

    var object_typeName = displayForType(extensionType);
    if (object_typeName == null) throw ("not supported" + Std.string(extensionType));

    var field_name      = lense_field.name;
    var field_typeName  = displayForType(lense_field.type);
    if (field_typeName == null)
      return null;

    var exprString = '
      {
        get : function (___obj : $object_typeName) return ___obj.$field_name,
        set : function ($field_name : $field_typeName, ___obj : $object_typeName) {
          var ___cp = Reflect.copy(___obj);
          ___cp.$field_name = $field_name;
          return ___cp;
        }
      }';

    var expr = Context.parse(exprString, pos);
    var kind_type = TPath({
      pack : ["impl"],
      name : "Lense",
      params : [
        TPType(tink.macro.Types.toComplex(extensionType)),
        TPType(tink.macro.Types.toComplex(lense_field.type))
      ]
    });
    return {
      name : field_name+"_",
      doc : null,
      access : [APublic, AStatic],
      kind : FVar( kind_type, expr ),
      pos : pos,
      meta : []
    };
  }

}

class LensesMacro<T> {

  static var extensionClassName = "LensesFor";
  static function isExtension(el) return
    el.t.get().name == extensionClassName;

  public static function build(): Array<Field> {
    var extensionType = {
      var clazz : ClassType = Context.getLocalClass().get();
      clazz.interfaces.filter(isExtension).array()[0].params[0];
    }

    var pos = Context.currentPos();
    var classFields = Helper.classFieldsFor(extensionType);
    var lenses =
      classFields
        .map(function (cf) return Helper.lenseForClassField(extensionType, cf, pos))
        .filter(function (x) return x!=null).array();
    return lenses;
  }
}
#end

@:autoBuild(LensesMacro.build()) interface LensesFor<T> { }
