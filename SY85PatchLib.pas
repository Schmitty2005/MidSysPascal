unit SY85PatchLib;

uses Sy85Lib, SysexLib, strutils, sysutils;

interface
type
TSY85Voice = TClassName = class(Tancestor)
private
    function getName : String
protected
    
public
    constructor Create; override;
    destructor Destroy; override;

published
property voiceName : string read 
    
end;

implementation

begin
    
end;

begin

end;

