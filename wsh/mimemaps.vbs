Option Explicit

Dim oMimeMap
Dim vMimeMap
Dim aMimeMap
Dim nCount

Set oMimeMap = GetObject("IIS://localhost/mimemap")
vMimeMap = oMimeMap.GetEx("MimeMap")

If IsArray(vMimeMap) Then
	ReDim aMimeMap(UBound(vMimeMap), 1)
	For nCount = 0 To UBound(vMimeMap)
		aMimeMap(nCount, 0) = CStr(vMimeMap(nCount).Extension)
		aMimeMap(nCount, 1) = CStr(vMimeMap(nCount).MimeType)
	Next
	
	SortArray aMimeMap,0
	
	WScript.Echo "<?xml version=""1.0"" encoding=""UTF-8""?>"
	'WScript.Echo "<mime-mapping count=""" & UBound(aMimeMap) + 1 & """>"
	WScript.Echo "<root>"
	For nCount = 0 To UBound(aMimeMap)
		WScript.Echo vbTab & "<item key=""" & (aMimeMap(nCount, 0)) & """ " & _
			"value=""" & aMimeMap(nCount, 1) & """ />"
	Next
	WScript.Echo "</root>"
End If

Function SortArray(ary,intSort)
	Dim X,Y,Z
	Z = UBound(ary, 1)
	For X = 0 to (Z - 1)
		For Y = X + 1 to Z
			If StrComp(ary(X,intSort),ary(Y,intSort),vbTextCompare) > 0 Then
				ChangeAryItem ary, X, Y
			End If
		Next
	Next
End Function

Function ChangeAryItem(ary, X, Y)
	Dim I
	Dim Z
	Dim T()
	
	Z = UBound(ary, 2)
	ReDim T(Z)
	
	For I = 0 to Z
		T(I) = ary(X, I)
	Next

	For I = 0 to Z
		ary(X, I) = ary(Y, I)
	Next

	For I = 0 to Z
		ary(Y, I) = T(I)
	Next

End Function
