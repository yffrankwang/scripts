Option Explicit

' テキスト→バイナリ
' 任意のファイルを、テキストにBase64変換します。
' 変換テーブルやパディングを変更可能です。（戻す時に同じ設定が必要になります）
' 戻す用のt2f.vbsは、Cr / Lf / (space) は無視しますので、変換文字には使えません
Dim TransTbl, PadChar, sp(5)
TransTbl = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
PadChar = "="
sp(1) = 2
sp(2) = 4
sp(3) = 6
sp(4) = 8
Const Non = 256
Const TblLen = 64
Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8
Const TristateUseDefault = -2	' システムデフォルトでファイルを開く
Const TristateTrue = -1			' ファイルをUnicodeファイルとして開く
Const TristateFalse = 0			' ファイルをASCIIファイルとして開く


Dim LogStream
' **********************************************************
' ログ出力
' **********************************************************
Function LogWrite(msg)
	If Not IsNull(LogStream) Then
		LogStream.Write msg
	End If
End Function

' **********************************************************
' 1Byteを二つに分割する
' **********************************************************
Function SplitByte(inData, up, down, split)
	up = Int(inData / (2 ^ split))
	down = inData Mod (2 ^ split)
End Function

' **********************************************************
' encode
' **********************************************************
Function encode(target)
	Dim spBuf(5,2), valid, outBuf, i, ret
	spBuf(0,1) = 0
	spBuf(4,0) = 0
	ret = ""

	' データを取得し、分割する
	valid = 3
	For i = 1 To 3
		' 上位Bit,下位Bitに分解する（取得失敗は、0にする）
		If target(i-1) = Non Then
			spBuf(i,0) = 0
			spBuf(i,1) = 0
		Else
			SplitByte target(i-1), spBuf(i,0), spBuf(i,1), sp(i)
			valid = valid - 1
		End If
		LogWrite CStr(target(i-1)) & "=" & CStr(spBuf(i,0)) & ":" & CStr(spBuf(i,1)) & " "
	Next
	' 出力する
	' ・(1-6Bit)
	' ・(1-2Bit)*(2^4)+(2-4Bit)
	' ・(2-4Bit)*(2^2)+(3-2Bit) or pad
	' ・(3-6Bit) or pad
	For i = 1 To 4
		outBuf = Mid(TransTbl, spBuf(i-1,1) * (2 ^ (8 - sp(i))) + spBuf(i,0) + 1, 1)
		If valid > 3 Then
			outBuf = PadChar
		End If
		ret = ret & outBuf
		LogWrite outBuf
		valid = valid + 1
	Next
	LogWrite Chr(13) & Chr(10)

	encode = ret
End Function



' **********************************************************
' main
' **********************************************************
Function main(target, outFile, table, pad, log)
	Dim fso, InStream, OutStream
	' Stream オブジェクト の作成
	Set fso = CreateObject("Scripting.FileSystemObject")

	' 変換テーブル用文字列を読込む（指定がない場合は、デフォルト）
	If Len(table) > 0 Then
		Set InStream = fso.OpenTextFile(table, ForReading, false, TristateUseDefault)
		TransTbl = InStream.Read(TblLen)
		InStream.Close
		Set InStream = Nothing
	End If
	' パディングが指定されている場合は、それを使う
	If Len(pad) > 0 Then
		PadChar = pad
	End If

	Set InStream = CreateObject("ADODB.Stream")
	InStream.Open
	InStream.Type = 1
	InStream.LoadFromFile target
	Set OutStream = fso.CreateTextFile(outFile, true)
	If Len(log) > 0 Then
		Set LogStream = fso.OpenTextFile(log, ForAppending, true, TristateUseDefault)
	Else
		LogStream = Null
	End If

	' 対象ファイルが終わるまで以下の処理を行う
	Dim inBuf, LoopF, i, buf(3)
	LoopF = 1
	Do While LoopF >= 0 And Not InStream.EOS
		' データを取得し、分割する
		For i = 0 To 2
			' 1Byte取得し、上位Bit,下位Bitに分解する（取得失敗は、0にする）
			If InStream.EOS Then
				LoopF = -2
				buf(i) = Non
			Else
				buf(i) = AscB(InStream.Read(1))
			End If
		Next
		LoopF = LoopF + 1
		' 出力する
		OutStream.Write encode(buf)
		If LoopF > 15 Then
			LoopF = 1
			OutStream.Write Chr(13) & Chr(10)
		End If
	Loop

	InStream.Close
	OutStream.Close
	If Not IsNull(LogStream) Then
		LogStream.Close
	End If
	Set InStream = Nothing
	Set OutStream = Nothing
	Set LogStream = Nothing
End Function


Dim arg(5), i
For i = 0 To 4
	If WScript.Arguments.length > i Then
		arg(i) = Wscript.Arguments(i)
	Else
		arg(i) = ""
	End If
Next

If WScript.Arguments.length < 2 Then
	WScript.Echo("basee <source file> <encoded file>")
	WScript.Quit(1)
End If

WScript.Echo("base64 encode [" + arg(0) + "] -> [" + arg(1) + "] ...")

main arg(0), arg(1), arg(2), arg(3), arg(4)

WScript.Echo "OK!"
