{$MODE delphi}
unit SY85Voice;

{fpdoc --package=test --input=SY85Voice.pas}
{create test documentation CLI}

interface

uses SysUtils, Classes;

const
  LENGTH_BUGGYROM = 239;
  LENGTH_GOODROM = 241;
  INC_BLOCK_SYSEX_SIZE = 8;
  ZF_16_BYTES: array [0..15] of byte = ($00, $00, $00, $00, $00, $00, $00, $00
    , $00, $00, $00, $00, $00, $00, $00, $00);


type
  TZeroFill = array [0..15] of byte;
  TVoiceList = Tlist;

  TBlockLength = packed record
    msbLength: byte;
    lsbLength: byte;
  end;

  Tsysexheader = packed record
    blockStart: byte;  // ALWAYS 0xF0 per Sysex Specifications
    manufacture: byte; //should be 43H or Decimal 67 for Yamaha!
    devId: byte;       // 0 to 15
    modelID: byte;     // always? 0x7A for SY85 ?
  end;

  TtempFXblock1 = array [0..71] of byte; {TEMP Placeholder @TODO Remove later}

  TtestFXHeader = packed record
    fxMode: byte;    {Length of 223 total 0065VC Data / Total is 239 withtempFXBlock }
    fxOneType: byte;  {19 bytes missing from here?}
    fxTwoType: byte;   {Correct}
    fxContOneParam: word;
    fxContOneAddOn: word;
    fxContTwoParam: word;
    fxContTwoAddOn: word;
    fxContTwoMinLimit: word;
    fxContTwoMaxLimit: word;
    {Educated Guessing the length of param's here}
    {Effects One Settings }
    fxOneParam1: word;
    fxOneParam2: word;
    fxOneParam3: word;
    fxOneParam4: word;
    fxOneParam5: word;
    fxOneParam6: word;
    fxOneParam7: word;
    fxOneParam8: word; {Maybe wrong ?}
    fxOneLevelA: word;
    fxOneLevelB: word;
    {Effects Two Settings }
    fxTwoParam1: word;
    fxTwoParam2: word;
    fxTwoParam3: word;
    fxTwoParam4: word;
    fxTwoParam5: word;
    fxTwoParam6: word;
    fxTwoParam7: word;
    fxTwoParam8: word; {Maybe wrong ?}
    fxTwoLevelA: word;
    fxTwoLevelB: word;
    fxMixLevel: word;
    fxBalanceOutOne: word;
    fxBalanceOutTwo: word;
    fxContOneMinLimit: byte;
    fxContOneMaxLimit: byte;
    fxLFOWave: byte;
    fxLFOSpeed: byte;
    fxLFODelayTime: byte;
    reserved: byte;
    placeholder: word; {Horrible temp fix @ TODO remove}
  end;

  TtempBlockAfterName = array [0..118] of byte;
  TVoiceName = array [0..9] of AnsiChar;
  {Start of SY85 Sysex}

  TSY85Header = packed record
    sysExHeader: Tsysexheader;
    blockSize: TBlockLength;
    blockType: array [0..9] of AnsiChar;  //CheckSum of data starts here also
  end;

  //PSY85Header = @TSY85Header;

  {Type for 0065VC - Voice }
  TSY85VoiceBlock = packed record
    header: TSY85Header;
    zeroFill: array [0..13] of byte;
    MemBank: byte;  {Value of 7F is Edit Bank (Correct?)}
    MemSlot: byte;
    Reserved1: byte;
    testfx: TtestFXHeader;
    {tempFX: TtempFXblock1;}//temp placeholder
    reserved2: array [0..2] of byte;
    voiceName: TVoiceName;
    reserved3: byte;
    awmCardID: word;
    tempData: TtempBlockAfterName;  //temp placeholder Data Checksum ends here
    checksum: byte;
    endSysEx: byte;
  end;

  {Type for 0065SY - System Settings}
  {@TODO Verify!}
  TSY85SystemSettings = packed record
    header: TSY85Header;
    zeroFill: TZeroFill;
    masterNoteShift: byte;
    masterFineTune: byte;
    keyboardTransmitCh: byte;
    voiceRecieveCh: byte;
    localSwitch: byte;
    deviceNumber: byte;
    bulkProtectSwitch: byte;
    programChangeSwitch: byte;
    volCtrlDevNo: byte;
    controllerReset: byte;
    reserved0: byte;
    reserved1: byte;
    effectSwitch: byte;
    mdrIntervalTime: byte;
    reserved2: byte;
    reserved3: byte;
    reserved4: byte;
    reserved5: byte;
    reserved6: byte;
    reserved7: byte;
    reserved8: byte;
    playFixVelocity: byte;
    keyOnVelCurve: byte;
    reserved9: byte;
    sramWaveSampStart: byte;
    reserved10: byte;
    waveRamDefaultSelect: byte;
    reserved11: array [0..5] of byte;
  end;


  {Type for 0065SS  - Sequencer }
  {@TODO Verify!}
  TSY85SequencerSettings = packed record
    header: TSY85Header;
    zeroFill: TZeroFill;
    clickCondition: byte;
    clockSource: byte;
    seqRecChannel: byte;
    afterTouchRecSw: byte;
    reserved0: byte;
    songNumber: byte;
    recType: byte;
    midiControl: byte;
    songLoop: byte;
    songChain: byte;
    reserved: array [0..5] of byte;
  end;

  {Type for  Rhythm  placed at End of System Settings Block}
  {@TODO Verify}
  TY85RythmSettings = packed record
    rhthmMode: byte;
    rhythmRecType: byte;
    patternNumber: word;
    ptnRecClickBeat: byte;
    ptnRecQuantize: byte;
    ptnRecAcc1: byte;
    ptnRecAcc2: byte;
    ptnRecAcc3: byte;
    ptnRecFixVel: word;
    reserved: array [0..5] of byte;
  end;

var
  tester: string;

 function calcDataLength(block: TSY85VoiceBlock): word;
 Function readSysEx(fnam: String): TBytesStream;
 function parseVoice (data : TBytesStream) : TList;
 function CalcBlockSize (sy85head : TSY85Header) : Word;

implementation

function calcChecksum(block: TSY85VoiceBlock): byte;
var
  convert: word;
begin
  {@TODO complete}
end;

function calcDataLength(block: TSY85VoiceBlock): word;
{Maybe create a function to convert SYSEX doubles to actuall doubles ?}

{This can be replaced with similar CalcBlockSize code}
var
  output: word;
begin
  output := block.header.blockSize.msbLength;
  output := output<<7;
  output := output OR block.header.blockSize.lsbLength;
  result := output;
end;

Function readSysEx(fnam: String): TBytesStream;

Var
  fstream: TFileStream;
  n: longint;
  data : TBytesStream;//Array Of  Byte;

Begin
  fstream := TFileStream.Create(fnam, fmOpenRead Or fmShareDenyWrite);
  Try
   n := fstream.Size;
   data := TBytesStream.Create;
   data.SetSize(n);
   data.CopyFrom(fstream, fstream.Size);   //Found method to get from file :(
  Finally
    fstream.Free;
End;
result := data;
End;

function CalcBlockSize (sy85head : TSY85Header) : Word;
var
   sizeBlock : TBlockLength;
   calcSize : Word;
begin
  CalcSize := 0;
  sizeBlock := sy85head.blockSize;
  calcSize := sizeBLock.msbLength;
  calcSize := calcSize SHL 7;
  calcSize := calcSize OR sizeBlock.lsbLEngth;
  result := calcSize+INC_BLOCK_SYSEX_SIZE;
end;

function parseVoice (data : TBytesStream) : TList;
  {@TODO NOT FINISHED! NOT EVEN CLOSE}
var
    counter : Integer;
    position : Integer;
    currentblockSize : Word;
    VoiceList : Tlist;
    BlockList : Tlist;
    voicePointer : ^TSY85VoiceBLock;
    voiceBlock : TSY85VoiceBlock;
    voiceBlock2 : TSY85VoiceBlock;
    sy85Header : TSY85Header;
    psy85Header : ^TSY85Header;

Begin

BlockList := Tlist.Create;
data.position := 0;
psy85Header := data.Memory;


currentBlockSize := CalcBlockSize (psy85Header^);


{TEST Code Below for expirimentation}
data.Position:=0;
voicePointer := data.Memory;
voiceBlock := voicePointer^;
voiceList := Tlist.create;
voiceList.add(voicePointer);
Inc(voicePointer);
voiceBlock2 := voicePointer^;
voiceLIst.add(VoicePointer);
{END of test code;}
end;



end.
