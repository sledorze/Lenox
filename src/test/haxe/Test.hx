package;

using Lambda;

class Test{
  static function main(){
    new Test();
  }
  public function new(){
    var runner = new utest.Runner();
    utest.ui.Report.create(runner);
    var tests : Array<Dynamic> = [
      new LenseTest(),
      //new ModuleTest(),
    ];
    tests.iter(
      function(x){
        runner.addCase(x);
      }
    );
    runner.run();
  }
}
