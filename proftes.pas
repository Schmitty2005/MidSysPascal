
Program proftest;

Uses CRT, sysutils;

Var 
  single : Integer;
  letter : Char;
  testing : String;
  x : Integer = 0;

Function sqrttest ( Const number : Real) : Real;
Begin
  sqrttest := sqrt(number);
  write (FloattoStr (sqrttest) + ', ');
End;

Begin
  writeln ('TESTING PROFILER ....');
  sqrttest (12);
  sqrttest (144);
  While (x< 10) Do
    Begin
      sqrttest (x);
      x := x + 1;
    End;

  writeln ('COMPLETE');

End.
