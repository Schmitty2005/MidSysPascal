
Program sy85DataLength;


Uses  Sysutils, strutils, SysexLib, CRT;

Var 
  MSB : Word;
  LSB : Word;
  output : Word;
  input : String = '';

Begin
  cursorOff;

  While input <> 'q' Do
    Begin
      writeln ('Enter MSB (POS 4) :');
      readln (input);
      MSB := Word (128) * (Word (StrToInt (input)));
      writeln ('Enter LSB (POS 5): ');
      readln (input);
      lsb := Word (StrToInt (input));
      output := lsb Or msb;
      writeln ('Length of SysEx Message : ' + IntToStr (output));
      writeln ('Binary Output : ' + IntToBin (output, 8, 0));
      TextColor (RED);
      writeln ('(Q)uit or ENTER to continue');
      TextColor(White);
      readln (input);
    End;

End.
