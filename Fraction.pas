unit Fraction;   {Canboc Software Studio}

interface

type
  TFract=object
    numerator:integer;
    denominator:integer;
    {Procedures&Functions}
    procedure SetValue(const num,den:integer);
    procedure Reduce;
  end;

function RealtoFract(decimal: double): TFract;

implementation
  uses math;
{Procedures&Functions of Object:TFract
}
procedure TFract.SetValue(const num,den:integer);
begin
  numerator:=num;
  denominator:=den;
end;

procedure TFract.Reduce;
 var i,j,k:integer;
begin
  i:=numerator;
  j:=denominator;
  repeat
    k:=i mod j;
    i:=j;
    j:=k;
   until k=0;
  numerator:=numerator div i;
  denominator:=denominator div i;
end;

{END}

function RealtoFract(decimal: double): TFract;
var
  intNumerator, intDenominator, intNegative: integer;
  dblFraction, dblDecimal, dblAccuracy, dblinteger: Double;
  ans:TFract;
begin
  dblDecimal := decimal;
  if trunc(decimal) = decimal then
    ans.SetValue(trunc(decimal),1)
  else
  begin
    if abs(decimal) > 1 then
    begin
      dblinteger := trunc(decimal);
      dblDecimal := abs(frac(decimal));
    end
    else dblDecimal := decimal;
    dblAccuracy := 0.00001;
    intNumerator := 0;
    intDenominator := 1;
    intNegative := 1;
    if dblDecimal < 0 then intNegative := -1;
    dblFraction := 0;
    while Abs(dblFraction - dblDecimal) > dblAccuracy do
    begin
      if Abs(dblFraction) > Abs(dblDecimal) then
        intDenominator := intDenominator + 1
      else
        intNumerator := intNumerator + intNegative;
      dblFraction := intNumerator / intDenominator;
    end;
    RealtoFract.SetValue(intNumerator,intDenominator);
  end;
end;

function FMulti(const a,b:TFract):TFract;
  var ans:TFract;
begin
  ans.SetValue(a.numerator*b.numerator,a.denominator*b.denominator);
end;

function FDiv(const a,b:TFract):TFract;
 var ans:TFract;
begin
  ans.SetValue(a.numerator*b.denominator,a.denominator*b.numerator);
end;

function FPlus(const a,b:TFract):TFract;
 var ans:TFract;
begin
end;

function FMinus(const a,b:TFract):TFract;
 var ans:TFract;
begin
end;

end.

