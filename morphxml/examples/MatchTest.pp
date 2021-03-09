program MatchTest;
uses
  amigados;
procedure FindIcons(Pattern: AnsiString);
var
  Anchor: TAnchorPath;
begin
  if MatchFirst(PChar(Pattern), @Anchor) = 0 then
  begin
    repeat
      writeln(Anchor.ap_Info.fib_Filename);
    until MatchNext(@Anchor) <> 0;
    MatchEnd(@Anchor);
  end;
end;
begin
  FindIcons('sys:#?.info');
end.