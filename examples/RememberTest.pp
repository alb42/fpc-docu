program RememberTest;
uses
  Intuition;
var
  RememberKey: PRemember;
begin
  RememberKey := nil;
  buffer := AllocRemember(@RememberKey, BUFSIZE, MEMF_CHIP);
  if Assigned(buffer) then
  begin
    // Use the buffer
    //...
  end;
  FreeRemember(@RememberKey, True);
end.