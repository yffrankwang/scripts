' b64e.vbs encodes file by Base64.
' Usage: b64e.vbs file [outfile]

Option Explicit
Dim sFile
Dim dFile

Select Case WScript.Arguments.Count
Case 2
  sFile = WScript.Arguments.Item(0)
  dFile = WScript.Arguments.Item(1)
Case 1
  sFile = WScript.Arguments.Item(0)
  dFile = sFile & ".txt"
Case Else
  WScript.Echo "Usage: b64e.vbs file [outfile]"
  WScript.Quit
End Select

Const adTypeBinary = 1
Dim Src
Dim Dst
Dim Bin
Dim Dom
Dim Tmp
Dim fso

Set Src = CreateObject("ADODB.Stream")
Src.Type = adTypeBinary
Src.Open
Src.LoadFromFile sFile
Src.Position = 0
Bin = Src.Read
Src.Close

Set Dom = CreateObject("Microsoft.XMLDOM")
Set Tmp = Dom.CreateElement("tmp")
Tmp.DataType = "bin.base64"
Tmp.NodeTypedValue = Bin

Set fso = CreateObject("Scripting.FileSystemObject")
fso.CreateTextFile(dFile, False).Write Replace(Tmp.Text, vbLf, vbCrLf) 

