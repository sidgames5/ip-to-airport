package api;

import haxe.Json;
import sys.Http;
import hx_webserver.HTTPRequest;

class APIv1 {
	public static function handle(req:HTTPRequest) {
		var options = req.methods[1].substr(1).split("?")[1].split("&");

		var ip = null;

		for (option in options) {
			var k = option.split("=")[0];
			var v = option.split("=")[1];

			switch (k) {
				case "ip":
					ip = v;
			}
		}

		if (ip == null) {
			req.reply("No IP provided", 400);
			return;
		}

		var lat = 0.0;
		var lon = 0.0;

		var posreq = new Http('http://ip-api.com/json/$ip');
		posreq.onData = d -> {
			var j = Json.parse(d);
			lat = j.lat;
			lon = j.lon;
		}
		posreq.request();

		req.reply(AirportCalc.calculate(lat, lon), 200);
	}
}
