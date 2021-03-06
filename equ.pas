unit equ;
    
interface

uses 
	basic,math,lang,programStr,plot;

var 
    err:word;
    Vars:TVar;
    VarNum:word = 0;

procedure Equation(s:string);
function EquCheck(a:tStr;ALength:byte):boolean;
function EquProcess(s:string):extended;
function VarPos(s:string):word;
procedure VarProcess(s:shortstring);
function VarCheck(s:string):boolean;
function Bool(s:string):boolean;
function eqn2(x,y,z:string):string;
function fact(num:Longword):string;
function NumInCheck(t:tStr;endNum:word):boolean;
function gcd(t:tNum;n:word):longword;
function lcm(t:tNum;n:word):longword;

implementation

procedure Equation(s:string);
begin
//	if (pos('fx=',ClrSpace(s))=1) then fx(ClrSpace(s)) else
	if (pos('==',s)<>0) and (pos('==',s)=poslast('==',s))
		then VarProcess(ClrSpace(s))
    else if (pos('=',s)<>0) and (pos('=',s)=poslast('=',s)) 
		or (pos('<',s)<>0) and (pos('<',s)=poslast('<',s)) 
		or (pos('>',s)<>0) and (pos('>',s)=poslast('>',s)) 
			then write(bool(ClrSpace(s)))
    else if (pos('+',s)<>0) or (pos('-',s)<>0) or (pos('*',s)<>0)
	    or (pos('/',s)<>0) or (pos('^',s)<>0) then
		begin
		   	ans:=EquProcess(ClrSpace(s));
		   	if Trunc(ans)=ans then write(ans:0:0)
			   else write(ans:0:dec);
		end
    else write(EReport(s,ErrorId1));
end;

function EquCheck(a:tStr;ALength:byte):boolean;
var i:byte;
begin
	EquCheck:=True;
	for i:=1 to Alength-1 do
		if (VarCheck(a[i])=True) and (VarCheck(a[i+1])=True) then EquCheck:=False; 
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
	if (pos('+',s)<>0) and ((pos('+',s)>poslast(')',s)) or (pos('+',s)<pos('(',s))) then begin
		NumProcess(s,pos('+',s),n1,n2);
		EquProcess:=n1+n2;
	end
	else if (pos('-',s)<>0) and ((pos('-',s)>poslast(')',s)) or (pos('-',s)<pos('(',s))) then begin
		NumProcess(s,poslast('-',s),n1,n2);
		EquProcess:=n1-n2;
	end
	else if (pos('*',s)<>0) and (s<>'') and ((pos('*',s)>poslast(')',s)) or (pos('*',s)<pos('(',s))) then begin
		NumProcess(s,pos('*',s),n1,n2);
		EquProcess:=n1*n2;
	end	
	else if (pos('/',s)<>0) and (s<>'') and ((pos('/',s)>poslast(')',s)) or (pos('/',s)<pos('(',s))) then begin
		NumProcess(s,poslast('/',s),n1,n2);
		if (n2=0) or (n1=0) then write(EReport(s,ErrorId2))
		else EquProcess:=n1/n2;
	end
	else if (pos('^',s)<>0) and (s<>'') and ((pos('^',s)>poslast(')',s)) or (pos('^',s)<pos('(',s))) then begin
		NumProcess(s,pos('^',s),n1,n2);
		EquProcess:=Power(n1,n2);
	end
	else if (pos('(',s)<>0) and (pos(')',s)<>0) and (pos(')',s)-pos('(',s)>1) then 
		EquProcess:=EquProcess(copy(s,2,length(s)-2))
	else if (VarPos(s)<>0) and (Str2Num(s).check=False)
		then EquProcess:=Vars[VarPos(s)].value
	else if (Str2Num(s).Check=True) and (s<>'') then EquProcess:=Str2Num(s).value
	else exit;
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

function VarPos(s:string):word;
var i:word;
begin
	VarPos:=0;
	i:=0;
	while (i<=VarNum) and (s=Vars[i].vname) do begin
		inc(i);	
		if s=Vars[i].vname then VarPos:=i;
	end;
end;

procedure VarProcess(s:string);
var 
	str:shortstring;
	k:word;
    Bool:boolean;
	eq:Extended;
begin
	k:=pos('==',s);
	str:=UPCASE(copy(s,1,k-1));
	eq:=EquProcess(copy(s,k+2,(length(s)-k-1)));
	ans:=eq;
	if (str<>'PREANS') and (str<>'DEC') then Bool:=True;
//	for k:=1 to length(s) do if s[k] in [symbol] then Bool:=False;
	if (Upcase(s[1]) in ['A'..'Z']) and (Bool=True) then begin
		if VarPos(str)=0 then	
		begin
			inc(VarNum);
			Vars[VarNum].vname:=str;
		end;
		Vars[VarPos(str)].value:=eq;
		write(str,' = ',eq:0:dec);
	end
	else write(EReport(str,ErrorId4))
end;

function VarCheck(s:string):boolean;
var i:word;
begin
	if Str2Num(s).check=True then VarCheck:=True
		else VarCheck:=False;
	for i:=0 to VarNum do
		if s=Vars[i].vname then VarCheck:=True;
end;

function eqn2(x,y,z:string):string;
var 
    a,b,c,delta:extended;
begin
	if (Str2Num(x).check=True) and (Str2Num(y).check=True) 
		and (Str2Num(z).check=True) then 
	begin
		a:=Str2Num(x).value;
		b:=Str2Num(y).value;
		c:=Str2Num(z).value;
 		if a<>0 then begin
		    delta:=(b*b-4*a*c);
	    	if delta<0 then eqn2:=eqn0Text
			else if delta=0 then eqn2:=eqn1Text+Num2Str((-b/2/a),dec)
    		else if delta>0 then begin
				eqn2:=eqn2Text;
				eqn2:=eqn2+'x1= '+Num2Str(((-b+sqrt(delta))/2/a),dec);
				eqn2:=eqn2+' | x2= '+Num2Str(((-b-sqrt(delta))/2/a),dec);
			end;
    	end
    	else eqn2:=EReport(Num2Str(a,dec),ErrorId1);
	end
	else eqn2:=(EReport('',ErrorId1));
end;
    
function fact(num:Longword):string;
var 
	k:longword;
	count,check:word;
begin
	check:=0;fact:='';k:=1;
	while k<=num do begin
		count:=0;inc(k);
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
	for i:=1 to endNum do 
		if (Str2Int(t[i]).check=false) or (Str2Int(t[i]).value<=0) or (t[i]=' ')
			then NumInCheck:=false;
	if NumInCheck=False then write(EReport('',ErrorId4));
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
	ans:=gcd;
end;

function lcm(t:tNum;n:word):longword;
var 
	i,k:longword;
	c,j:word;
begin
	lcm:=t[1];k:=t[1];
	for i:=2 to n do begin
		if lcm mod t[i] <> 0 then lcm:=lcm*t[i];
		if t[i]>k then k:=t[i];
	end;
	for i:=lcm-1 downto k do begin
		c:=0;
		for j:=1 to n do
			if i mod t[j] = 0 then inc(c);
		if c=n then lcm:=i;
	end;
	ans:=lcm;
end;

end.