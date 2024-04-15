
{$mode objfpc}{$H+}

Unit SysexLib;
{VARIOUS SYSEX Functions in PASCAL}
{GET DATA Funtions are messed up at this time}

Interface

Type 
  TSysExDataFile = file Of byte;
  TDataBlock = array Of byte;

Function dataLengthCalc (msb : Word; lsb : word) : Word;
Function dataLengthCalc (msb : Byte; lsb : Byte) : Word;
Function dataLengthCalc ( msb : Integer; lsb : Integer) : Word;
Function countSysexBlocks ( Var sysExFile : TSysExDataFile ) : Integer;
Function countSysexBlocks ( Var sysExData : TDataBlock ) : Integer;
Function outputBlock (Var sysExFile : TSysExDataFile; block : Integer):


                                                                      TDataBlock
;
Function getBankPatch (data : TDataBlock) : Integer;
Function getDataBlock(Var sysExFile:TSysExDataFile;  block:Integer;
                      return : Array Of byte): TDataBlock;
Function verifyChecksum (Var sysExBlock : TDataBlock) : Boolean;
Function readSysEx(fnam: String): TDataBlock;

Implementation

Uses  SysUtils, StrUtils, Classes;

Const 
{ Sysex Data YAMAHA SY-85}
{DONT USE CONST SETS YET}
  sysexHeader = [1..6];
  bulkDump = [7..17];
  padding = [18..32];
  bankPatch = [33..34];
  voiceData = [35..240]; {Begin Here is where bug kicks in}
  voiceDatabug = [35..239]; {May change for SYSEX ROM 1.10S}
  checksum = 241;
  checksumBug = 240;
  sysexEOB = 242;
  sysexEOBBug = 241;



Function readSysEx(fnam: String): TDataBlock;

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
result := data;
End;





Function getDataBlock(Var sysExFile:TSysExDataFile;  block:Integer; return :
                      Array Of byte): TDataBlock;
{THIS IS SCREWED UP!}

Var 
  position : Integer = 1;
  {Need function to find position of block in sysex file TEMP 1st block}
Begin
  For position := 1 To high(return) Do
    getDataBlock[position] := return[position];
End;


Function getBankPatch (data : TDataBlock) : Integer;

Var 
  bank : Integer = 0;
  patch : Integer = 0;
Begin
  bank := data[33];
  patch := data[34];
  writeln ('Bank : ' + IntToStr(bank) + '    Patch : ' + IntToStr (patch));
End;

Function dataLengthCalc (msb : Byte; lsb : Byte) : Word;
{This conversion now works!}

Var 
  wMsb : Word = 0;
Begin
  wMsb := msb shl (7);
  dataLengthCalc := lsb Or wMsb;
End;


Function dataLengthCalc (msb : Word; lsb : word) : Word;
Begin
  msb := msb shl (7);
  dataLengthCalc := lsb Or msb;
End;

Function dataLengthCalc ( msb : Integer; lsb : Integer) : Word;
Begin
  msb := (Word(128) * Word (msb));
  dataLengthCalc :=  ( Word (msb) Or Word (lsb));
End;

{COUNTS TOTAL NUMBER OF SYSEX BLOCKS IN FILE}
Function countSysexBlocks ( Var sysExFile : TSysExDataFile ) : Integer;

Var 
  data : Byte;
  counter : Integer = 0;
  blockTally : Integer = 0;

Begin
  writeln('Count SysExBlocks TSysExDataFile called...Blocks will vary beacuse of multiple blocks');

  Reset(sysExFile);
  seek (sysexFile, 1);

  While Not EOF (sysexFile) Do
    Begin
      seek (sysexFile, counter );
      read (sysexFile, data);
      If (data = Word (240)) Then blockTally := blockTally + 1;
      counter := counter + 1;
    End;
  countSysexBlocks := blockTally;
End;

Function countSysexBlocks ( Var sysExData : TDataBlock ) : Integer;

Var 
  counter : Integer = 0;
  blockTally : Integer = 0;
  msb : Byte = 0;
  lsb : Byte = 0;
Begin
  writeln('Count SysExBlocks TDataBlock called...');
  While counter < high(sysExData) Do
    Begin
      If (sysExData[counter]= Word (240)) Then
        Begin
          blockTally := blockTally + 1;  {240 = 0xF0}
          msb := sysExData[counter + 4];
          lsb := sysExData[counter + 5];
          counter := counter + dataLengthCalc(msb, lsb) ;
      {READ block length and increment counter to speed up tally}
        End;
      counter := counter + 1;
    End;
  countSysexBlocks := blockTally;
End;


Function outputBlock (Var sysExFile : TSysExDataFile; block : Integer) :



                                                                      TDataBlock
;

Var 
  fileCounter : Integer = 0;
  blockSize : Integer = 0;
  tick : Byte;
  header : Array [1..6] Of Byte;
  description : Array [1..5] Of Byte;
  sysexBlock :  Array Of Byte;
  msb : Byte = 0;
  lsb : Byte = 0;
Begin
  Reset (sysExFile);
  seek (sysExFile, 0);
  fileCounter := 1;
  Read (sysexfile, tick);
  writeln( ' TICK : ' + IntToStr (tick));
  If (tick  = 240 ) Then
    Begin
  {store in array}
      seek (sysExFile, fileCounter + 3);
      Read (sysexFile, msb);
      seek (sysExFile, filecounter + 4);
      Read (sysexFile, lsb);
      blockSize := dataLengthCalc (msb, lsb) + 15;
      writeln ('BLOCKSIZE : ' + IntToStr (blockSize));
    End;

  Read (sysexfile, tick);
  If (tick  = 270 ) Then
    Begin

    End;
  ;

End;


Function verifyChecksum (Var sysExBlock : TDataBlock) : Boolean;

Var 
  counter : Integer = 6;
  sum : Integer = 0 ;
  answer : boolean = false;
  test : integer = 32; {FOR TESTING PURPOSES ONLY}

Begin
  While counter <= (High(sysExBlock) -1) Do
    Begin
      sum := sum + sysExBlock[counter];
      counter := counter + 1;
      write ( IntToStr(sum) + ', ');
    End;
  test := sum Mod 128;
  {TESTING LINES========================================}
  writeln ('CHECKSUM TEST RESULTS : ' + IntToStr(test));
  writeln ('Data at 0x06 : ' + IntToStr (sysExBlock[6]));
  writeln ('Block End : ' + IntToStr (sysExBlock[High(sysexBlock)]));
  writeln ('High Block : ' + IntToStr (High(sysExBlock)));
  {=====================================================}
  {If test = 0 Then verifyChecksum = True;}
{Add routine here for sum / calc}
{CHECKSUM is (sum of all bytes from 0x06 to 0xED)  MODULO 128 = 0}
{Pascal would be (SUM BYTES) MOD 128 = 0, checksum will be correct}

{Checksum SHOULD be : sum of all data + checksum MOD 128 = 0}
{Calculating checksum should  = sum of all data mod 128}





{NEED TO FINISH Calulating checksum would be byte SUM 0x06 to 0xEC MOD 128 something something }

End;


Begin
End.
