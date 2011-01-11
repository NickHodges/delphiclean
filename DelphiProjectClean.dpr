program DelphiProjectClean;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Windows,
  IOUtils;

var
  DirectoryToClean: string;
  TotalFilesDeleted: integer;

const
  TExtensionList: array [0 .. 7] of string = ('*.dcp', '*.dcu', '*.identcache', '*.local', '*.exe', '*.dll', '*.bpl', '*.dcp');

function GetModuleFileNameStr: string;
begin
  SetLength(Result, Max_Path);
  SetLength(Result, GetModuleFileName(hInstance, PChar(Result), Length(Result)));
end;

function ModulePath: string;
begin
  Result := ExtractFilePath(GetModuleFileNameStr);
end;

function CleanDirectory: integer;
var
  TempExtension: string;
  TempFilename: string;
  TempTotal: integer;
begin
  TempTotal := 0;
  if TDirectory.Exists(DirectoryToClean) then
  begin
    WriteLn('Removing Delphi-produced files from ', DirectoryToClean, '...');
    for TempExtension in TExtensionList do
    begin
      for TempFilename in TDirectory.GetFiles(DirectoryToClean, TempExtension, TSearchOption.soAllDirectories) do
      begin
        WriteLn('Deleting ', TempFilename, ' ....');
        TFile.Delete(TempFilename);
        Inc(TempTotal);
      end
    end;
  end
  else
  begin
    WriteLn('Directory is invalid or doesn''t exist: ', DirectoryToClean);
  end;
  Result := TempTotal;
end;

begin
 { TODO : Allow recursiveness to be a command line option }
  WriteLn('Delphi Directory Cleaning Utility Version 1.0');
  WriteLn('Copyright © 2011 by Nick Hodges All Rights Reserved');
//  TotalFilesDeleted := 0;
  if ParamCount > 0 then
  begin
    DirectoryToClean := ParamStr(1);
  end
  else
  begin
    // if no directory is passed, attempt to clean the directory where the
    // EXE resides
    DirectoryToClean := ModulePath;
  end;
  Assert(DirectoryToClean <> '', 'Somehow the DirectoryToClean variable is empty.  That should be impossible.');
  TotalFilesDeleted := CleanDirectory;

  if TotalFilesDeleted = 0 then
  begin
    WriteLn('No files found');
  end;

  WriteLn('Total files deleted: ', TotalFilesDeleted);
  WriteLn('All Done.');
{$IFDEF DEBUG}
  Readln;
{$ENDIF}

end.
