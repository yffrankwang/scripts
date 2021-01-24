var whois = require('whois');
var args = process.argv;

for (var i = 2; i < args.length; i++) {
	whois.lookup(args[i], function(err, data) {
		console.log("===============================================================================");
		console.log(data)
	});
}
