{$mode Delphi}
Program sysextest;

Uses Sy85Lib, SysexLib, SY85PVEdit, SY85Data, SysUtils;

Var 
  data : TDataBlock ;
  blocks : Integer;
  aData :TBlockArray;

Begin
  data := readSysEx('sysex.syx');
  writeln ('DaTA Size : ' + IntToStr (Length(data)));
  {
  blocks := countSysexBlocks(data);
  writeln('COMPLETE!');
  writeln('BLOCKS FOUND : ' + IntToStr(blocks));
  SY85CreateBlockArray(data);
}
writeln ('CHECKSUM : ' + IntToStr (SY85CalcChecksum(data))); {Just Testing}


aData := SY85CreateDataArray(data);

writeln ('aData High  : ' + IntToStr(High(aData)) + ' Low : ' + IntToStr(Low(aData)));

pvGetMem (aData[265]);
writeln ('LENGTH : ' + IntToStr(length(aData[265])) + ' Format : ' + SY85getDataFormatName(aData[265]) +
' Type : ' + SY85getMemType(aData[265]) + ' ' + pvGetName (aData[275])
);

   blocks := 0;
   for blocks := Low(aData) to High(aData) do
   Begin
   if VerifyPV(aData[blocks]) THEN
   Begin
   {writeln ('Memory : ' +}{ TODO : FINISH
 }
   writeln ('Patch Name : ' + pvGetName (aData[blocks]));
   End;
   End;

End.
