package stx;

using StringTools;

class Strings{
  /**
		Returns `true` if `frag` is at the end of `v`, `false` otherwise.
	**/
  static public function endsWith(v: String, frag: String): Bool {
    return if (v.length >= frag.length && frag == v.substr(v.length - frag.length)) true else false;
  }
  /**
		Returns a unique identifier, each `x` replaced with a hex character.
	**/
  static public function uuid(value : String = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx') : String {
    var reg = ~/[xy]/g;
    return reg.map(value, function(reg) {
        var r = Std.int(Math.random() * 16) | 0;
        var v = reg.matched(0) == 'x' ? r : (r & 0x3 | 0x8);
        return v.hex();
    }).toLowerCase();
  }
}
