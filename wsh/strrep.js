var args = WScript.Arguments;
var stream = new ActiveXObject("ADODB.Stream");

/* -------   Const   -------- */
// StreamTypeEnum
// http://msdn.microsoft.com/en-us/library/windows/desktop/ms675277(v=vs.85).aspx
var adTypeBinary = 1;
var adTypeText   = 2;

// StreamReadEnum
// http://msdn.microsoft.com/en-us/library/windows/desktop/ms679794(v=vs.85).aspx
var adReadAll  = -1;
var adReadLine = -2;

// StreamWriteEnum
// http://msdn.microsoft.com/en-us/library/windows/desktop/ms678072(v=vs.85).aspx
var adWriteChar = 0;
var adWriteLine = 1;

// SaveOptionsEnum 
// http://msdn.microsoft.com/en-us/library/windows/desktop/ms676152(v=vs.85).aspx
var adSaveCreateNotExist  = 1;
var adSaveCreateOverWrite = 2;

function fread(inf, enc) {
	var sr = new ActiveXObject("ADODB.Stream");
	sr.Type = adTypeText;
	sr.charset = enc;
	sr.Open();
	sr.LoadFromFile(inf);
	var str = sr.ReadText(adReadAll);
	sr.Close();
	return str;
}

function fwrite(ouf, str, enc) {
	var sw = new ActiveXObject("ADODB.Stream");
	sw.Type = adTypeText;
	sw.charset = enc;
	sw.Open();
	sw.WriteText(str, adWriteChar);
	sw.SaveToFile(ouf, adSaveCreateOverWrite);
	sw.Close();
}

function main(reg, rep, inf, ouf, enc) {
	var so = fread(inf, enc);
	var sn = so.replace(new RegExp(reg, "g"), rep);
	fwrite(ouf, sn, enc);
}

//----------------------------------------------------------------
// main
//----------------------------------------------------------------
if (args.length < 4) {
	WScript.Echo("strrep.js <REGEXP> <REPSTR> <INFILE> <OUTFILE> [ENCODING]");
	WScript.Quit();
}
var enc = 'UTF-8';
if (args.length > 4) {
	enc = args(4);
}
main(args(0), args(1), args(2), args(3), enc);
