program DelphiProjectClean;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Windows,
  IOUtils,
  uDelphiClean in 'uDelphiClean.pas',
  uDelphiCleanIntf in 'uDelphiCleanIntf.pas';

begin
  DoDelphiClean;
{$IFDEF DEBUG}
  Readln;
{$ENDIF}

end.
