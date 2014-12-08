package ;

/**
 * ...
 * @author sledorze
 */

typedef Lense < A, B > = {
  get : A -> B,
  set : B -> A -> A
}

class LenseExtension {

  inline public static function mod<A, B>(l1 : Lense < A, B > , f : B -> B, a : A) : A  return
    l1.set(f(l1.get(a)), a);

  public static function andThen < A, B, C > (l1 : Lense < A, B > , l2 : Lense < B, C > ) : Lense < A, C > return {
    get : function (a : A) return l2.get(l1.get(a)),
    set : function (c : C, a : A) : A return mod(l1, function (b) return l2.set(c, b), a)
  };
  
  inline public static function compose < A, B, C > ( l2 : Lense < B, C >, l1 : Lense < A, B > ) : Lense < A, C > return andThen(l1, l2);
}

class LenseSyntactic {
  
  inline public static function set<A, B>(a : A, l : Lense<A, B>, v : B) : A return
    l.set(v, a);

  inline public static function get<A, B>(a : A, l : Lense<A, B>) : B return
    l.get(a);
   
  inline public static function mod < A, B > (a : A, l : Lense < A, B > , f : B -> B) : A return
    LenseExtension.mod(l, f, a);
}