package ;

import hx.Maybe;
import impl.Lense;
import types.Lense in TLense;

class Lenses {

  inline public static function mod<T, V>(l1 : TLense < T, V > , f : V -> V, a : T) : T  return
    l1.get(a).map(f).map(l1.set.bind(_,a)).getOrElse(a);

  public static function then < T, V, V0 > (l1 : TLense < T, V > , l2 : TLense < V, V0 > ) : Lense < T, V0 > return {
    get : function (a : T):Maybe<V0> return Maybe.flatten(l1.get(a).map(l2.get)),
    set : function (c : V0, a : T) : T return mod(l1, function (b) return l2.set(c, b), a)
  };

  inline public static function compose < T, V, V0 > ( l2 : Lense < V, V0 >, l1 : Lense < T, V > ) : Lense < T, V0 > return then(l1, l2);

  inline static public function get<T,V>(l1:Lense<T,V>,g:T):Maybe<V>{
    return l1.get(g);
  }
}
