Option Explicit

Const ENCODE_UNICODE = "unicode"

' StreamTypeEnum
Const adTypeBinary = 1
Const adTypeText = 2

'*********************************************************************
' ByteStreamクラス
' version 1.1
'*********************************************************************
Class ByteStream
	Private innerArray(255)
	'=================================================================
	' クラスの初期化処理
	'=================================================================
	Private Sub Class_Initialize()

		Dim wkStream
		Set wkStream = WScript.CreateObject("ADODB.Stream")
		wkStream.Type = adTypeText
		wkStream.Charset = ENCODE_UNICODE
		wkStream.Open

		Dim i
		For i=0 To &hff
			wkStream.WriteText ChrW(i)
		Next
		wkStream.Position = 0
		wkStream.Type = adTypeBinary

		If ("fe" = LCase(Hex(AscB(wkStream.Read(1))))) Then
			wkStream.Position = 2
		End If

		For i=0 To &hff
			wkStream.Position = wkStream.Position + 1
			innerArray(i) = wkStream.Read(1)
		Next

		wkStream.Close
		Set wkStream = Nothing
	End Sub
	'=================================================================
	' 指定した数値のByte()を返す
	'=================================================================
	Public Function getByte(num)
		If (num < 0) Or (UBound(innerArray) < num) Then
			getByte = innerArray(0) '0x00を返す
		Else
			getByte = innerArray(num)
		End If
	End Function
End Class



' テキスト→バイナリ
' f2t.vbsが変換したテキストファイルをバイナリに戻す
' Cr / Lf / (space) は無視しますので、変換文字には使えません
Dim TransTbl, PadChar, SecondTbl, sp(4)
TransTbl = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
SecondTbl = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
PadChar = "="
sp(0) = 6
sp(1) = 4
sp(2) = 2
sp(3) = 0
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

Dim mDecodeIndex, mDecode(4)
mDecodeIndex = 0
' **********************************************************
' decode
' **********************************************************
Function decode(target)
	' 内部バッファに蓄える
	If Asc(target) <> 10 And Asc(target) <> 13 And Asc(target) <> 32 Then
		mDecode(mDecodeIndex) = target
		mDecodeIndex = mDecodeIndex + 1
	End If
	If mDecodeIndex < 4 Then
		decode = Null
		Exit Function
	End If
	mDecodeIndex = 0

	Dim inBuf, spBuf(4,3), i, outBuf, ret(3)
	' 4文字読込み、それぞれを数字にする
	' 上位Bit,下位Bitに分解する
	For i = 0 To 3
		inBuf = mDecode(i)
		LogWrite inBuf
		spBuf(i,0) = Instr(TransTbl, inBuf)
		If IsNull(spBuf(i,0)) Then
			spBuf(i,0) = Instr(SecondTbl, inBuf)
		End If
		If IsNull(spBuf(i,0)) Then
			spBuf(i,1) = 0
			spBuf(i,2) = 0
		Else
			spBuf(i,0) = spBuf(i,0) - 1
			SplitByte spBuf(i,0), spBuf(i,1), spBuf(i,2), sp(i)
		End If
	Next
	For i = 0 To 3
		LogWrite " " & CStr(spBuf(i,0)) & "=" & CStr(spBuf(i,1)) & ":" & CStr(spBuf(i,2))
	Next

	' 合成して出力する
	For i = 0 To 2
		If spBuf(i+1,0) < TblLen Then
			ret(i) = spBuf(i,2) * (2 ^ (8 - sp(i))) + spBuf(i+1,1)
		Else
			ret(i) = Non
		End If
		LogWrite " " & CStr(ret(i))
	Next
	LogWrite Chr(13) & Chr(10)

	decode = ret
End Function



' **********************************************************
' main
' **********************************************************
Function main(target, outFile, table, pad, log)
	Dim fso, InStream, OutStream, bstream
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
	TransTbl = TransTbl & PadChar
	SecondTbl = SecondTbl & PadChar

	Set InStream = fso.OpenTextFile(target, ForReading, false, TristateUseDefault)
	Set OutStream = CreateObject("ADODB.Stream")
	OutStream.Type = adTypeBinary
	OutStream.Open
	Set bstream = New ByteStream
	If Len(log) > 0 Then
		Set LogStream = fso.OpenTextFile(log, ForAppending, true, TristateUseDefault)
	Else
		LogStream = Null
	End If

	' 対象ファイルが終わるまで以下の処理を行う
	Dim inBuf, buf, i, trans
	Do While (Not InStream.AtEndOfStream)
		' 4文字読込み、それぞれを数字にする
		inBuf = InStream.Read(1)
		' 合成して出力する
		buf = decode(inBuf)
		If Not IsNull(buf) Then
			For i = 0 To 2
				If buf(i) < Non Then
					OutStream.Write bstream.getByte(buf(i))
				End If
			Next
		End If
	Loop

	InStream.Close
	OutStream.SaveToFile outFile, 2
	OutStream.Flush
	OutStream.Close
	If Not IsNull(LogStream) Then
		LogStream.Close
	End If
	Set InStream = Nothing
	Set OutStream = Nothing
	Set bstream = Nothing
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
	WScript.Echo("based <encoded file> <decoded file>")
	WScript.Quit(1)
End If

WScript.Echo("base64 decode [" + arg(0) + "] -> [" + arg(1) + "] ...")

main arg(0), arg(1), arg(2), arg(3), arg(4)

WScript.Echo "OK!"
