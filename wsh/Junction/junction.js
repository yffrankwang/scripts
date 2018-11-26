if (typeof String.prototype.trim == "undefined") {
	String.prototype.trim = function() { 
		return this.replace(/^[\s\u3000]+|[\s\u3000]+$/g, ""); 
	} 
}

var sTarget = null;
var sJunction = null;
var msg = null;
var fso = new ActiveXObject("Scripting.FileSystemObject");
var wShell = WScript.CreateObject("WScript.Shell");
var cDialog = new ActiveXObject("UserAccounts.CommonDialog");

var objArgs = WScript.Arguments;
if (objArgs.length == 1) {
	sTarget = objArgs(0);
}
else if (objArgs.length == 2) {
	sTarget = objArgs(0);
	sJunction = objArgs(1);
}
else {
   wShell.Popup("Junction.js <junction target> <junction directory>", 3, "Parameter Error", 16);
   WScript.Quit();
}

if (sTarget == null) {
}

if (fso.FolderExists(sTarget)) {
	if (sJunction == null) {
		WScript.StdOut.WriteLine("Please input the junction directory:");
		WScript.StdOut.Write("[" + sTarget + "] <-- ");
		
		cDialog.Filter = "All Files(*.*)|*.*";
		if (cDialog.ShowOpen() != 0) {
			sJunction = cDialog.FileName;
			WScript.StdOut.WriteLine(sJunction);
		}
		else {
			WScript.Quit();
		}
	}

	var s;
	
	s = "Create junction [" + sJunction + "] --> [" + sTarget + "] ... ";
	msg = s;
	WScript.StdOut.Write(s);

	var oExec = wShell.Exec("junction.exe \"" + sJunction + "\" \"" + sTarget + "\"");
	
	while (oExec.Status == 0) {
	     WScript.Sleep(100);
	}

	s = oExec.ExitCode == 0 ? "OK!" : "FAILED!";
	msg += s + "    \r\n";
	WScript.StdOut.WriteLine(s);

	while (!oExec.StdOut.AtEndOfStream) {
		s = oExec.StdOut.ReadLine();
		msg += s + "    \r\n";
		WScript.StdOut.WriteLine(s);
	}

	if (oExec.ExitCode == 0) {
		msg = null;
	}
}
else {
	msg = "Create junction [" + sJunction + "] --> [" + sTarget + "] ... FAILED!";
	msg += "    \r\n\r\n";
	msg += "Target directory [" + sTarget + "] dos not exists!";
	msg += "    \r\n\r\n";
}

if (msg != null) {
	wShell.Popup(msg, 3, "Junction Error", 16);
}

