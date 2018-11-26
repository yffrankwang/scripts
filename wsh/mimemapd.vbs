Set args = WScript.Arguments

If args.Count <> 1 Then
	WScript.Echo "mimemapd.vbs extension"
	WScript.Quit
End If

WScript.Echo "Delete Mime Map " & args(0)

Const ADS_PROPERTY_UPDATE = 2 

Set oMimeMap = GetObject("IIS://localhost/mimemap")
aMimeMap = oMimeMap.GetEx("MimeMap")

Dim aMimeMapNew()

i = 0 
For Each MMItem in aMimeMap 
	If MMItem.Extension <> args(0) Then 
		Redim Preserve aMimeMapNew(i) 
		Set aMimeMapNew(i) = CreateObject("MimeMap") 
		aMimeMapNew(i).Extension = MMItem.Extension 
		aMimeMapNew(i).MimeType = MMItem.MimeType 
		i = i + 1 
	End If 
Next 

oMimeMap.PutEx ADS_PROPERTY_UPDATE, "MimeMap", aMimeMapNew 
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
