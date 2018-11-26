Option Explicit

Const dictKey	= 1
Const dictItem	= 2
Dim oMimeMap
Dim vMimeMap
Dim nMimeMap
Dim oDict
Dim nCount

Set oDict = CreateObject("Scripting.Dictionary")
Set oMimeMap = GetObject("IIS://localhost/mimemap")
vMimeMap = oMimeMap.Get("MimeMap")

If IsArray(vMimeMap) Then
	For nCount = LBound(vMimeMap) To UBound(vMimeMap)
		oDict.Add vMimeMap(nCount).Extension, vMimeMap(nCount).MimeType
	Next
	SortDictionary oDict,dictKey
	nMimeMap = oDict.Count
	WScript.Echo "Total MIME Map Entries: " & nMimeMap & vbCrLf
	WScript.Echo "Extension" & vbTab & "MIME Type"
	For Each vMimeMap in oDict
		WScript.Echo vMimeMap & vbTab & oDict(vMimeMap)
	Next
End If

Function SortDictionary(objDict,intSort)
	Dim strDict()
	Dim objKey
	Dim strKey,strItem
	Dim X,Y,Z
	Z = objDict.Count
	If Z > 1 Then
		ReDim strDict(Z,2)
		X = 0
		For Each objKey In objDict
			strDict(X,dictKey)	= CStr(objKey)
			strDict(X,dictItem) = CStr(objDict(objKey))
			X = X + 1
		Next
		For X = 0 to (Z - 2)
			For Y = X to (Z - 1)
				If StrComp(strDict(X,intSort),strDict(Y,intSort),vbTextCompare) > 0 Then
					strKey	= strDict(X,dictKey)
					strItem = strDict(X,dictItem)
					strDict(X,dictKey)	= strDict(Y,dictKey)
					strDict(X,dictItem) = strDict(Y,dictItem)
					strDict(Y,dictKey)	= strKey
					strDict(Y,dictItem) = strItem
				End If
			Next
		Next
		objDict.RemoveAll
		For X = 0 to (Z - 1)
			objDict.Add strDict(X,dictKey), strDict(X,dictItem)
		Next
	End If
End Function
