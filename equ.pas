unit equ;
    
interface

uses 
	basic,math,lang,programStr;

type
	tNum = array[1..256]of longword;

var 
    err:word;

procedure Equation(s:string);
function EquProcess(s:string):extended;
//function VarProcess(s:shortstring);
function Bool(s:string):boolean;
procedure cqe2(a,b,c:extended);
function fact(num:Longword):string;
function NumInCheck(t:tStr;endNum:word):boolean;
function gcd(t:tNum;n:word):longword;

implementation

procedure Equation(s:string);
begin
    if (pos('=',s)<>0) or (pos('<',s)<>0) or (pos('>',s)<>0) then
        writeln(bool(ClrSpace(s)))
    else if (pos('+',s)<>0) or (pos('-',s)<>0) or (pos('*',s)<>0)
	    or (pos('/',s)<>0) or (pos('^',s)<>0) then
		begin
		   	ans:=EquProcess(ClrSpace(s));
		   	writeln(ans:0:dec);
		end
    else writeln(EReport(s,ErrorId1));
end;

procedure NumProcess(s:string;k:word; var n1,n2:extended);
begin
	n1:=EquProcess(copy(s,1,k-1));
	n2:=EquProcess(copy(s,k+1,(length(s)-k)));
end;

procedure BoolProcess(s:string;k:word; var n1,n2:boolean);
begin
	n1:=Bool(copy(s,1,k-1));
	n2:=Bool(copy(s,k+1,(length(s)-k)));
end;

function EquProcess(s:string):extended;
var 
	n1,n2:extended;
begin
	if (pos('+',s)<>0) then begin
		NumProcess(s,pos('+',s),n1,n2);
		EquProcess:=n1+n2;
	end
	else if (pos('-',s)<>0) then begin
		NumProcess(s,poslast('-',s),n1,n2);
		EquProcess:=n1-n2;
	end
	else if (pos('*',s)<>0) then begin
		NumProcess(s,pos('*',s),n1,n2);
		EquProcess:=n1*n2;
	end	
	else if (pos('/',s)<>0) then begin
		NumProcess(s,poslast('/',s),n1,n2);
		EquProcess:=n1/n2;
	end	
	else if (pos('^',s)<>0) then begin
		NumProcess(s,pos('^',s),n1,n2);
		EquProcess:=Power(n1,n2);
	end
	else if (Str2Num(s).Check=True) and (s<>'') then EquProcess:=Str2Num(s).value
            else {VarProcess} ;
end;
// Loop back EquProcess function if there is a complex Equation

function Bool(s:string):boolean;
var 
	n1,n2:extended;
	b1,b2:boolean;
begin
    bool := False;
	if (pos('|',s)<>0) then begin
		BoolProcess(s,pos('|',s),b1,b2);
        if (b1=True) or (b2=True) then bool:=True;
	end
	else if (pos('&',s)<>0) then begin
		BoolProcess(s,pos('&',s),b1,b2);
        if (b1=True) and (b2=True) then bool:=True;
	end
    else if (pos('=',s)<>0) then begin
        NumProcess(s,pos('=',s),n1,n2);
        if n1=n2 then bool:=True;
    end
    else if (pos('<',s)<>0) then begin
        NumProcess(s,pos('<',s),n1,n2);
        if n1<n2 then bool:=True;
    end
    else if (pos('>',s)<>0) then begin
        NumProcess(s,pos('>',s),n1,n2);
        if n1>n2 then bool:=True;
    end
end;
{
function VarProcess(s:shortstring);
begin
	case s of
		
	else writeln(EReport(s,ErrorId1))
	end;
end;
}
procedure cqe2(a,b,c:extended);
var 
    delta:extended;
begin
    if a<>0 then begin
	    delta:=(b*b-4*a*c);
	    if delta<0 then writeln(cqe0Text)
    	else if delta>0 then writeln(cqe2Text,'x1= ',((-b+delta)/(2*a)):0:dec,' | x2= ',((-b-delta)/(2*a)):0:dec)
        else writeln(cqe1Text,(-b/(2*a)):0:dec);
    end
    else writeln(EReport('',ErrorId1));
end;
    
function fact(num:Longword):string;
var 
	i,k:longword;
	c,count,check:word;
begin
	check:=0;fact:='';
	for k:=2 to num do begin
		c:=0;count:=0;
		for i:=1 to k do
			if k mod i = 0 then inc(c);
		if c=2 then
			while num mod k = 0 do begin
				num:=num div k;
				inc(count);
			end;
		if count = 1 then
			begin
				if check=0 then inc(check)
					else Fact:=Fact+' * ';
				Fact:=Fact+Num2Str(k,0);
			end
		else if count > 1 then
			begin
				if check=0 then inc(check)
					else Fact:=Fact+' * ';
				Fact:=Fact+Num2Str(k,0)+'^'+Num2Str(count,0);
			end;
	end;
end;

function NumInCheck(t:tStr;endNum:word):boolean;
var i:word;
begin
	NumInCheck:=true;
	for i:=1 to endNum do if (Str2Int(t[i]).check=false)
		or (Str2Int(t[i]).value<=0) then NumInCheck:=false;
	if NumInCheck=False then writeln(EReport('',ErrorId4));
end;

function gcd(t:tNum;n:word):longword;
var 
	i,k:longword;
	c,j:word;
begin
	k:=t[1];
	for i:=2 to n do
		if t[i]<k then k:=t[i];
	gcd:=1;
	for i:=2 to k do begin
		c:=0;
		for j:=1 to n do
			if t[j] mod i = 0 then inc(c);
		if c=n then gcd:=i;
	end;
end;

end.