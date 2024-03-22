import api.APIv1;
import hx_webserver.HTTPRequest;
import hx_webserver.HTTPServer;

class Main {
	private static var webserver:HTTPServer;

	private static function handleRequest(req:HTTPRequest) {
		var paths = req.methods[1].substr(1).split("?")[0].split("/");
		switch (paths[0]) {
			case "v1":
				APIv1.handle(req);
			default:
				req.reply("Invalid API version", 404);
		}
	}

	static function main() {
		trace("Loading airports...");
		AirportCalc.loadAirports();
		trace("Loaded airports");

		trace("Starting webserver...");
		webserver = new HTTPServer("0.0.0.0", 3000);
		webserver.onClientConnect = handleRequest;
		trace("Started webserver");
	}
}
