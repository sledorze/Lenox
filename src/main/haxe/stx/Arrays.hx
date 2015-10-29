package stx;

class Arrays{
  /**
		Adds a single element to the end of the Array.
	**/
  static public function add<T>(a: Array<T>, t: T): Array<T> {
    var copy = snapshot(a);

    copy.push(t);

    return copy;
  }
  /**
		Adds a single elements to the beginning if the Array.
	**/
  static public function cons<T>(a: Array<T>, t: T): Array<T> {
    var copy = snapshot(a);

    copy.unshift(t);

    return copy;
  } 
  /**
		Returns a copy of a.
	**/
  static public function snapshot<T>(a: Array<T>): Array<T> {
    return [].concat(a);
  }

}
