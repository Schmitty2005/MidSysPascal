
Program objtest;

Uses Classes, sysUtils;

Type 

  Ttester = packed Object
    oner : Byte;
    twoer : Byte;

  End;

  TRtester = packed Object (Ttester)
    onert : Byte;
    twoert : Byte;

  End;

Var 
  tester : Ttester;
  rtester : TRtester;
Begin
  tester.oner := 4;
  writeln('OBJECT SIZE : ' + IntToStr(sizeof(tester)));
  writeln('record SIZE : ' + IntToStr(sizeof(rtester)));

End.
