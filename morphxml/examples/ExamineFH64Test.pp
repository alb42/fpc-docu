program ExamineFH64Test;
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
    if Boolean(ExamineFH64(FH, FIB, nil)) then
      writeln('Size: ', FIB^.fib_size64);
  end;
  if Assigned(FIB) then FreeDosObject(DOS_FIB, FIB);
  if FH <> 0 then DOSClose(FH);
end.