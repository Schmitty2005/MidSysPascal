{$MODE delphi}  //Must use Delphi mode for proper pointer assignment :)
Program SY85Test;

Uses SysUtils, Classes, StrUtils,  SY85Voice;

Type
PSY85VoiceBlock = ^TSY85VoiceBlock;


var 
pointer : PSY85VoiceBlock;
data : TSY85VoiceBlock;
named : Array [0..9] of AnsiChar   ;
readCount : Integer;
filesyx : TbytesStream;

begin
  pointer := New(PSY85VoiceBlock);
  filesyx := readSysex('testVoice.syx');
  writeln ('Size of Sysex File : ' + IntToStr(filesyx.size));
  parseVoice (filesyx);
  //pointer := readSysEx('testVoice.syx');
  //named := (pointer.header.blocktype);
  {
  writeln (IntToSTr(sizeof(data)));
  data := pointer^;
  writeln(data.voiceName);
  writeln(data.header.blockType);
  writeln('SIZE OF TEST FX : ' + IntToSTr(sizeof(data.testfx)));
  writeln ('Calculated Length : ' + IntToStr(calcDataLength(data)));
}
end.

