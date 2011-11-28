unit uDelphiClean;

interface

uses
    uDelphiCleanIntf
  ;

  procedure DoDelphiClean;

implementation

uses
      Windows
    , SysUtils
    , IOUtils
    ;

const
  TExtensionList: array [0 .. 7] of string = ('*.dcp', '*.dcu', '*.identcache', '*.local', '*.exe', '*.dll', '*.bpl', '*.dcp');

type
  TDelphiCleaner = class(TInterfacedObject, IDelphiClean)
  public
    function CleanDirectory(aDirectoryToClean: string): integer;
  end;

function GetModuleFileNameStr: string;
begin
  SetLength(Result, Max_Path);
  SetLength(Result, GetModuleFileName(hInstance, PChar(Result), Length(Result)));
end;

function ModulePath: string;
begin
  Result := ExtractFilePath(GetModuleFileNameStr);
end;

function TDelphiCleaner.CleanDirectory(aDirectoryToClean: string): integer;
var
  TempExtension: string;
  TempFilename: string;
  TempTotal: integer;
begin
  TempTotal := 0;
  if TDirectory.Exists(aDirectoryToClean) then
  begin
    WriteLn('Removing Delphi-produced files from ', aDirectoryToClean, '...');
    for TempExtension in TExtensionList do
    begin
      for TempFilename in TDirectory.GetFiles(aDirectoryToClean, TempExtension, TSearchOption.soAllDirectories) do
      begin
        WriteLn('Deleting ', TempFilename, ' ....');
        TFile.Delete(TempFilename);
        Inc(TempTotal);
      end
    end;
  end
  else
  begin
    WriteLn('Directory is invalid or doesn''t exist: ', aDirectoryToClean);
  end;
  Result := TempTotal;
end;

var
  FDelphiCleaner: IDelphiClean;

function DelphiCleaner: IDelphiClean;
begin
  if FDelphiCleaner = nil then
  begin
    FDelphiCleaner := TDelphiCleaner.Create;
  end;
  Result := FDelphiCleaner;
end;

procedure DoDelphiClean;
var
  DirectoryToClean: string;
  TotalFilesDeleted: integer;
begin
  { TODO : Allow recursiveness to be a command line option }
  WriteLn('Delphi Directory Cleaning Utility Version 1.0');
  WriteLn('Copyright © 2011 by Nick Hodges All Rights Reserved');
  if ParamCount > 0 then
  begin
    DirectoryToClean := ParamStr(1);
  end else
  begin
    // if no directory is passed, attempt to clean the directory where the
    // EXE resides
    DirectoryToClean := ModulePath;
  end;
  Assert(DirectoryToClean <> '', 'Somehow the DirectoryToClean variable is empty.  That should be impossible.');
  TotalFilesDeleted := DelphiCleaner.CleanDirectory(DirectoryToClean);

  if TotalFilesDeleted = 0 then
  begin
    WriteLn('No files found');
  end else
  begin
    WriteLn('Total files deleted: ', TotalFilesDeleted);
  end;
  WriteLn('All Done.');
end;


end.
