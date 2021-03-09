type
  TTLSData = record
    foo: LongWord;
    bar: PChar;
    // ... 
  end;
  PTLSData = ^TTtlsdata;

var
  TLSIndex: LongWord; // Set and cleaned up elsewhere
  TLSData: Ptlsdata;

begin
  Data := PTLSData(TLSGetValue(TLSIndex));
  if not Assigned(data) then
  begin
    data := PTLSData(AllocVec(SizeOf(Ttlsdata), MEMF_CLEAR));    
    if not Assigned(data) or (TLSSetValue(TLSIndex, data) <> 0) then
    begin
      if Assigned(data) then
      begin
        FreeVec(data);
        data := NULL;
      end;
    end;
  end;

  if Assigned(data) then
  begin
    // Use the thread specific data. ...
  end;

  //...

  // Thread specific data is no longer needed, free it.
  data := PTLSData(TLSGetValue(tlsindex));
  if Assigned(data) then
  begin
    FreeVec(Data);
    TLSSetValue(tlsindex, nil); // Always succeeds
  end;
end;