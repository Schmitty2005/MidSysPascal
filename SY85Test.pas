{$MODE delphi}  //Must use Delphi mode for proper pointer assignment :)
Program SY85Test;

Uses SysUtils, Classes, StrUtils,  SY85Voice;

Type
PSY85VoiceBlock = ^TSY85VoiceBlock;

Function readSysEx(fnam: String): PSY85VoiceBlock;

Var 
  fstream: TFileStream;
  n: longint;
  data : Array Of  Byte;
Begin
  fstream := TFileStream.Create(fnam, fmOpenRead Or fmShareDenyWrite);
  Try
    n := fstream.Size;
    SetLength(data, n);
    fstream.Read(data[1], n);
  Finally
    fstream.Free;
End;
result := @data[(Low(Data)+1)];
End;

var 
pointer : PSY85VoiceBlock;
data : TSY85VoiceBlock;
named : Array [0..9] of AnsiChar   ;

begin
  pointer := New(PSY85VoiceBlock);
  pointer := readSysEx('110sRomFirstVoice.syx');
  //named := (pointer.header.blocktype);
  writeln (IntToSTr(sizeof(data)));
  data := pointer^;
  writeln(data.voiceName);
  writeln(data.header.blockType);
end.

