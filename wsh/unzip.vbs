Option Explicit

'-----------------------------------------------------------------------------
' @see http://bitdatasci.blogspot.com/2015/10/windowsoszipwsh.html
'-----------------------------------------------------------------------------
dim objShell, objWshShell, objFolder, ZipFile, i

if WScript.Arguments.Count < 1 or WScript.Arguments.Count > 2 then 
	WScript.Echo "Usage: CScript.exe unzip.vbs ZIPFile [objFolder]"
	WScript.Quit 
end if

Set objShell = CreateObject("shell.application")
Set objWshShell = WScript.CreateObject("WScript.Shell")
Set ZipFile = objShell.NameSpace (WScript.Arguments(0)).items
if WScript.Arguments.Count = 2 then
	' Specified target folder
	Set objFolder = objShell.NameSpace (WScript.Arguments(1))
else
	' Current directory
	Set objFolder = objShell.NameSpace (objWshShell.CurrentDirectory)
end if

' Hide Progress Dialog & [All YES]
objFolder.CopyHere ZipFile, &H14
