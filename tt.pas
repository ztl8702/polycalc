uses Fraction,syslib;
 var a:TFract; b:real;s:string;
begin
  b:=-55050.56;
  a:=RealToFract(b);
  writeln(a.numerator,'/',a.denominator);
  writeln(realtostr(b));
end.
