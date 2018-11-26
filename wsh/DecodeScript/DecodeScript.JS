// DecodeScript.JS V1.01 (C) yoshioka.teruo@nifty.com 2005-07-09
// DecodeScript.JS decodes script.
// Usage: Start DecodeScript.JS file

var fso=new ActiveXObject("Scripting.FileSystemObject");
var file=fso.OpenTextFile(WScript.Arguments.Item(0));
var BeginComment='/*';
var EndComment='*/';
switch(fso.GetExtensionName(WScript.Arguments.Item(0)).toLowerCase()){
case 'jse':BeginComment='';EndComment='';break;
}
var SC=new ActiveXObject("ScriptControl");
SC.Language="JScript.Encode";
SC.AllowUI=true;
SC.TimeOut=-1;
SC.AddObject("WScript",WScript,true);
try{
  SC.AddCode('function main(){'+BeginComment+'\r\n\r\n'+file.ReadAll().replace(String.fromCharCode(0),'')+'\r\n'+EndComment+'}');
}catch(e){
  WScript.Echo(new Array(
    "Error:\t" + e,
    "Number:\t" + SC.Error.Number,
    "Description:\t" + SC.Error.Description,
    "Source:\t" + SC.Error.Source,
    "Text:\t" + SC.Error.Text,
    "Line:\t" + SC.Error.Line,
    "Column:\t" + SC.Error.Column).join('\n'));
  WScript.Quit(SC.Error.Number);
}
file.close();
var global=SC.CodeObject;
for(var p in global)if(typeof(global[p])=='function')break;
file=fso.CreateTextFile(WScript.Arguments(0)+".TXT");
file.Write(global[p]); 
file.close();
WScript.Echo(global[p]);
