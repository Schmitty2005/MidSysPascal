{$mode objfpc}

Unit Sy85Lib;


Interface

Uses SysUtils, Math, StrUtils,   SysexLib;

Const 
  bulkDumpType : Array [1..7] Of String = ('0065VC', '0065DR', '0065PF',
                                           '0065MU', '065SY', '0065SS', '0040SA'
                                          );


Type 
  TBlockArray = Array Of TDataBlock;

Function SY85getMemType (data : TDataBlock) : String;
Function SY85getMemNumber (data : TDataBlock) : Integer;
Function SY85getDataFormatName (data : TDataBlock) : String;
Function SY85verifyYamahaBlock (data : TDataBlock) : Boolean;
Function SY85CreateBlockArray (data : TDataBlock) : TBlockArray;
Function SY85CalcChecksum (Var data :TDataBlock ): Word;
Function SY85VerifyChecksum (Var data :TDataBlock): Boolean;
Function SY85GetBlockSize (Var data : TDataBlock): Word;
Function   VerifyPV (data :TDataBlock) : Boolean;



Implementation

Function SY85GetBlockSize (Var data : TDataBlock): Word;
Begin
  SY85GetBlockSize := dataLengthCalc(data[5], data[6]);
End;


Function SY85CalcChecksum (Var data :TDataBlock ): Word;

Var 
  counter : Integer = 0;
  dataStart : Integer = 0;
  dataEnd : Integer = 0;
  sumData : Integer = 0;
Begin
  If SY85verifyYamahaBlock(data) Then
    Begin
      If  SY85GetBlockSize(data) < 538 Then
        Begin
          writeln('Less than 538');
          dataStart := 7;
          dataEnd := SY85GetBlockSize(data) + dataStart - 1;
          {-1 to NOT include current Checksum!}
          counter := dataStart;
          writeln ('FIRST : ' + IntToStr(data[dataStart]));
          writeln ('LAST  : ' + IntToStr(data[dataEnd]));
          While counter <= dataEnd Do
            Begin
              sumData := sumData + data[counter];
              counter := counter + 1;
            End ;
          sumData := ((sumData And byte(127)) Xor byte(127)) + 1;
           {(data [dataEnd + 1 ]) should be the same as sumData}
          result := sumData;
        End;

      If  SY85GetBlockSize(data) = 538 Then  writeln(' 538');
      {Routine to check multiple block checksums}
      If  SY85GetBlockSize(data) > 538 Then  writeln('More than 538');
    End;

End;

Function SY85VerifyChecksum (Var data :TDataBlock): Boolean;

Var 
  counter : Integer = 0;
  dataStart : Integer = 0;
  dataEnd : Integer = 0;
  sumData : Word = 0;
Begin
  If SY85verifyYamahaBlock(data) Then
    Begin
      If  SY85GetBlockSize(data) < 538 Then
        Begin
          writeln('Less than 538');
          dataStart := 7;
          dataEnd := SY85GetBlockSize(data) + dataStart;
          counter := dataStart;
          writeln ('FIRST : ' + IntToStr(data[dataStart]));
          writeln ('LAST  : ' + IntToStr(data[dataEnd]));
          While counter <= dataEnd Do
            Begin
              sumData := sumData + data[counter];
              counter := counter + 1;
            End ;
          writeln('SUM DATA : ' + IntToStr(sumData) + #9'DataEnd : ' + IntToStr(

                                                                         dataEnd
          ));
          writeln ('CHECKSUM in DATA Block : ' + IntToStr(data [dataEnd ]));
          writeln ('Calc : ' + IntToStr(sumData Mod 128));
          result :=  0 = sumData Mod 128;

        End;

      If  SY85GetBlockSize(data) = 538 Then  writeln(' 538');
      If  SY85GetBlockSize(data) > 538 Then  writeln('More than 538');
    End;

End;



{NO NEED FOR PUBLIC USE OF THIS FUNCTION}
Function sliceBlock(Var input :TDataBlock): TDataBlock;
{Slice is passed to input}
Begin
  result := TDataBlock(input);
End;


Function getPatchName (data :TDataBlock) : String;

Var 
  patchName : Array Of Char absolute data;
  nameChar : Array [1..11] Of Char;
  x : Integer = 1;

Begin
  For x := 1  To 11 Do
    Begin
      nameChar[x] := patchName[105 + x];
    End;
  result := String(nameChar);
End;


Function getPatchType (data : TDataBlock) : String;
    {THIS IS CRAP!}
Var 
  patchType : Array Of Char absolute data;
  typeChar : Array [1..6] Of Char;
  x : Integer = 1;
Begin
{Routine to get patchType from TDataBlock}
  For x := 1  To 6 Do
    Begin
      typeChar[x] := patchType[10 + x];
    End;
  result := String(typeChar);
End;


Function SY85CreateBlockArray (data : TDataBlock) : TBlockArray;

Var 
  blockCount : Integer = 0;
  counter : Integer = 0;
  sliceStart : Integer = 0;
  sliceEnd : Integer = 0;
  currentPos : Integer = 1;
  sliceSize : Integer = 0;
  patchNameConv : array Of Char absolute data;
  patchType : array [0..6] Of Char;
