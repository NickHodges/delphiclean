unit uDelphiCleanIntf;

interface

type
  IDelphiClean = interface
    ['{0759E89C-7428-4FB8-A53A-4C34758BD242}']
    function CleanDirectory(aDirectoryToClean: string): integer;
  end;

implementation

end.
