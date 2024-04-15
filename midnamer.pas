unit midnamer;

{$mode Delphi}

interface


uses
  Classes, SysUtils;

function midnamHeader () : String;
function patchNumber (Number : String; Name : String; ProgramChange : Integer) : String;



implementation

const
  namHeader : String = '<?xml version="1.0" encoding="UTF-8"?>' +
    '<!DOCTYPE MIDINameDocument PUBLIC "-//MIDI Manufacturers Association//' +
    'DTD MIDINameDocument 1.0//EN" "http://www.midi.org/dtds/' +
    'MIDINameDocument10.dtd">';

function midnamHeader () : String;
Begin
  result:= namHeader;
END;

// A function to output the following :
// -->    "<PatchNameList>"  <--For reference only.  Not included in output!
//          <Patch Number="A000" Name="Overture K" ProgramChange="0"/>
function patchNumber (Number : String; Name : String; ProgramChange : Integer) : String;
var
output1 : String ;
output2 : String ;
output3 : String ;
finalout : String ;
begin
  output1 := '<Patch Number=' + AnsiQuotedStr(Number, '"') + ' ';
  output2 := 'Name=' + AnsiQuotedStr(Name,'"') + ' ';
  output3 := 'ProgramChange="'+IntToStr(ProgramChange)+'" />';
  finalout := output1 + output2 + output3;
  result := finalout;
end;


end.

