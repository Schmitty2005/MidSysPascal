program midnatester;

uses midnamer;

Begin
writeln(midnamHeader);
writeln(patchNumber('01', 'TEST Patch', 00));
writeln(mc_controlchange(32,0));

End.

