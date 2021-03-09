uses
  Exec;
function func(value: APTR; userdata: APTR): APTR;
begin 
  FreeVec(value);
end;
// ...
var
  TLSIndex: LongWord;
begin
  TLSIndex := TLSAlloc([TLSTAG_DESTRUCTOR, AsTag(@func),
                        TLSTAG_USERDATA,   AsTag(something),
                        TAG_DONE]);
  if TLSIndex <> TLS_INVALID_INDEX then
  begin

    // ... more code ...

    TLSFree(TLSIndex);
  end
end.