package;

using tink.core.Outcome;
import haxe.macro.Expr;
import haxe.macro.Context;

#if macro
  import tink.macro.Exprs;
#end
import test_package.TEST_MODULE;
/**
  Ok, so what is the overlap between pack, module and name in BaseType.
**/
class ModuleTest{
  public function new(){}
  public function testInPackageInModule(){
    var a = new IN_TEST_MODULE();
    testModuleReadout(a);//module includes pack string and
    var b = new test_package.NO_MODULE();
    testModuleReadout(b);
  }
  macro static private function testModuleReadout(e:Expr){
    var tp = Exprs.typeof(e).sure();
    switch(tp){
      case TInst(t,_) :
        var type = t.get();
        trace('pack:(${type.pack}) module(${type.module}) name:(${type.name})');
        trace(ah.BaseTypes.getFullPath(type));
      default :
    }
    return macro {};
  }
}
