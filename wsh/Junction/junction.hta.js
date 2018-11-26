var oShell = WScript.CreateObject("WScript.Shell")

var oArgs = WScript.Arguments;

var cmdline = "C:\\Tools\\System\\Junction\\junction.hta";

for (var i = 0; i < oArgs.length; i++) {
	cmdline += " \"" + oArgs(i) + "\"";
}

var oExec = oShell.Run(cmdline);
