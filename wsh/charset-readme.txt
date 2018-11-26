JavaScript の文字コード処理に関する覚書
by kanegon

2003.05.07 create
2003.05.11 update


JavaScript の内部(?)文字コードは UNICODE であり、UNICODE 以外の文字コードをう
まく処理できない。ファイルの入出力には FileSystemObject を使うことで ANSI
(ShiftJIS) での読み書きは可能だがファイルの入出力に限られている。

JavaScript ではそれに加えてコード列をバイナリ(バイト配列)として処理することも
できないため、これが時として非常に不便である。

バイナリデータが処理できないのは「ブラウザ組み込みのスクリプト言語」としては
妥当な仕様かも知れないが、「Windows 標準搭載のスクリプト言語」としてとらえる
と、テキストを UNICODE に変換せず、バイト列として処理したいという要求もでてく
る。

あと、ShiftJIS や EUC をスクリプトレベルで変換できたりすると便利である。

というわけで以下、文字コードに関するメモである。


- 言語による文字コードの扱いの違い

 [JavaScript]

  - インタフェースはすべて UNICODE となる
    特定の文字の文字コードを取得したり、文字コードから文字列を作成したりする
    場合、使用するコードはすべて UNICODE となる。
    文字の扱いとして半角・全角の区別はない。

  - バイナリ(バイト配列)を扱うことができない
    WinHttp や ADODB.Stream などのコンポーネントが生成するバイナリデータをオ
    ブジェクトとして中継することはできるが、内部データにアクセスすることがで
    きない。(data[0] などのように要素にアクセスできない)

  - ファイルI/O では ANSI(ShiftJIS) または UNICODE が選択可能
    ファイルの入出力には一般に FileSystemObject を使用する。FileSystemObject
    では ANSI(ShiftJIS) または UNICODE をサポートしているため、いずれかの形式
    を選択して処理できる。

  - ADODB.Stream によって任意の CHARSET で入出力可能
    FileSystemObject ほど有名ではないが、ファイル入出力に FileSystemObject で
    なく、ADODB.Stream を使用することもできる。
    この場合、任意の CHARSET を指定してのファイルの入出力が可能になる。
    指定可能なコードのしては JIS, ShiftJIS, EUC, UTF8, UNICODE(UCS2)などがあ
    り、基本的なものは一通りそろっている。


 [VSScript]

  - インタフェースは ANSI(ShiftJIS)、バイナリ、UNICODE の３種類を持つ
    コード処理のインタフェースとして ANSI(ShiftJIS)、バイナリ、UNICODE の３種
    類を持ち、関数名の後ろに W(UNICODE)、または B(バイナリ) をつけた別関数を
    提供している。
    ShiftJIS の処理は比較的容易。
    文字列をバイト単位で処理することも可能。
    バイナリ処理関数で文字列から文字を 1バイト切り出したとき、取得されるコー
    ドは UNICODE の断片となる。内部コードは UNICODE と推測される。

  - バイナリ(バイト配列)をサポート
    WinHttp や ADODB.Stream などのコンポーネントが生成するバイナリデータを文
    字列のように LenB、MidB、AscB などで処理できる。
    ただし、バイナリデータを新規に生成することはできない(たぶん)。

  - ファイルI/O では ANSI(ShiftJIS) または UNICODE が選択可能
    JavaScript の説明に同じ
    外部コンポーネント(FileSystemObject)を使う限りにおいて、言語による機能の
    差異はない。

  - ADODB.Stream によって任意の CHARSET で入出力可能
    JavaScript の説明に同じ
    外部コンポーネントを使う限りにおいて、言語による機能の差異はない。


- 文字コード関連関数

[JavaScript]

String.charAt(index)      指定された位置の文字を返す
String.charCodeAt(index)  指定された位置の文字の Unicode コードを整数値で返す
String.fromCharCode(code1, ...codeN);
                          Unicode のコード値から文字列を作成する

[VBScript]

Chr(code)             指定された ANSI コードまたは ShiftJIS コードに対応する
                      文字を返す
ChrW(code)             〃 (Unicode版)
Asc(str)              指定された文字列内の、最初の文字の ANSI コードまたは
                      ShiftJIS コードを返す
