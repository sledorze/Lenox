package ;

/**
 * ...
 * @author sledorze
 */

using hx.Maybe;

import haxe.macro.Printer;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;


using tink.CoreApi;
import tink.MacroApi;

import ah.BaseTypes;
import ah.Types;
using Lambda;

#if macro

typedef LenseField = {
  name : String,
  type : Type,
}

class Helper {

  public static function lenseForClassField(extensionType : Type, lense_field : LenseField, pos : Position) : Field {

    var field_name      = lense_field.name;

    var getter_type = TypeTools.toComplexType(extensionType);
    var setter_type = TypeTools.toComplexType(lense_field.type);

    var getter = macro function(obj : $getter_type):hx.Maybe<$setter_type>{
      return obj.$field_name;
    }
    var setter = macro function($field_name : $setter_type, obj : $getter_type):$getter_type{
      obj.$field_name = $i{field_name};
      return obj;
    }
    var lense = macro {
      get : $getter,
      set : $setter
    }
    var p          = new Printer();
    var expr       = lense;

    /*
    var hmm = Exprs.field(expr,field_name);
    trace(hmm);
    trace(p.printExpr(hmm));*/

    var kind_type  = TPath({
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
    var classFields = tink.macro.Types.getFields(extensionType).sure();
    var lenses =
      classFields
        .map(function (cf) return Helper.lenseForClassField(extensionType, cf, pos))
        .filter(function (x) return x!=null).array();
    return lenses;
  }
}
#end

@:autoBuild(LensesMacro.build()) interface LensesFor<T> { }
