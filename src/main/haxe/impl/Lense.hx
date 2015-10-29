package impl;

import types.Lense in TLense;

@:forward abstract Lense<T,V>(TLense<T,V>) from TLense<T,V> to TLense<T,V>{
  inline public function mod(f : V -> V, a : T) : T  return this.set(f(this.get(a)), a);

  inline public function then<V1>(l2:TLense<V,V1>):Lense<T,V1> return {
    get : function (a : T) return l2.get(this.get(a)),
    set : function (c : V1, a : T) : T return mod(function (b) return l2.set(c, b), a)
  };
  inline public function compose<T0>(l2:Lense<T0, T>):Lense<T0,V> return Lenses.then(l2,this);
}
