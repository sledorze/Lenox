package ;

import impl.Lense;
import types.Lense in TLense;
/**
 * ...
 * @author sledorze
 */


class Lenses {

  inline public static function mod<T, V>(l1 : TLense < T, V > , f : V -> V, a : T) : T  return
    l1.set(f(l1.get(a)), a);

  public static function then < T, V, V0 > (l1 : TLense < T, V > , l2 : TLense < V, V0 > ) : Lense < T, V0 > return {
    get : function (a : T) return l2.get(l1.get(a)),
    set : function (c : V0, a : T) : T return mod(l1, function (b) return l2.set(c, b), a)
  };

  inline public static function compose < T, V, V0 > ( l2 : Lense < V, V0 >, l1 : Lense < T, V > ) : Lense < T, V0 > return then(l1, l2);
}
