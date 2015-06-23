package ;

using haxe.ds.Option;

/**
 * ...
 * @author sledorze
 */

typedef Optional < A, B > = {
  getOption : A -> Option<B>,
  set : B -> A -> A
}

class OptionalExtension {

  inline public static function mod<A, B>(opt : Optional < A, B > , f : B -> B, a : A) : A  return
    switch (opt.getOption(a)){
      case Some(x): opt.set(f(x), a);
      case None: a;
    }

  inline public static function modOption<A, B>(opt : Optional < A, B > , f : B -> B, a : A) : Option<A>  return
    switch (opt.getOption(a)){
      case Some(x): Some(opt.set(f(x), a));
      case None: None;
    }

  public static function compose < A, B, C > (opt1 : Optional < A, B > , opt2 : Optional < B, C > ) : Optional < A, C > return {
    getOption : function (a : A) return
      switch (opt1.getOption(a)) {
        case Some(x) : opt2.getOption(x);
        case None : None;
      },
    set : function (c : C, a : A) : A return mod(opt1, function (b) return opt2.set(c, b), a)
  };
  
}
