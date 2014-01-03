uses SysLib;
type Sitem=object
       fac:real;
       Ind:array[1..26]of real;
       {Procedures&Functions}
       procedure Init;
     end;

     Mitem=object
       Count:integer;
       Items:array[1..1000]of Sitem;
       symbol:string;
       order:integer;
       {Procedures&Functions}
       procedure Init;
       procedure AddItem(const what:Sitem);
       procedure DeleteItem(const what:integer);
       procedure DeleteZero;
       function Print():string;
     end;

     Citem=object //Item for Calc
       typeof:integer;
       operat:char;
       operand:Mitem;
       order:integer;
       {Procedures&Functions}
       procedure Init;
     end;

     CQuene=object
       Count:integer;
       Items:array[1..1000]of Citem;
       {Procedures&Functions}
       procedure Init;
       procedure AddItem(const what:Citem);
       procedure AddMulti(const where:integer);
       procedure AddOperator(const op:char);
       procedure AddOperand(const what:Mitem);
       procedure DeleteItem(const what:integer);
     end;

     itemsarray=array[1..100]of Sitem;
     Mitemsarray=array[1..100]of Mitem;
const
  SYMBOL_Root=#251;   {û=#251}
  SYMBOL_LeftBracket='(';
  SYMBOL_RightBracket=')';
  SYMBOL_Plus='+';
  SYMBOL_Minus='-';
  SYMBOL_Multiply='*';
  SYMBOL_Div='/';
  SYMBOL_Arrow='^';
  TYPE_Operator=1;
  TYPE_Operand=2;
  GT_Operator=1;
  GT_Num=2;
  GT_Letter=3;
  RealNumSet=['0'..'9','.'];
  IntegerSet=[0..9];
  LetterSet=['a'..'z'];
  SymbolCharSet=['+','-','(',')','*','/','^',SYMBOL_Root];

var a:mitemsarray;
    rd:string;
    bt,i,j:integer;
    tt:Sitem;
    ta,tb,tc:Mitem;
    test:CQuene;

{ Procedures and Functions of Object: Sitem
}
procedure Sitem.Init;
 var i:integer;
begin
  for i:=1 to 26 do
    ind[i]:=0;
  fac:=0;
end;

{END}

{ Procedures and Functions of Object: Mitem
}
procedure Mitem.Init;
 var i:integer;
begin
  Count:=0;
  for i:=1 to 1000 do
    begin
      Items[i].Init;
    end;
end;

procedure Mitem.AddItem(const what:Sitem);
begin
  inc(Count);
  items[Count]:=what;
end;

procedure Mitem.DeleteItem(const what:integer);
 var i:integer;
begin
  if (what>Count)or(what<1) then exit;
  for i:=what to Count-1 do
    begin
      Items[i]:=Items[i+1];
    end;
  Items[Count].Init;
  Count:=Count-1;
end;

procedure Mitem.DeleteZero;
 var i,tmpc:integer;
begin
  tmpc:=Count;
  for i:=tmpc downto 1 do
    begin
      if Items[i].fac=0 then
        DeleteItem(i);
    end;
end;

function Mitem.Print():string;
begin
end;

{END}

{ Procedures and Functions of Object: Citem
}

procedure Citem.Init;
begin
  order:=0;
  typeof:=0;
  operand.Init;
end;

{END}

{ Procedures and Functions of Object: CQuene
}

procedure CQuene.Init;
 var i:integer;
begin
  Count:=0;
  for i:=1 to 1000 do
    Items[i].Init;
end;

procedure CQuene.AddItem(const what:Citem);
begin
  inc(Count);
  Items[Count]:=what;
end;

procedure CQuene.AddMulti(const where:integer);
 var i:integer;
begin
  for i:=Count+1 downto where+1 do
    begin
      Items[i]:=Items[i-1];
    end;
  inc(Count);
  Items[where].Init;
  Items[where].typeof:=TYPE_Operator;
  Items[where].operat:='*';
end;

procedure CQuene.AddOperator(const op:char);
begin
  inc(Count);
  Items[Count].Init;
  Items[Count].typeof:=TYPE_Operator;
  Items[Count].operat:=op;
end;

