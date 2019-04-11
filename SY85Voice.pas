{$MODE delphi}
unit SY85Voice;

{fpdoc --package=test --input=SY85Voice.pas}
{create test documentation CLI}

interface

uses SysUtils;

const
  LENGTH_BUGGYROM = 239;
  LENGTH_GOODROM = 241;
  ZF_16_BYTES: array [0..15] of byte = ($00, $00, $00, $00, $00, $00, $00, $00
    , $00, $00, $00, $00, $00, $00, $00, $00);


type
  TZeroFill = array [0..15] of byte;

  Tsysexheader = packed record
    blockStart: byte;  // ALWAYS 0xF0 per Sysex Specifications
    manufacture: byte; //should be 43H or Decimal 67 for Yamaha!
    devId: byte;       // 0 to 15
    modelID: byte;     // always? 0x7A for SY85 ?
  end;

  TtempFXblock1 = array [0..71] of byte;
  TtempBlockAfterName = array [0..121] of byte;
  TVoiceName = array [0..9] of AnsiChar;
  {Start of SY85 Sysex}
  TSY85Header = packed record
    sysExHeader: Tsysexheader;
    blockSizeMSB: byte;
    blockSizeLSB: byte;
    blockType: array [0..9] of AnsiChar;  //CheckSum of data starts here also
  end;

  {Type for 0065VC - Voice }
  TSY85VoiceBlock = packed record
    header: TSY85Header;
    zeroFill: array [0..15] of byte;
    Reserved1: byte;
    tempFX: TtempFXblock1; //temp placeholder
    voiceName: TVoiceName;
    tempData: TtempBlockAfterName;  //temp placeholder Data Checksum ends here
    checksum: byte;
    endSysEx: byte;
  end;

  {Type for 0065SY - System Settings}
  {@TODO Verify!}
  TSY85SystemSettings = packed record
    header : TSY85Header;
    zeroFill : TZeroFill;
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
    reserved11: Array [0..5] of byte;
  end;


  {Type for 0065SS  - Sequencer }
  {@TODO Verify!}
  TSY85SequencerSettings = packed record
    header : TSY85Header;
    zeroFill : TZeroFill;
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
    reserved : Array [0..5] of byte;
  end;

  {Type for  Rhythm  placed at End of System Settings Block}
  {@TODO Verify}
  TY85RythmSettings = packed record
    rhthmMode: byte;
    rhythmRecType: byte;
    patternNumber: Word;
    ptnRecClickBeat: byte;
    ptnRecQuantize: byte;
    ptnRecAcc1: byte;
    ptnRecAcc2: byte;
    ptnRecAcc3: byte;
    ptnRecFixVel: Word;
    reserved : Array [0..5] of byte;
  end;


var
  tester: string;



// @TODO Function for calculating checksum

implementation

begin

end.
