{$Mode Delphi}
program limit;



Type
  TfxChain = 0..3;
  TfxTest = -127..128;
  TfxOut = 0..100;

Var
  chainTest : TfxChain;
  fxTets : TfxTest;
  fxOut : TfxOut;

begin
    chainTest := 1;
    fxTets :=23;
    fxOut := 50;
    writeln (IntToStr(Max(chaintest)));

end.