AscB(str)              〃 (バイナリ版 --- UNICODE データの先頭1byteを返す)
AscW(str)              〃 (Unicode版)
Len(str|var)          指定された文字列の文字数または変数を格納するに必要なバ
                      イト数を返す
                      (文字列の場合には文字数なので半角全角にかかわらず1byte)
LenB(str|var)          〃 (バイナリ版 --- UNICODE のバイト数、半角全角にかか
                      わらず2byte)
Mid(str, start, len)  文字列から指定された文字数分の文字列を返す
MidB(str, start, len)  〃 (バイナリ版 --- UNICODE データ列から指定バイトを切
                      り出し)
                      (半角文字の2byte目はコード 0 のまま切り出される)

※ VBScript では基本が ANSI (ShiftJIS) コードになっているが、
   バイナリアクセスを行う場合には内部コードを UNICODE として意識する必要がある
   ので注意


- FileSystemObject について

FileSystemObject(FSO) はスクリプトでファイルを扱う場合に使用する標準的なコン
ポーネントである。

FSO はドライブやフォルダ、ファイルについての情報取得や操作が可能だが、ここでは
ファイルの入出力について述べる。
FSO は TextStream オブジェクトによってテキスト ファイルの作成および操作が可能
である。バイナリ ファイルの作成および操作については、サポート予定となっている
が、まだ実装されておらず、テキストのみの対応となっている。
FSO の実体はスクリプティング タイプ ライブラリ (Scrrun.dll) にある。

テキストファイルの読み書きでは ANSI(ShiftJIS)、または UNICODE の読み書きのみ
可能。読み込んだ結果は UNICODE となる。

FileSystemObject についてはいくらでもサンプルがころがっているのでそれらを参照
のこと。


- ADODB.Stream について

あまり標準的ではないが、ファイルの読み書きにおいては FileSystemObject よりも
いろいろできて便利。特に文字コードを任意に指定できるのがよい。バイナリの入出
力も可能。

以下に示すコードで ShiftJIS のファイルから EUC、JIS、UTF8 のファイルを生成で
きる。

var adTypeText = 2;
var adSaveCreateOverWrite = 2;

// テキスト ファイル出力
function SaveText(filename, text, charset)
{
    var stm = new ActiveXObject("ADODB.Stream");
    stm.Type = adTypeText;
    stm.Charset = charset;
    stm.Open();
    stm.WriteText(text);
    stm.SaveToFile(filename, adSaveCreateOverWrite);
}

// テキスト ファイル入力
function LoadText(filename, charset)
{
    var stm = new ActiveXObject("ADODB.Stream");
    stm.Type = adTypeText;
    stm.Charset = charset;
    stm.Open();
    stm.LoadFromFile(filename);
    var text = stm.ReadText();
    return text;
}

var text;

// ShiftJIS => EUC
text = LoadText("sjis.txt", "shift_jis");
SaveText("euc.txt", text, "x-euc-jp");

// EUC => JIS
text = LoadText("euc.txt", "x-euc-jp");
SaveText("jis.txt", text, "iso-2022-jp");

// JIS => UTF-8
text = LoadText("jis.txt", "iso-2022-jp");
SaveText("utf8.txt", text, "UTF-8");


- JavaScript によるバイナリデータ操作 (参照)

JavaScript にはバイナリ操作の機能はなく、上記 ADODB.Stream が返すバイナリデー
タもオブジェクトの受け渡しはできるものの要素にアクセスすることはできない。
この ADODB.Stream が返すバイナリデータ(たぶんバイトを要素とするVariant配列)は
VBScript なら割と素直に扱えるみたいだが、JavaScript の VBArray にも渡そうとし
ても失敗する。

ようするに VBScript でアプリケーションを記述すればバイナリ操作(参照のみ)は標準
の機能で実現可能になるわけだが、個人的に VBScript は好きでないので、なるべく
JavaScript で書きたいという別の問題もある。
しかし、できないものはしょうがないので VBScript に処理はさせるが、JavaScript
側にそのラッパを用意し、VBScript を隠蔽することで問題を回避してみる。

以下、その実装サンプルの Binary クラス。なおこのクラスはデータの参照のみ可能
で更新には対応してない。

# VBScript を使用してもバイト要素の Variant 配列を新規に作成することはできない

