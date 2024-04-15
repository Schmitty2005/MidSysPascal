
Unit sysexheader;

{Need enumarator built for MFR info.  Also check for 00 in 2nd byte of header for extended mfr info!}
Interface

{If first manufactur # is 00, header is exteded by two bytes}

Type 
  Tsysexheader = Record
    blockStart : byte;
    manufacture : byte;  //should be 43H or Decimal 67 for Yamaha!
    devId : byte;
    modelID : byte;
    end;
    
    TsysexheaderExtended = Record
      blockStart : byte;
      manufacture0 : byte; //should be 00 to indicate extended!
      manufacture : word; //double digit MFR # ! 
      devID : byte;
      modelID : byte;
end;
      Implementation

      
procedure checkExtended(header : Tsysexheader);

begin
if (header.manufacture) = 0 then 
writeln ('Extended header found!');
end;
    
    begin
    end.
