{$mode delphi}{$H+}

Program SysExFile;

Uses sysutils, strutils, CRT, SysexLib;

Const


  stop = 1;

Var
  data : TDataBlock;
  tick : byte;
  doubletick : word;
  sysexdata : File Of byte;
  filename : String = 'sysex.syx';
  counter : integer = 0;
  high : byte;
  low : byte;
  checksum : byte;
  programName : array [1..10] Of char;
  checksumTally : Word;
  designation : array [0..5] Of Word;
  dataBlock : TDataBlock;

  procedure PrintArray(input : TDataBlock);
var
   i : integer;
begin
    for i := 1 to length(input) do
       write(chr(input[i - 1]),' ');
    writeln;
end;

Begin
  AssignFile (sysexdata, filename);
  reset (sysexdata);
  While (counter <= stop) Do
    Begin
      Seek(sysexdata,counter);
      write ('Position : '+IntToStr(counter) + ' Binary Value : ');
      Read(sysexdata, tick);
      writeln (binStr(tick, 8));
      counter := counter + 1;
    End;

  seek (sysexdata, 4);
  Read (Sysexdata, high);
  seek (sysexdata, 5);
  Read (Sysexdata, low);
  writeln ('DATA Length      : ' + IntToStr (dataLengthCalc (high, low)));

  seek (sysexdata, 105); {READ FILENAME};
  counter := 0;

  While (counter <= 20) Do
    Begin
      counter := counter + 1;
      Read (sysexdata, byte(programName[counter]));
    End;

  writeln ('Program Name : ' + programName + sLineBreak);

  checksum := 0;
  seek (sysexdata, (6 + dataLengthCalc(high, low)));
  Read (Sysexdata, checksum);
  writeLn ('CHECKSUM in FILE  : ' + IntToStr(checksum));

  counter := 1;
  tick := 0;
  checksumTally := 0;
  seek (sysexData, 4);
  read (sysexdata, tick);
  writeln ('STARTING BYTE :' + IntToStr(tick) );
  seek (sysexdata, (dataLengthCalc (high, low)) + 6);
  read (sysexdata, tick);
  writeln ('END BYTE      ' + IntTOStr(tick));
  While (counter <= (dataLengthCalc(high, low)+5  )) Do
    Begin
      seek (sysexData, counter + 3);
      read (sysexData, tick);
      checksumTally := checksumTally + (Word(tick));
      {If checksumTally > 128 Then checksumTally := checksumTally-128;
      }
      counter := counter + 1;
    End;
  writeln ('CHECKSUM TALLY    : ' + IntTOStr(checksumTally));
  checksumTally := (checksumTally Div 128);


  writeLn ('COMPUTED CHECKSUM : ' + IntToStr (checksumTally));
  counter := 0;
  seek (sysexData, 10);
  For  doubletick In designation Do
    Begin
      read (sysexdata, tick);
      designation[counter] := tick;
      counter := counter + 1;
    End;
  writeln ('DESIGNATION :     ' + Chr(designation [1]) + Chr(designation [2]) +
  Chr(designation [3]) + Chr(designation [4]) + Chr(designation [5])  );

{
  WriteLn ( 'Count of End of Block 0xF7 found in file : ' + IntToStr (
           countSysexBlocks (filename)));
}

  writeln ('Total SYSEX Blocks in ' + filename + ' : ' + IntToStr(countSysexBlocks(sysexData)));
  outputBlock ( sysexData, 1);


{getDataBlock (getSysExData(sysExData), 1, slice(sysexData, 239));
}
close(sysexData);

readSysEx(filename);
getBankPatch (readsysEx(filename));
data := readSysEx(filename);
counter := countSysexBlocks(data);
WRITELN('COUNTER RETURNED');ls
writeln ('Count File  Blocks : ' + IntToStr (counter));

End.
