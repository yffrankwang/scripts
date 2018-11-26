/******************************************************************************
  File Name		: activex.adodb.stream.js
  Description	: javascript adodb.stream wrap utility
  Reference		: http://msdn2.microsoft.com/en-us/library/ms675032.aspx
  Functions		: 
  Author		: asura@hotmail.com
  Last Updated	: 2007/11/10
******************************************************************************/

/*-----------------------------------------------------------------------------
	StreamTypeEnum
-----------------------------------------------------------------------------*/
var adTypeBinary 	= 1;		// Indicates binary data. 
var adTypeText 		= 2;		// Default. Indicates text data, which is in the character set specified by Charset.

/*-----------------------------------------------------------------------------
	ConnectModeEnum
-----------------------------------------------------------------------------*/
var adModeRead				= 1;			// Indicates read-only permissions.
var adModeReadWrite			= 3;			// Indicates read/write permissions.
var adModeRecursive			= 0x400000;		// Used in conjunction with the other *ShareDeny* values (adModeShareDenyNone, adModeShareDenyWrite, or adModeShareDenyRead) to propagate sharing restrictions to all sub-records of the current Record. It has no affect if the Record does not have any children. A run-time error is generated if it is used with adModeShareDenyNone only. However, it can be used with adModeShareDenyNone when combined with other values. For example, you can use "adModeRead Or adModeShareDenyNone Or adModeRecursive".
var adModeShareDenyNone		= 16;			// Allows others to open a connection with any permissions. Neither read nor write access can be denied to others.
var adModeShareDenyRead		= 4;			// Prevents others from opening a connection with read permissions.
var adModeShareDenyWrite	= 8;			// Prevents others from opening a connection with write permissions.
var adModeShareExclusive	= 12;			// Prevents others from opening a connection.
var adModeUnknown			= 0;			// Default. Indicates that the permissions have not yet been set or cannot be determined.
var adModeWrite				= 2;			// Indicates write-only permissions.

/*-----------------------------------------------------------------------------
	StreamOpenOptionsEnum
-----------------------------------------------------------------------------*/
var adOpenStreamAsync 		= 1;			// Opens the Stream object in asynchronous mode.
var adOpenStreamFromRecord 	= 4;			// Identifies the contents of the Source parameter to be an already open Record object. The default behavior is to treat Source as a URL that points directly to a node in a tree structure. The default stream associated with that node is opened.
var adOpenStreamUnspecified = -1;			// Default. Specifies opening the Stream object with default options.

/*-----------------------------------------------------------------------------
	StreamWriteEnum
-----------------------------------------------------------------------------*/
var adWriteChar = 0;	// Default. Writes the specified text string (specified by the Data parameter) to the Stream object.
var adWriteLine = 1;	// Writes a text string and a line separator character to a Stream object. If the LineSeparator property is not defined, then this returns a run-time error.

/*-----------------------------------------------------------------------------
	SaveOptionsEnum
-----------------------------------------------------------------------------*/
var adSaveCreateNotExist	= 1;		// Default. Creates a new file if the file specified by the FileName parameter does not already exist.
var adSaveCreateOverWrite 	= 2;		// Overwrites the file with the data from the currently open Stream object, if the file specified by the Filename parameter already exists.


/*-----------------------------------------------------------------------------
	STATFLAG
-----------------------------------------------------------------------------*/
var STATFLAG_DEFAULT	= 0;
var STATFLAG_NONAME		= 1;

/*-----------------------------------------------------------------------------
	LineSeparatorsEnum
-----------------------------------------------------------------------------*/
var adCR	= 13;		// Indicates carriage return.
var adCRLF	= -1;		// Default. Indicates carriage return line feed.
var adLF	= 10;		// Indicates line feed.

/*-----------------------------------------------------------------------------
	ObjectStateEnum
-----------------------------------------------------------------------------*/
var adStateClosed		= 0;		// Indicates that the object is closed.
var adStateOpen 		= 1;		// Indicates that the object is open.
var adStateConnecting 	= 2;		// Indicates that the object is connecting.
var adStateExecuting 	= 4;		// Indicates that the object is executing a command.
var adStateFetching 	= 8;		// Indicates that the rows of the object are being retrieved.

/*-----------------------------------------------------------------------------
	AdodbStream
-----------------------------------------------------------------------------*/
function AdodbStream() {
	this.stream = new ActiveXObject("ADODB.Stream");
	
	this.getCharset 		= _asGetCharset;
	this.setCharset 		= _asSetCharset;
	this.isEOS 				= _asIsEOS;
	this.getLineSeparator 	= _asGetLineSeparator;
	this.getMode			= _asGetMode;
	this.setMode			= _asSetMode;
	this.getPosition		= _asGetPosition;
	this.setPosition		= _asSetPosition;
	this.getSize			= _asGetSize;
	this.setSize			= _asSetSize;
	this.getState			= _asGetState;
	this.getType			= _asGetType;
	this.setType			= _asSetType;
	
	this.cancel				= _asCancel;
	this.close				= _asClose;
	this.copyTo				= _asCopyTo;
	this.flush				= _asFlush;
	this.loadFromFile		= _asLoadFromFile;
	this.open				= _asOpen;
	this.read				= _asRead;
	this.readText			= _asReadText;
	this.saveToFile			= _asSaveToFile;
	this.setEOS				= _asSetEOS;
	this.skipLine			= _asSkipLine;
	this.stat				= _asStat;
	this.write				= _asWrite;
	this.writeText			= _asWriteText;
}

// property
function _asGetCharset() {
	return this.stream.Charset;
}

function _asSetCharset(v) {
	this.stream.Charset = v;
}

function _asIsEOS() {
	return this.stream.EOS;
}

function _asGetLineSeparator() {
	return this.stream.LineSeparator;
}

function _asSetLineSeparator(v) {
	this.stream.LineSeparator = v;
}

function _asGetMode() {
	return this.stream.Mode;
}

function _asSetMode(v) {
	this.stream.Mode = v;
}

function _asGetPosition() {
	return this.stream.Position;
}

function _asSetPosition(v) {
	this.stream.Position = v;
}

function _asGetSize() {
	return this.stream.Size;
}

function _asSetSize(v) {
	this.stream.Size = v;
}

function _asGetState() {
	return this.stream.State;
}

function _asGetType() {
	return this.stream.Type;
}

function _asSetType(v) {
	this.stream.Type = v;
}

// methos
function _asCancel() {
	this.stream.Cancel();
}

function _asCopyTo(desStream, numChars) {
	this.stream.CopyTo(desStream, numChars);
}

function _asClose() {
	this.stream.Close();
}

function _asFlush() {
	this.stream.Flush();
}

function _asLoadFromFile(filename) {
	this.stream.LoadFromFile(filename);
}

function _asOpen(source, mode, openOptions, userName, password) {
	this.stream.Open(source, mode, openOptions, userName, password);
}

function _asRead(numBytes) {
	return this.stream.Read(numBytes);
}

function _asReadText(numChars) {
	this.stream.ReadText(numChars);
}

function _asSaveToFile(filename, options) {
	this.stream.SaveToFile(filename, options);
}

function _asSetEOS() {
	this.stream.SetEOS();
}

function _asSkipLine() {
	this.stream.skipLine();
}

function _asStart(statStg, statFlag) {
	this.stream.Start(statStg, statFlag);
}

function _asWrite(buffer) {
	this.stream.Write(buffer);
}

function _asWriteText(data, option) {
	this.stream.WriteText(data, option);
}


/* E.O.F */
