import haxe.Json;
import sys.io.File;

class AirportCalc {
	private static var airports:Array<Airport> = [];

	public static function distance(x1:Float, x2:Float, y1:Float, y2:Float):Float {
		var dx = Math.abs(x1 - x2);
		var dy = Math.abs(y1 - y2);

		var d = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));

		return d;
	}

	public static function loadAirports() {
		var file = File.getContent("./data/airports.json");
		airports = Json.parse(file);
	}

	public static function calculate(lat:Float, lon:Float):String {
		var distsI:Array<String> = [];
		var distsD:Array<Float> = [];

		for (airport in airports) {
			if (airport.iata == "")
				continue;
			distsI.push(airport.icao);
			distsD.push(distance(lat, airport.lat, lon, airport.lon));
		}

		var combinedArray:Array<{str:String, fl:Float}> = [];
		for (i in 0...distsI.length) {
			combinedArray.push({str: distsI[i], fl: distsD[i]});
		}

		combinedArray.sort(function(a, b) {
			if (a.fl < b.fl)
				return -1;
			else if (a.fl > b.fl)
				return 1;
			else
				return 0;
		});

		return combinedArray[0].str;
	}
}
