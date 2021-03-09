program ExamineTest;
uses
  AmigaDos;
procedure CheckDir(ALock: BPTR);
var
  FIB: PFileInfoBlock;
begin
  FIB := AllocDosObject(DOS_FIB, nil);
  if Assigned(FIB) then
  begin
    if Examine(ALock, FIB) <> 0 then
    begin
      repeat
        writeln(FIB^.fib_FileName);
      until ExNext(ALock, FIB) = 0;
    end;
    if IOErr() = ERROR_NO_MORE_ENTRIES then
      writeln('nothing more found')
    else
      writeln('Something went wrong ', IOErr);
    FreeDosObject(DOS_FIB, FIB);
  end;
end;
var
  RAMLock: BPTR;
begin
  RAMLock := Lock('RAM:', SHARED_LOCK);
  CheckDir(RAMLock);
  unlock(RAMLock);
end.