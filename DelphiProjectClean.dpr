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

procedure CleanDirectory;
var
  TempExtension: string;
  TempFilename: string;
begin
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
end;

begin
  WriteLn('Delphi Directory Cleaning Utility Version 1.0');
  WriteLn('Copyright © 2010 by Nick Hodges All Rights Reserved');
  TotalFilesDeleted := 0;
  if ParamCount > 0 then
  begin
    DirectoryToClean := ParamStr(1);
  end
  else
  begin
    DirectoryToClean := ModulePath;
  end;
    Assert(DirectoryToClean <> '', 'Somehow the DirectoryToClean variable is empty.  That should be impossible.');
      CleanDirectory;
{$IFDEF DEBUG}
  Readln;
{$ENDIF}

end.
