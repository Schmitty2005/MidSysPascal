{$MODE delphi}//Must use Delphi mode for proper pointer assignment :)
program SY85Test;

uses
  SysUtils,
  Classes,
  StrUtils,
  SY85Voice;

type
  PSY85VoiceBlock = ^TSY85VoiceBlock;


var
  pointer: PSY85VoiceBlock;
  Data: TSY85VoiceBlock;
  named: array [0..9] of AnsiChar;
  readCount: integer;
  filesyx: TbytesStream;
  blocks : Tlist;

begin
  pointer := New(PSY85VoiceBlock);
  filesyx := readSysex('sysex.syx');
  writeln('Size of Sysex File : ' + IntToStr(filesyx.size));
  parseVoice(filesyx);
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
blocks := Tlist.Create;
 // blocks := parseSysExBlocks(readSysex('sysex.syx'));
  blocks.AddList(parseSysExBlocks(readSysex('sysex.syx')));

  pointer := blocks[133];
  writeln ('Addres : ' + (Format ('%p', [pointer] )));
 writeln (IntToStr(pointer^.MemSlot));




end.
