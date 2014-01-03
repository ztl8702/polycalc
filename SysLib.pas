unit SysLib;  {Canboc Software Studio}

interface

procedure Errormsg(m:integer);
function StrtoReal(s:string):real;
function RealtoStr(R:real):string;

implementation

procedure Errormsg(m:integer);
begin
  writeln('!!Error ',m);
  halt;
end;

function StrtoReal(s:string):real;
  var E:integer; ans:real;
begin
  val(s,ans,E);
  if E<>0 then Errormsg(10);
  StrToReal:=ans;
end;

function RealtoStr(R:real):string;
  var ans:string;
begin
  str(R:0:15,ans);
  if pos('.',ans)<>0 then
    begin
      while (ans[length(ans)]='0') do
        delete(ans,length(ans),1);
      if ans[length(ans)]='.' then
        delete(ans,length(ans),1);
    end;
  RealtoStr:=ans;
end;


end.

