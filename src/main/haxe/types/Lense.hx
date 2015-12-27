package types;

import hx.Maybe;

typedef Lense <T,V> = {
  get : T -> Maybe<V>,
  set : V -> T -> T
}
