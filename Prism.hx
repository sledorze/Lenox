package ;

using haxe.ds.Option;

/**
 * ...
 * @author sledorze
 */

typedef Prism < A, B > = {
  getOption : A -> Option<B>,
  reverseGet : B -> A
}

class PrismExtension {

  inline public static function mod<A, B>(prism : Prism < A, B > , f : B -> B, a : A) : A  return  	
    switch (prism.getOption(a)) {
      case Some(x) : prism.reverseGet(f(x));
      case None: a;
    }

  inline public static function modOption<A, B>(prism : Prism < A, B > , f : B -> B, a : A) : Option<A>  return   
    switch (prism.getOption(a)) {
      case Some(x) : Some(prism.reverseGet(f(x)));
      case None: None;
    }

  public static function compose < A, B, C > (prism1 : Prism < A, B > , prism2 : Prism < B, C > ) : Prism < A, C > return {
    getOption : function (a : A) return switch (prism1.getOption(a)){
      case Some(x) : prism2.getOption(x);
      case None : None;
    },
    reverseGet : function (c : C) : A return prism1.reverseGet(prism2.reverseGet(c))
  };


  public static function composeIso < A, B, C > (prism1 : Prism < A, B > , iso2 : Iso < B, C > ) : Prism < A, C > return {
    getOption : function (a : A) return switch(prism1.getOption(a)) {
      case Some(x) : Some(iso2.get(x));
      case None : None;
    },
    reverseGet : function (c : C) : A return prism1.reverseGet(iso2.reverseGet(c))
  };

  public static function isoCompose < A, B, C > (iso : Iso < A, B > , prism : Prism < B, C > ) : Prism < A, C > return {
    getOption : function (a : A) return prism.getOption(iso.get(a)),
    reverseGet : function (c : C) : A return iso.reverseGet(prism.reverseGet(c))
  };


  public static function fromIso<A,B>(iso : Iso<A,B>) : Prism<A, B> return {
    getOption : function (a : A) return Some(iso.get(a)),
    reverseGet : iso.reverseGet  
  }

}