Begin

  blockCount := countSysexBlocks(data);
  setLength (SY85CreateBlockArray, blockCount);
  While counter <= blockCount Do
    Begin
      If data[currentPos] = 240 Then
        Begin
          sliceStart := currentPos;
          writeln ('DEBUG : sliceStart = '+ IntToStr (sliceStart));
          sliceSize := Integer(dataLengthCalc (data[currentPos + 4], data [
                       currentPos +
                       5]));
          writeln ('DEBUG : sliceSize = '+ IntToStr (sliceSize));
          sliceEnd := currentPos + sliceSize + 8;
          writeln ('DEBUG : sliceEnd = '+ IntToStr (sliceEnd));
          currentPos := sliceEnd;
          writeln ('DEBUG : EndValue  = '+ IntToStr (data[currentPos]));
          writeln ('DEBUG : COUNTER  = '+ IntToStr (counter));
          writeln ('DEBUG : Current POS  = '+ IntToStr (currentPos) +
          #9'HEX POS: '
          + IntToHex(currentPos, 2) + #9'HEX VALUE AT POS : ' + IntToHex(data[


                                                                      currentPos
                                                                         ], 2));
          counter := counter + 1;
          {===}
          writeln (' SLICESIZE : ' + IntToStr(sliceSize));
          If (sliceSize = 538 ) Then
            Begin
              currentPOS := currentPOS + 544;
              {540 is 538 + 2 bytes for block data + 4 for sysex header}
              writeln('538 LOOP : '  + IntToStr (currentPOS));
              writeln ('538 Blocks MSB : ' + IntToStr(data[currentPOS +1]));
              writeln ('538 Blocks LSB : ' + IntToStr(data[currentPOS + 2]));

              writeln ('SLICESIZE IS 538 HERE ! ');
              While (data[currentPOS +1]  = 4) And (data[currentPOS +2] = 26) Do
                Begin
                  currentPOS := CurrentPOS + 541;
                  write( '.');
                End;
              If ((data[currentPOS ]  <> Byte(4)) And (data[currentPOS +1]  <>
                 Byte(26))) Then
                Begin
                  writeln ('LAST BLOCK DATA : ' + IntToStr (data[currentPOS +2])
                  );
                  currentPOS := currentPOS + dataLengthCalc(data[currentPOS +1]
                                , data[currentPOS +2] ) + 5;
                  writeln ('LAST BLOCK iN 538 LOOP! ');

                End;
                {NEED A Check For End of block!}
            End;
          While (slicesize > 538) And (data[currentPOS -3] > 0) Do
            Begin
              writeln ('Extending Block...' + IntToStr (currentPOS));
              writeln ('Blocks Left : ' + IntToStr(data[currentPOS -3 ]));
              writeln ('Blocks Total : ' + IntToStr(data[currentPOS - 2]));
              currentPOS := currentPOS + sliceSize;
            End;

 {If sliceSize >= 538 then continue adding to block until MSB = LSB is reached!}
          {=== }
          {Store current slice in counter TDataBlockArray IN OTHER ROUTINE!}
          {Get Sysex SY85 Data Type String}
        End
      Else
        Begin
          If data[currentPos] = 247 Then writeln ('0xF7 found at POS : ' +
                                                  IntToStr(currentPOS) +
            '  -- HEX : ' +IntToHex(data[currentPos], 2))
          Else
            Begin
              If currentPOS >= length(data) Then exit();
              writeln ('---------> Programmer Error!  .!.');
              writeln ('---------> Current POS / Value : ' + IntToStr(currentPOS
              ) + ' / '+
              IntToStr(data[currentPOS]));
              writeln('TOTAL SIZE : ' + IntToStr(length(data)));
              exit();
            End;
        End;
          {@TODO REMOVE....This line with cause errors!}








{       This makes the program work, but some data is being 
                  missed some how...                                  }
    End;

{Create function to take slice of TDataBlock and return just that block}
End;


{Count 0xF0, get datalength, jump ahead, verify count, repeat until EOF}



Function SY85getMemType (data : TDataBlock) : String;

Var 
  memType : Byte = 0;
  {@TODO : Needs a revision for block type as well!}
Begin
  memType := data[30];
  Case memType Of 
    0 : SY85getMemType  := 'Int1';
    3 : SY85getMemType  := 'Int2';
    6 : SY85getMemType  := 'Int3';
    9 : SY85getMemType  := 'Int4';
    127 : SY85getMemType  := 'Edit Buffer';
  End;
End;


Function SY85getMemNumber (data : TDataBlock) : Integer;
Begin
  result := data[31];
End;


Function SY85getDataFormatName (data : TDataBlock) : String;

Var 

  x : Integer = 0;
Begin
  result := '';
  if (High(data) < 6) THEN result :='ERROR!';
  {Need Check for last block in file here!}
  if not ((Low(data) + 15) > High(data)) then
    BEGIN

  For x := 0 To 5 Do
    Begin
      result := result + Chr(data[Low(data) + 10 + x]);
    End;
END;
End;


Function SY85verifyYamahaBlock (data : TDataBlock) : Boolean;
Begin
  If data[2] = 67 Then result := true
  Else result := false;
End;

Function   VerifyPV (data :TDataBlock) : Boolean;
var
  memType : String;
Begin
   if (SY85getDataFormatName(data) = '0065PV') OR
   (SY85getDataFormatName(data) = '0065VC') THEN result := true
   else result :=false;
End;





Begin
End.
