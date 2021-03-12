// The following fragment shows proper double buffering synchronization:
var
  SafeToChange: Boolean = True;
  SafeToWrite: Boolean = True;
  CurBuffer: Integer = 1;
  Ports: array[0..1] of PMsgPort; // reply ports for DispMessage and SafeMessage
  BmPtrs: array[0..1] of PBitmap;
  myDBI: PDBufInfo;
begin
  //... allocate bitmap pointers, DBufInfo, set up viewports, create Ports etc.
  myDBI^.dbi_SafeMessage.mn_ReplyPort := ports[0];
  myDBI^.dbi_DispMessage.mn_ReplyPort := ports[1];
  while not done do
  begin
    if not SafeToWrite then
    begin
      while GetMsg(ports[0]) = nil do
        Wait(1 shl ports[0]^.mp_SigBit);
    end;
    SafeToWrite := True;
// ... render to bitmap # CurBuffer.
    if not SafeToChange then
    begin
      while GetMsg(ports[1]) = nil do
        Wait(1 shl ports[1]^.mp_SigBit);
    end;
    SafeToChange := True;
    WaitBlit();         // be sure rendering has finished
    ChangeVPBitMap(vp, BmPtrs[CurBuffer], myDBI);
    SafeToChange := False;
    SafeToWrite := False;
    CurBuffer := (CurBuffer + 1) and 1; // toggle current buffer
  end;
  if not SafeToChange then
  begin
    while GetMsg(ports[1]) = nil do
      Wait(1 shl ports[1]^.mp_SigBit);
  end;
  if not SafeToWrite then
  begin
    while GetMsg(ports[0]) = nil do
      Wait(1 shl ports[0]^.mp_SigBit);
  end;
end;