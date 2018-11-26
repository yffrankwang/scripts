var totalLines = 0;
var totalFiles = 0;
var filter = null;
var args = WScript.Arguments;
var fso = new ActiveXObject("Scripting.FileSystemObject");

function Help() {
	WScript.Echo("line.js [/ppath] [/s] [?] [ext1] [ext2] ... [extn]");
	WScript.Quit(0);
}

var dir = ".";
var sub = false;

for (var i = 0; i < args.length; i++)
{
	if (args(i) == "?") {
		Help();
	}
	else if (args(i).indexOf("/p") == 0) {
		dir = args(i).substring(2);
	}
	else if (args(i) == "/s") {
		sub = true;
	}
	else {
		if (filter == null) {
			filter = args(i).toLowerCase();
		}
		else {
			filter += "\n" + args(i).toLowerCase();
		}
	}
}

CountLines(fso.GetFolder(dir));

function CountLines(folder) {
	
	WScript.Echo("\n" + folder.Path + ":");
	
	var fc = new Enumerator(folder.Files);
	for (; !fc.atEnd(); fc.moveNext())
	{
		var f = fc.item();
		
		if (IsFileNeed(f)) {
			var line = CountFileLines(f);
			totalFiles++;
			totalLines += line;
			WScript.Echo("    " + f.Name + " - " + line);
		}
	}
	
	if (sub) {
		var fd = new Enumerator(folder.SubFolders);
		for (; !fd.atEnd(); fd.moveNext()) {
			var d = fd.item();
			CountLines(d);
		}
	}
}

WScript.Echo("\nTotal Files:" + totalFiles + ", Total Lines:" + totalLines);

function IsFileNeed(f) {
	if (filter == null)
		return true;
	
	var ext = fso.GetExtensionName(f.Name).toLowerCase();
	return filter.indexOf(ext) != -1;
}

function CountFileLines(f) {
	var a = f.OpenAsTextStream(1, false);
	while (!a.AtEndOfStream) {
		a.Skip(f.Size);
	}
	var lines = a.Line;
	a.Close(); 

	return lines;
}