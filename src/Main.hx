import famuz.Famuz;

// import sys.io.

class Main {
	static function main() {
		haxe.Log.trace = function(v:Dynamic, ?infos:haxe.PosInfos) {
			Sys.print(v+ "");
		}
		Famuz.parse("./data/test2.famuz");
	}
}
