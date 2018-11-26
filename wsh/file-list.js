var args = WScript.Arguments;
var fso = new ActiveXObject("Scripting.FileSystemObject");

var dir = fso.getFolder(".");

var fos;

if (args.length > 0) {
	fos = fso.CreateTextFile(args(0), true, true);
}

WScript.Echo(dir.Name);
WScript.Echo("------------------------------------------------");

var fe = new Enumerator(dir.files);

for (; !fe.atEnd(); fe.moveNext()) {
	var f = fe.item();
	
	WScript.Echo(f.Name);
	
	if (fos) {
		fos.WriteLine(f.Name);
	}
}