// VBScript でサイズ取得と要素アクセスの関数を用意
var scVB = WScript.CreateObject("ScriptControl");
scVB.Language = "VBScript";
scVB.AddCode("Function vbBinary_getSize(text) : vbBinary_getSize = LenB(text) : End Function");
scVB.AddCode("Function vbBinary_At(text, index) : vbBinary_At = AscB(MidB(text, index + 1, 1)) : End Function");

// Binary クラスで VBScript を隠蔽
// Binary クラスには size プロパティと At() および charAt() メソッドを実装
function Binary(data)
{
    this.data = data;
    this.size = scVB.Run("vbBinary_getSize", this.data);
}

function Binary_At(index)
{
    if (index < 0 || index >= this.size)
        return 0;
    return scVB.Run("vbBinary_At", this.data, index);
}

function Binary_charAt(index)
{
    if (index < 0 || index >= this.size)
        return "";
    return String.fromCharCode(scVB.Run("vbBinary_At", this.data, index));
}

Binary.prototype.At = Binary_At;
Binary.prototype.charAt = Binary_charAt;

// 以下、使い方
var bin = new Binary(bindata);  // bindata は ADODB.Stream などが生成するバイナリデータ
var c = bin.At(0);              // 0バイト目の要素にバイナリアクセス
var size = bin.size;            // バイナリデータの全体サイズを取得


- JavaScript によるバイナリデータ操作 (データの作成)

スクリプトの標準関数ではバイナリデータを参照できても新規に作成することができ
ない。
しかし、ADODB.Stream がバイナリデータを吐くのならば、ADODB.Stream に作らせれ
ばよい、というわけで以下サンプル。

任意のコードから 1byte のバイナリデータを作成する関数と、2つのバイナリデータを
結合して1つのバイナリデータを生成する関数である。
あとはこの2つを泥臭く組み合わせればどんなバイト列でも生成可能なはず。
もちろん、泥臭い部分はクラスで隠蔽すること。


// 0～255 の数値を入力として、1byte のバイナリデータを返す
function CodeToBinary(code)
{
    // Charset="UNICODE" のエンコード指定で WriteText() すると、
    // String.fromCharCode(1) のように作成したデータが
    // "FFFE0100" のようなバイト列として出力される。
    // (文字列の先頭にエンディアン解釈のプレフィクスがつく)
    // しかし、文字解釈がおこなわれないため、0～255 のすべての
    // コードが生成可能 (us-ascii などを指定すると文字化けが発生する)
    var uc = String.fromCharCode(code);
    var stm = new ActiveXObject("ADODB.Stream");
    stm.Type = adTypeText;
    stm.Charset = "UNICODE";
    stm.Open();
    stm.WriteText(uc);
    stm.Position = 0;
    stm.Type = adTypeBinary;
    // 2byte 読み捨てて次の 1byte を返す
    // (あるいは2byte目のエンディアン情報を見て取得するバイトが
    // 3byte目か 4byte目かを決める(?))
    stm.Read(2);
    return stm.Read(1);
}

// 2つのバイナリデータを結合して、新しいバイナリデータを返す
function BinaryAdd(bin1, bin2)
{
    var stm = new ActiveXObject("ADODB.Stream");
    stm.Type = adTypeBinary;
    stm.Open();
    stm.Write(bin1);
    stm.Write(bin2);
    stm.Position = 0;
    return stm.Read();
}

※ もし速度を求めるなら最初に 0～255 を表す 256 個のバイナリデータを作成して
   おき、CodeToBinary(code) 関数内のコードは return bintable[code] のみとする
   やり方も考えられる。気持ち早くなる...かもしれない。
   もちろん本当に速度が重要ならバイナリデータ作成 ActiveX を作成するか、そも
   そも最初から言語としてスクリプトを選択していないとは思うが。
   バイナリデータ作成 ActiveX については Microsoft のサイトにサンプルがある。


- おまけ

// 任意の charset を指定してメモリ上でバイナリからテキストに変換する

function BinaryToText(buffer, charset)
{
    var stm = new ActiveXObject("ADODB.Stream");
    stm.Type = adTypeBinary;
    stm.Open();
    stm.Write(buffer);
    stm.Position = 0;
    stm.Type = adTypeText;
    stm.Charset = charset;
    return stm.ReadText();
}

