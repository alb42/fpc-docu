procedure Proc(Parent: PTask; ParentSigMask: LongWord);
begin
  // Much work here...

  // Call destructors before we do internal cleanup
  TLSCallDestructors(nil);
  // Some cleanup that we need to do before exit
      

  Forbid();
  Signal(Parent, ParentSigMask);
end;

var
  Sig: ShortInt;
begin
  Sig := AllocSignal(-1);
  if Sig <> -1 then
  begin
    if CreateNewProc([
      NP_Entry,    AsTag(@Proc),
      NP_CodeType, CODETYPE_PPC,
      NP_PPC_Arg1, AsTag(FindTask(nil)),
      NP_PPC_Arg2, 1 shl Sig,
      TAG_DONE]) <> 0 then
    begin
      Wait(1 shl Sig);
    end;
  FreeSignal(Sig);
end;