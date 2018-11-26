Set args = WScript.Arguments

If args.Count <> 2 Then
	WScript.Echo "mimemapa.vbs extension Type"
	WScript.Quit
End If

WScript.Echo "Add Mime Map " & args(0) & " " & args(1)

Const ADS_PROPERTY_UPDATE = 2 

Set oMimeMap = GetObject("IIS://localhost/mimemap")
aMimeMap = oMimeMap.GetEx("MimeMap")

i = UBound(aMimeMap) + 1
Redim Preserve aMimeMap(i)
Set aMimeMap(i) = CreateObject("MimeMap") 

aMimeMap(i).Extension = args(0)
aMimeMap(i).MimeType = args(1)
oMimeMap.PutEx ADS_PROPERTY_UPDATE, "MimeMap", aMimeMap 
oMimeMap.SetInfo 

ShowMM(oMimeMap) 

'Subroutine to display the mappings in a table. 
Sub ShowMM(MMObj) 
	
	aMM = MMObj.GetEx("MimeMap") 
	
	'Display the mappings in the table. 
	For Each MM in aMM 
		WScript.Echo MM.Extension & "    " & MM.MimeType 
	Next 
End Sub 
