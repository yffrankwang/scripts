var sJunction = null;
var wShell = WScript.CreateObject("WScript.Shell");

var objArgs = WScript.Arguments;
if (objArgs.length == 1) {
	sJunction = objArgs(0);
}
else {
   wShell.Popup("Junctiond.js <junction directory to delete>", 5, "Parameter Error", 16);
   WScript.Quit();
}

var r = wShell.Popup("Are you sure you want to delete [" + sJunction + "]?", 5, 
			"Comfirm Junction Delete", 4 + 32);
if (r == 6) {
	var title = "Delete Junction [" + sJunction + "]";

	var oExec = wShell.Exec("junction.exe -d \"" + sJunction + "\"");
	while (oExec.Status == 0) {
	     WScript.Sleep(100);
	}

	var msg = "";
	while (!oExec.StdOut.AtEndOfStream) {
		msg += oExec.StdOut.ReadLine() + "    \r\n";
	}

	wShell.Popup(msg, 5, title, 64);
}
