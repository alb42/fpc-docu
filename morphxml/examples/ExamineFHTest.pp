program ExamineFHTest;
uses
  AmigaDOS;
var
  FH: BPTR;
  FIB: PFileInfoBlock;
begin
  FH := DOSOpen('c:dir', MODE_OLDFILE);
  FIB := AllocDosObject(DOS_FIB, nil);
  if Assigned(FIB) and (FH <> 0) then
  begin
    if Boolean(ExamineFH(FH, FIB)) then
      writeln('Size: ',FIB^.fib_size);
  end;
  if Assigned(FIB) then FreeDosObject(DOS_FIB, FIB);
  if FH <> 0 then DOSClose(FH);
end.