procedure CQuene.AddOperand(const what:Mitem);
begin
  inc(Count);
  Items[Count].Init;
  Items[Count].typeof:=TYPE_Operand;
  Items[Count].operand:=what;
end;

procedure CQuene.DeleteItem(const what:integer);
 var i:integer;
begin
  if (what>Count)or(what<1) then exit;
  for i:=what to Count-1 do
    begin
      Items[i]:=Items[i+1];
    end;
  Items[Count].Init;
  Count:=Count-1;
end;

{END}

procedure printS(const w:Sitem);

begin
end;

function SitemToMitem(const ws:Sitem):Mitem;
 var newmitem:Mitem;
begin
  newmitem.Init;
  newmitem.Count:=1;
  newmitem.Items[1]:=ws;
  SitemToMitem:=newmitem;
end;

function GetType(const w:char):integer;
begin
  if (w in SymbolCharSet) then exit(GT_Operator);
  if (w in RealNumSet) then exit(GT_Num);
  if (w in LetterSet) then exit(GT_Letter);
end;

function IsSimilarItems(const a,b:Sitem):boolean;
 var bo:boolean;
begin
  bo:=true;
  for i:=1 to 26 do
    if a.ind[i]<>b.ind[i] then
      begin
        bo:=false;
        break;
      end;
  IsSimilarItems:=bo;
end;

//CALC
function SimpleMulti(const a,b:Sitem):Sitem;
  var i:integer; newitem:Sitem;
begin
  newitem.Init;
  newitem.fac:=a.fac*b.fac;
  for i:=1 to 26 do
    begin
      newitem.ind[i]:=a.ind[i]+b.ind[i];
    end;
  SimpleMulti:=newitem;
end;

function SimpleDiv(const a,b:Sitem):Sitem;
  var i:integer; newitem:Sitem;
begin
  newitem.Init;
  newitem.fac:=a.fac/b.fac;
  for i:=1 to 26 do
    begin
      newitem.ind[i]:=a.ind[i]-b.ind[i];
    end;
  SimpleDiv:=newitem;
end;

function SimplePlus(const a,b:Sitem):Sitem;
  var i:integer; newitem:Sitem;
begin
  if (not(IsSimilarItems(a,b))) then errormsg(1);
  newitem.Init;
  newitem.fac:=a.fac+b.fac;
  for i:=1 to 26 do
    begin
      newitem.ind[i]:=a.ind[i];
    end;
  SimplePlus:=newitem;
end;

function SimpleMinus(const a,b:Sitem):Sitem;
  var i:integer; newitem:Sitem;
begin
  if (not(IsSimilarItems(a,b))) then errormsg(1);
  newitem.Init;
  newitem.fac:=a.fac-b.fac;
  for i:=1 to 26 do
    begin
      newitem.ind[i]:=a.ind[i];
    end;
  SimpleMinus:=newitem;
end;

procedure MergeSimilarItems(var a:Mitem);
  var i,j:integer;
      newmitem:Mitem; temp:Sitem;
      chose:array[1.. 1000]of boolean;
begin
  fillchar(chose,sizeof(chose),false);
  newmitem.Init;
  for i:=1 to a.Count do
    begin
      if not(chose[i]) then
        begin
          temp:=a.items[i];
          chose[i]:=true;
          for j:=i+1 to a.Count do
            begin
              if (not(chose[j]))and(IsSimilarItems(a.Items[i],a.Items[j])) then
                begin
                  temp:=SimplePlus(temp,a.items[j]);
                  chose[j]:=true;
                end;
            end;
          newmitem.AddItem(temp);
        end;
    end;
  newmitem.DeleteZero;
  a:=newmitem;
end;

function MMulti(const a,b:Mitem):Mitem;
 var i,j:integer; newmitem:Mitem;
begin
  newmitem.Init;
  for i:=1 to a.Count do
    begin
      for j:=1 to b.Count do
        begin
         newmitem.AddItem(SimpleMulti(a.Items[i],b.Items[j]));
        end;
    end;
  MergeSimilarItems(newmitem);
  MMulti:=newmitem;
end;

function MPlus(const a,b:Mitem):Mitem;
  var i:integer; newmitem:Mitem;
