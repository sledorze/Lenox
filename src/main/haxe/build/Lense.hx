package build;

import haxe.ds.StringMap;

using tink.MacroApi;
using stx.Strings;
using stx.Arrays;
using Lambda;
using tink.core.Outcome;

import LensesMacro;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;

#if macro
  import tink.macro.ClassBuilder;
  import tink.macro.Types in Tps;
  import tink.macro.Types.getFields;
#end

private typedef Data = {
    var lense : Dynamic;
}
class Lense{

  static function __init__(){
    Lense.cache = cache == null ? new StringMap() : cache;
  }
  static private var cache : StringMap<Dynamic>;
  static public macro function build():Type{
    var local_type : Type = Tps.reduce(Context.getLocalType(),false);
    var sub_type = (switch(local_type){
    case TInst(t,params) : params[0];//This is brittle, but 80%
      default : null;
    });
    //trace('$sub_type');
    return if(sub_type == null){
       local_type;
    }else{
        processSubType(sub_type);
    }
  }
  static private function processSubType(sub_type:Type):Type{
    var sig = Context.signature(sub_type);
    var idx = Types.register(function(){ return sub_type; });
    cache.set(sig, idx);
    var shim = ah.Types.getBaseType(sub_type).map(
      function(x){
        return { name : x.name, pack : x.pack, pos : x.pos };
      }
    ).getOrElse(
      {
        pack : [],
        name : 'AnonLense$idx',
        pos  : Context.currentPos()
      }
    );

    var fields        = tink.macro.Types.getFields(sub_type).sure();
    var lenses        =
      fields
        .map(function(cf){return Helper.lenseForClassField(sub_type, cf, shim.pos);})
        .filter(function (x) return x!=null)
        .array()
        .map(function(x:Field){
          x.access = [APublic];
          x.name   = x.name.endsWith("_") ? x.name.substr(0,-1) :  x.name;
          return x;
        });
    var type_def      = createLenseClass(shim,lenses);
    var printer       = new haxe.macro.Printer();
    //trace(printer.printTypeDefinition(type_def));
    var out           = defineAndReturnLenseClass(type_def);
    return out;
  }
  static private function defineAndReturnLenseClass(type_def:TypeDefinition){
    //trace(type_def.name);
    var full_name_arr = type_def.pack.concat([type_def.name]);
    var full_name     = full_name_arr.join(".");
    //trtace(full_name);
    return try{
      Context.getType(full_name);
    }catch(e:Dynamic){
      //trace('fail $e');
      Context.defineType(type_def);
      return try{
        Context.getType(full_name);
      }catch(e:Dynamic){
        null;
      }
    }
    Context.getType(full_name);
  }
  static private function createLenseClass(sub_type_base:{ pack : Array<String>, name : String, pos : haxe.macro.Expr.Position },lenses:Array<Field>):TypeDefinition{
    var pack      = sub_type_base.pack;
    var name      = sub_type_base.name + "Lense";
    var type_def = {
      pack  : pack,
      name  : name,
      pos   : sub_type_base.pos,
      kind : TDClass(),
      fields : lenses.add(
        {
          access : [APublic],
          name : "new",
          kind : FFun({args : [], ret : null, expr : macro {}}),
          pos : sub_type_base.pos
        }
      ),
    };
    return type_def;
  }
}
