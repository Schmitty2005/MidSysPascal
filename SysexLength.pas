
Program SysexLength;


{program for determinig the length of Sysex Data that accompanies a block - WORKING! :)}

Uses  sysutils, strutils, SysexLib;

Var 
  lsb : Word;
  msb : Word;
  input : string;
  output : Word;

Begin
  writeln ('Enter MSB (POS 4) :');
  readln (input);
  MSB := Word (128) * (Word (StrToInt (input)));
  writeln ('Binary MSB = ' + binStr(msb, 8));
  writeln ('Enter LSB (POS 5): ');
  readln (input);
  lsb := Word (StrToInt (input));
  writeln ('Binary LSB = ' + binStr (lsb, 8));
  writeln ('Binary LSB After Shift : ' + binStr (lsb, 8));
  output := lsb Or msb;
  writeln ( 'OR''d output : ' + binStr(output, 8));
  writeln ('Length of SysEx Message : ' + IntToStr (output));
  writeln ('FUNCTION CALLED : ' + IntToStr (dataLengthCalc ( 01,104)));
  writeln ('Integer Function CALLED : ' + IntToStr (dataLengthCalc (Integer (01)
  , Integer (104))));

End.