begin
  newmitem.init;
  for i:=1 to a.Count do
    begin
      newmitem.AddItem(a.Items[i]);
    end;
  for i:=1 to b.Count do
    begin
      newmitem.AddItem(b.Items[i]);
    end;
  MergeSimilarItems(newmitem);
  MPlus:=newmitem;
end;

function MMinus(const a,b:Mitem):Mitem;
  var i:integer; newmitem:Mitem;
begin
  newmitem.init;
  for i:=1 to a.Count do
    begin
      newmitem.AddItem(a.Items[i]);
    end;
  for i:=1 to b.Count do
    begin
      newmitem.AddItem(b.Items[i]);
      newmitem.Items[newmitem.Count].fac:=-newmitem.Items[newmitem.Count].fac;
    end;
  MergeSimilarItems(newmitem);
  MMinus:=newmitem;
end;

function MPower(const a,b:Mitem):Mitem;
  var i:integer; newmitem:Mitem;
begin
  newmitem.init;
  inc(newmitem.Count);
  newmitem.Items[1].fac:=1;
  for i:=1 to trunc(b.Items[1].fac) do
    begin
      newmitem:=MMulti(newmitem,a);
    end;
  MergeSimilarItems(newmitem);
  MPower:=newmitem;
end;

procedure AnalyzeSimpleItem(what:string;var where:Sitem);
 var i,j,k,code,tmp:integer; re,tind:real; HaveLetter:boolean;
begin
  where.Init;
  if GetType(what[1])=GT_NUM then
    begin
      where.fac:=StrtoReal(what);
    end;
  if GetType(what[1])=GT_Letter then
    begin
      where.fac:=1;
      where.Ind[ord(what[1])-96]:=1;
    end;
end;

procedure Scan(Ss:string;var where:CQuene);
  var i,ty,tempc:integer; temp:string; tmpitem:Sitem;
  procedure AddIt();
    var j:integer;
  begin
    if ty=GT_Operator then
      begin
        for j:=1 to length(temp) do
          where.AddOperator(temp[j]);
      end;
    if ty=GT_Num then
      begin
        AnalyzeSimpleItem(temp,tmpitem);
        where.AddOperand(SitemToMitem(tmpitem));
      end;
    if ty=GT_Letter then
      begin
        for j:=1 to length(temp) do
          begin
            AnalyzeSimpleItem(temp[j],tmpitem);
            where.AddOperand(SitemToMitem(tmpitem));
          end;
       end;
  end;
begin
  i:=0;
  temp:='';
  ty:=0;
  repeat
    inc(i);
    if GetType(ss[i])<>ty then
      begin
        if temp<>'' then
          begin
            AddIt();
          end;
        temp:='';
        ty:=GetType(ss[i]);
        temp:=temp+ss[i];
      end
    else
      begin
        temp:=temp+ss[i];
      end;
  until i>=length(ss);
  if temp<>'' then
    begin
      AddIt();
    end;
  //Add Multi
  tempc:=where.Count;
  for i:=tempc-1 downto 1 do
    begin
      if (where.Items[i].typeof=TYPE_Operand)and(where.Items[i+1].typeof=TYPE_Operator)
         and(where.Items[i+1].operat='(') then
        begin
          where.AddMulti(i+1);
        end;
      if (where.Items[i].typeof=TYPE_Operand)and(where.Items[i+1].typeof=TYPE_Operand)
        then
        begin
          where.AddMulti(i+1);
        end;
      if (where.Items[i].typeof=TYPE_Operator)and(where.Items[i+1].typeof=TYPE_Operator)
         and(where.Items[i].operat=')')and(where.Items[i+1].operat='(') then
        begin
          where.AddMulti(i+1);
        end;
    end;
end;

procedure GiveRate(var whata:CQuene);
 var i,high:integer;
