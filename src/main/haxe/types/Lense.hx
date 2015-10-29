package types;

typedef Lense <T,V> = {
  get : T -> V,
  set : V -> T -> T
}