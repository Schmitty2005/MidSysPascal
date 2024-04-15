
Program test;

Uses crt, sysutils;

Var 
  x : Word;
  xx : PWord;
  y : Byte;
  yy : PByte;
  z: Integer;
Begin
  x := 352642;
  xx := @x;
  yy := PByte(xx);
  y  := Byte(yy^);
  TextColor (Green);
  For z:=0 To 80 Do
    write ('=');
    writeln('');
    write ('=');
    For z:=0 to 76 Do
    write (' ');
    write('=');
  writeln('');
  TextColor (Blue);
  writeln('Word Value / Pointer : ' + IntTOStr (x)  + ' / '+ HexStr(@x));
  writeln ('Word Address : Pointer Value : ' + HexStr (xx));
  writeln ('Byte Pointer Value : ' + HexStr(yy));
  writeln ('LSB Byte Value : ' + IntToStr ((yy)^));
  writeln ('MSB Byte Value : ' + IntToStr ((yy+1)^));
  writeln ('HEx Str : ' + HexStr (yy+1));
  TextBackground (Black);
  TextColor (Green);
  For x:=0 To 80 Do
    write ('=');







End.
