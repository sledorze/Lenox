package ;

/**
 * ...
 * @author sledorze
 */

typedef Iso < A, B > = {
  get : A -> B,
  reverseGet : B -> A
}

class IsoExtension {

  inline public static function mod<A, B>(iso : Iso < A, B > , f : B -> B, a : A) : A  return  	
    iso.reverseGet(f(iso.get(a)));

  public static function compose < A, B, C > (iso1 : Iso < A, B > , iso2 : Iso < B, C > ) : Iso < A, C > return {
    get : function (a : A) return iso2.get(iso1.get(a)),
    reverseGet : function (c : C) : A return iso1.reverseGet(iso2.reverseGet(c))
  };

  public static function reverse < A, B > (iso : Iso < A, B > ) : Iso < B, A > return {
    get : iso.reverseGet,
    reverseGet : iso.get
  };

}

