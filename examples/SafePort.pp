function SafePutToPort(Msg: PMessage; Portname: string): Integer;
var
  Port: PMsgPort;
  PName: PChar;
begin
  Result := -1;
  PName := PChar(Portname + #0);
  Forbid();
  Port := FindPort(PName);
  if Assigned(Port) then
  begin
    PutMsg(Port, Msg);
    Result := 0;
  end;
  Permit();
end;