package ah;

#if macro
using tink.macro.Types;
#end

import haxe.macro.Type;

class Types{
  public static function getBaseType(t:Type):Null<BaseType>{
    return switch (t) {
      case TEnum( t , params )      : t.get();
      case TInst( t , params )      : t.get();
      case TType( t , params )      : t.get();
      case TAbstract( t , params )  : t.get();
      default                       : null;
    }
  }
  public static function getAnonType(t:Type):Null<AnonType>{
    return switch(t){
      case TAnonymous(t) : return t.get();
      default            : null;
    }
  }
}
