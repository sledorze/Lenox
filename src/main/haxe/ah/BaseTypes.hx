package ah;

using stx.Arrays;
import haxe.macro.Type;

class BaseTypes{
  public static function getFullPath(bt:BaseType):String{
    if(!Reflect.hasField(bt,"module")){
      return null; //ummm
    }
    var module      = bt.module.split(".");
    var module_name = module[module.length - 1];
    var actual_name = bt.name;
    if(actual_name != module_name){
      module = module.add(actual_name);
    }
    return module.join(".");
  }
}
