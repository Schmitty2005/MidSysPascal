{$mode Delphi}
Unit SY85Data;



Interface

Uses SysUtils, Math, StrUtils,   SysexLib;

Type 
  TBlockArray = Array Of TDataBlock;

Function SY85CreateDataArray (data : TDataBlock) : TBlockArray;

Implementation

Function SY85CreateDataArray (data : TDataBlock) : TBlockArray;

Var 
  blockCount : Integer = 0; //switched to 1 from 0  for exception testing 4-15-2024
  counter : Integer = 0;
  sliceStart : Integer = 0;
  sliceEnd : Integer = 0;
  currentPos : Integer = 1; //switchin to 0 causes major problems.
  sliceSize : Integer = 0;
  patchNameConv : array Of Char absolute data;
  patchType : array [0..6] Of Char;
  SY85DataArray  : TBlockArray;
Begin

  blockCount := countSysexBlocks(data);
  setLength (SY85DataArray, Integer(blockCount));

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
          + IntToHex(currentPos, 2) + #9'HEX VALUE AT POS : ' + IntToHex(data[currentPos], 2));
          
          {PUT Data Slice into blockarray[x] here}
          SY85DataArray[counter] := copy(data, sliceStart, sliceEnd);
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

Begin
End.
