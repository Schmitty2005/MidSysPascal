{$mode objfpc}{$H+}

Unit SY85PVEdit;

Interface

Type 
  TDataBlock = array Of byte;
  TMemSlot = array [1..2] Of Word;
  
  {NOTE: Memory name starts at position 105 in 0065PV  and 0065VC types}

Function pvGetMem (Var data : TDataBlock) : TMemSlot;
Procedure pvSetMem (Var data : TDataBlock; slot : Word; number : Word);
Function pvGetMemString  (Var data : TDataBlock) : String;

Function pvGetName (Var data : TDataBlock ) : String;
Procedure pvSetName (Var data : TDataBlock ) ;
{after setMem, remeber to reclalc CheckSum}

Implementation

Uses  SysUtils, StrUtils, TypInfo;

Type
TMemEnum = (ERROR0, Int1, ERROR1, Int2, ERROR2, ERROR3,  Int3, ERROR4, ERROR5, Int4);


Function pvGetMem (Var data : TDataBlock): TMemSlot;

Var 
  memSlot : TMemSlot;
  memEnum : TMemEnum;
Begin
{Get pos 30 and 31 from patch to determine mem location}
  memSlot [low(memSlot)] := data[low(data) + 30];
  memSlot [high(memSlot)] := data [high(data) + 30];
{DEBUG WRITELN}
  writeln('Mem Slot    : ' + (GetEnumName(TypeInfo(TMemEnum), 1)));
  writeln('Patch Number: ' + IntToStr (memSlot[high(memSlot)]) );
{=============}
  result := memSlot
End;


Procedure pvSetMem (Var data : TDataBlock; slot : Word; number : Word);
Begin
End;

Function pvGetName (Var data : TDataBlock ) : String;
var{ TODO 1 -oBLS -cdata : Verify Performance or Voice}
  counting : integer;
Begin
  result := '';
  for counting := 0 to 9  do
   result := result + Char(data[Low(data) + 105 + counting]);
  End;

Procedure pvSetName (Var data : TDataBlock ) ;
Begin
  End;

 Function pvGetMemString  (Var data : TDataBlock) : String;
      Var
  memSlot : TMemSlot;
  memEnum : TMemEnum;

 Begin
    memSlot [low(memSlot)] := data[low(data) + 30];
  memSlot [high(memSlot)] := data [high(data) + 30];

 result := ('Mem Slot    : ' + (GetEnumName(TypeInfo(TMemEnum), 1)) +
  'Patch Number: ' + IntToStr (memSlot[high(memSlot)]) );
 end;

Begin

End.
