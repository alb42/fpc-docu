program Examine64Test;
uses
  AmigaDos;
procedure CheckDir(ALock: BPTR);
var
  FIB: PFileInfoBlock;
begin
  FIB := AllocDosObject(DOS_FIB, nil);
  if Assigned(FIB) then
  begin
    if Examine64(ALock, FIB, nil) <> 0 then
    begin
      repeat
        writeln(FIB^.fib_FileName);
      until ExNext64(ALock, FIB, nil) = 0;
    end;
    if IOErr() = ERROR_NO_MORE_ENTRIES then
      writeln('nothing more found')
    else
      writeln('Something went wrong ', IOErr);
    FreeDosObject(DOS_FIB, FIB);
  end;
end;
var
  RamLock: BPTR;
begin
  RamLock := Lock('RAM:', SHARED_LOCK);
  CheckDir(RamLock);
  Unlock(RamLock);
end.