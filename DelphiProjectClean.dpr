program DelphiProjectClean;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Windows,
  IOUtils;

var
  DirectoryToClean: string;

  TempFilename: string;
  TotalFilesDeleted: integer;
  TempExtension: string;

const
  TExtensionList: array [0 .. 7] of string = ('*.dcp', '*.dcu', '*.identcache', '*.local', '*.exe', '*.dll', '*.bpl', '*.dcp');

begin
  WriteLn('Delphi Directory Cleaning Utility Version 1.0');
  WriteLn('Copyright © 2010 by Nick Hodges All Rights Reserved');
  TotalFilesDeleted := 0;
  if ParamCount > 0 then
  begin
    DirectoryToClean := ParamStr(1);
    if TDirectory.Exists(DirectoryToClean) then
    begin
      WriteLn('Removing Delphi-produced files from ', DirectoryToClean, '...');
      for TempExtension in TExtensionList do
      begin
        for TempFilename in TDirectory.GetFiles(DirectoryToClean, TempExtension, TSearchOption.soAllDirectories) do
        begin
          WriteLn('Deleting ', TempFilename, ' ....');
          TFile.Delete(TempFilename);
          Inc(TotalFilesDeleted);
        end
      end;
      if TotalFilesDeleted = 0 then
      begin
        WriteLn('No files found');
      end;
    end
    else
    begin
      WriteLn('Directory is invalid: ', DirectoryToClean);
    end;

    WriteLn('Total files deleted: ', TotalFilesDeleted);
    WriteLn('All Done.');
  end
  else
  begin
    WriteLn('Usage: Clean [directory to clean]');
  end;
{$IFDEF DEBUG}
  Readln;
{$ENDIF}

end.
