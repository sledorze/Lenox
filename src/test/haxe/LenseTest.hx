package;

import haxe.PosInfos;
import impl.Lense;

import utest.Assert.*;

import LensesComplex0;

import Lenser;

class LenseTest{
  public function new(){}
  public function testClassLenseBuild(){
      var lense    = new Lenser<LenseClass>();
      var lense    = new Lenser<LenseClass>();
      var impl     = new LenseClass();
          impl.a   = "3";
      var c        = lense.a.get(impl);
      equals("3",c);
  }
  public function testTypeLenseBuild(){
      var lense            = new Lenser<LenseType>();
      var impl : LenseType = { a : "hello"};
      var c                = lense.a.get(impl);
      equals("hello",c);
  }
  public function testAnonymousLenseBuild(){
    var lense            = new Lenser<{ var a : String; }>();
    var impl : LenseType = { a : "hello"};
    var c                = lense.a.get(impl);
    equals("hello",c);
  }
  public function testLenseComposition(){
    var lense0          = new Lenser<LensesWrapper>();
    var lense1          = new Lenser<LensesComplex0.LensesOuter>();
    var lense2          = new Lenser<LensesInner>();
    var lense3          = lense0.outer.then(lense1.inner).then(lense2.hello);

    var test_data : LensesWrapper
                        = {
      outer : {
        inner : {
          hello : "world"
        }
      }
    };

    var data            = lense3.get(test_data);
    equals("world",data);
  }
  public function testDynamicLeaf(){
      var a : DynamicLeaf = {
        a : "hello",
        b : []
      }
      var lense0 = new Lenser<DynamicLeaf>();

      var b : PosInfos = here();

      var lense1 = new Lenser<PosInfos>();

      var o = lense0.a.get(a);
      same("hello",o);
  }
  public function testLenseInSameModule(){
    var val     = new LenseInSameModule();
    var lenser  = new Lenser<LenseInSameModule>();
  }
  public function testLenseWithPrivates(){
    var val     = new LenseTypeWithPrivates();
    var lenser  = new Lenser<LenseTypeWithPrivates>();
  }
  private function here(?pos:PosInfos){
    return pos;
  }
}
class LenseInSameModule{
  public function new(){}
  public var a : Dynamic;
}