begin
  high:=0;
  for i:=1 to whata.Count do
    begin
      if whata.Items[i].typeof=TYPE_Operator then
        begin
          if whata.Items[i].operat='+' then whata.Items[i].order:=high+1;
          if whata.Items[i].operat='-' then whata.Items[i].order:=high+1;
          if whata.Items[i].operat='*' then whata.Items[i].order:=high+2;
          if whata.Items[i].operat='/' then whata.Items[i].order:=high+2;
          if whata.Items[i].operat='^' then whata.Items[i].order:=high+3;
          if whata.Items[i].operat='(' then high:=high+3;
          if whata.Items[i].operat=')' then high:=high-3;
        end;
    end;
  for i:=whata.Count downto 1 do
    begin
      if (whata.Items[i].typeof=TYPE_Operator)and(whata.Items[i].operat in ['(',')']) then
        whata.DeleteItem(i);
    end;
end;

procedure run(var what:CQuene);
 var max,maxw:integer; tmp:Mitem;
 procedure compute(const OpId:integer);
   var zeroitem,a,b,x:Mitem;
 begin
   zeroitem.Init;
   if (what.Items[OpId].typeof=TYPE_Operator)and(OpId>=1)and(OpId<=what.Count) then
     begin
       if OpId-1>=1 then
         begin
           if what.Items[OpId-1].typeof=TYPE_Operand then
             a:=what.Items[OpId-1].Operand
           else
             a:=zeroitem;
         end
       else
         begin
           a:=zeroitem;
         end;
       if OpId+1<=what.Count then
         begin
           if what.Items[OpId+1].typeof=TYPE_Operand then
             b:=what.Items[OpId+1].Operand
           else
             b:=zeroitem;
         end
       else
         begin
           b:=zeroitem;
         end;
       x.Init;
       case what.Items[OpId].Operat of
         '+':begin
               x:=MPlus(a,b);
             end;
         '-':begin
               x:=MMinus(a,b);
             end;
         '*':begin
               x:=MMulti(a,b);
             end;
         '^':begin
               x:=MPower(a,b);
             end;
       end;{End of Case}
       what.Items[OpId].Init;
       what.Items[OpId].typeof:=TYPE_Operand;
       what.Items[OpId].Operand:=x;
       if OpId+1<=what.Count then
         if what.Items[OpId+1].typeof=TYPE_Operand then
           what.DeleteItem(OpId+1);
       if OpId-1>=1 then
         if what.Items[OpId-1].typeof=TYPE_Operand then
           what.DeleteItem(OpId-1);
     end;
 end;
begin
  repeat
    max:=0;
    maxw:=0;
    for i:=1 to what.Count do
      if what.Items[i].typeof=TYPE_Operator then
        if what.Items[i].order>max then
          begin
            max:=what.Items[i].order;
            maxw:=i;
          end;
    if max<>0 then
      begin
        compute(maxw);
      end;
  until (max=0)or(what.Count<=1);
end;

procedure Print(const C:CQuene);
 var i:integer;
 function PrintM(const M:Mitem):string;
  var j,k:integer; tmpr,tmp:string; HaveLetter:boolean;
 begin
   tmp:='';
   for j:=1 to M.Count do
     begin
       tmpr:='';
       HaveLetter:=false;
       if M.Items[j].fac<>0 then
         begin
           for k:=1 to 26 do
             begin
               if M.Items[j].ind[k]<>0 then
                 begin
                   HaveLetter:=true;
                   tmpr:=tmpr+chr(k+96);
                   if abs(M.Items[j].ind[k])<>1 then
                     tmpr:=tmpr+'^'+RealtoStr(M.Items[j].ind[k]);
                 end;
             end;
           if not((HaveLetter)and(abs(M.Items[j].fac)=1)) then
             tmpr:=RealtoStr(abs(M.Items[j].fac))+tmpr;
           if (j>1)and(M.Items[j].fac>0) then tmpr:='+'+tmpr;
           if M.Items[j].fac<0 then tmpr:='-'+tmpr;
         end;
       tmp:=tmp+tmpr;
     end;
   PrintM:=tmp;
 end;
begin
  for i:=1 to C.Count do
    begin
      if C.items[i].typeof=TYPE_Operand then
        writeln(PrintM(C.Items[i].Operand))
      else
        writeln(C.Items[i].Operat,',',C.Items[i].order);
    end;
end;

begin
  readln(rd);
  test.Init;
  Scan(rd,test);
  GiveRate(test);
  run(test);
  print(test);
end.
