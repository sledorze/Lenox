package;

import impl.Lense;

import utest.Assert.*;

import LensesComplex0;

import Lenser;

class LenseTest{
  public function new(){}

  public function testClassLenseBuild(){
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

}
