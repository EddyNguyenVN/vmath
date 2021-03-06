unit f;
    
interface

uses basic,programstr;

function ChkFile(FName:string):word;
procedure FileProcess(FName:string);
procedure RunFile(FName:string;w:byte);
procedure ReadLang(FName:string);
procedure ReadCfg;
// This Function will be implemented in version 1.0

implementation

uses lang;

function ChkFile(FName:string):word;
var f:text;
begin
	assign(f,FName);
	{$I-}
		Reset(f);
	{$I+}
	ChkFile:=IOResult;
end;

procedure VarCut(var s,val:string);
begin
	val:=copy(s,pos('=',s)+1,length(s)-pos('=',s));
	delete(s,pos('=',s),length(s)-pos('=',s)+1);
end;

procedure ReadCfgVar(s,val:string);
begin
	case Upcase(s) of
		'BGCOLOR'	:	if (Str2Int(val).check=True) and (Str2Int(val).value>=0) then bgcolor(Str2Int(val).value);
		'TXCOLOR'	:	if (Str2Int(val).check=True) and (Str2Int(val).value>=0) then txColor(Str2Int(val).value);
		'ERRHIDE'	:	if Str2Bool(val).check=True then ErrHide:=Str2Bool(val).value;
		'DEC'		:	if (Str2Int(val).check=True) and (Str2Int(val).value>=0) and (Str2Int(val).value<=20)
						then dec:=Str2Int(val).value;
	end;
end;

procedure ReadLangVar(s,val:string);
begin
	case Upcase(s) of
		'DONEMSG'		:	DoneMsg:=val;
		'WELCOMEMSG'	:	WelcomeMsg:=val+' '+ProgramInfo;
		'LOADTEXT'		:	LoadText:=val;
		'INPUTTEXT'		:	InputText:=val;
		'OUTPUTTEXT'	:	OutputText:=val;
		'EXITTEXT'		:	ExitText:=val;
		'GNOTENABLEDMSG':	GNotEnabledMsg:=val;
		'GENABLED'		:	GEnabledMsg:=val;
		'GDISABLEDMSG'	:	GDisabledMsg:=val;
		'GLOADMSG'		:	GLoadMsg:=val;
		'GCLOSEMSG'		:	GCloseMsg:=val;
	end;
end;

procedure ReadCfg;
var 
	val,s:string;
	f:text;
begin
	write(LoadText,'vmath.cfg');
	assign(f,'vmath.cfg');
	Reset(f);
	while not eoln(f) do begin
		readln(f,s);
		VarCut(s,val);
		if val<>'' then begin
			ReadCfgVar(s,val);
			writeln('[',s,']=',val);
		end;
	end;
end;

procedure ReadLang(FName:string);
var 
	val,s:string;
	f:text;
begin
	write('Reading Language');
	assign(f,FName);
	Reset(f);
	while not eoln(f) do begin
		readln(f,s);
		VarCut(s,val);
		if val<>'' then begin
			ReadLangVar(s,val);
			writeln('[',s,']:=',val);
		end;
	end;
end;

procedure RunFile(FName:string;w:byte);
var 
	f:text;
	str:string;
begin
	if pos('.',FName)=0 then FName:=FName+'.vmath';
	{$I-}
		assign(f,FName);
		Reset(f);
	{$I+}
	if IOResult = 0 then begin
		repeat
			readln(f,str);
			FileProcess(FName);
		until eof(f);
		close(f);
	end
	else if w = 1 then write(EReport(FName,ErrorID3));
end;

procedure FileProcess(FName:string);
begin
	// Truncate & Seek
end;

end.