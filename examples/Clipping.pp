program clipping;
{$mode fpc}
{ The following example shows the use of the layers library call
  InstallClipRegion(), as well as simple use of the graphics library
  regions functions. Be aware that it uses Release 2 functions for
  opening and closing Intuition windows.

  Clipping.pp converted from original RKRM clipping.c
  tested with FPC 3.2.0}
uses
  Exec, AmigaDOS, AGraphics, Layers, Intuition, Utility;

const
  MY_WIN_WIDTH  = 300;
  MY_WIN_HEIGHT = 100;

{ UnclipWindow()
 Used to remove a clipping region installed by ClipWindow() or
 ClipWindowToBorders(), disposing of the installed region and
 reinstalling the region removed.}
procedure UnclipWindow(Win: PWindow);
var
  Old_Region: PRegion;
begin
  Old_Region := InstallClipRegion(Win^.WLayer, nil);
  // Remove any old region by installing a nil region, then dispose of the old region if one was installed.
  if Assigned(Old_Region) then
    DisposeRegion(Old_Region);
end;


{ ClipWindow()
  Clip a window to a specified rectangle (given by upper left and
  lower right corner.)  the removed region is returned so that it
  may be re-installed later.}
function ClipWindow(Win: PWindow; MinX, MinY, MaxX, MaxY: LongInt): PRegion;
var
  New_Region: PRegion;
  My_Rectangle: TRectangle;
begin
  // set up the limits for the clip
  My_Rectangle.MinX := MinX;
  My_Rectangle.MinY := MinY;
  My_Rectangle.MaxX := MaxX;
  My_Rectangle.MaxY := MaxY;

  New_Region := NewRegion();
  // get a new region and OR in the limits.
  if Assigned(NewRegion()) then
  begin
    if not Boolean(OrRectRegion(New_Region, @My_Rectangle)) then
    begin
      DisposeRegion(New_Region);
      New_Region := nil;
    end;
  end;

  // Install the new region, and return any existing region.
  // If the above allocation and region processing failed, then
  // New_Region will be NULL and no clip region will be installed.
  ClipWindow := InstallClipRegion(Win^.WLayer, New_Region);
end;

{ ClipWindowToBorders()
 clip a window to its borders. The removed region is returned so that it may be re-installed later.}
function ClipWindowToBorders(Win: PWindow): PRegion;
begin
  ClipWindowToBorders := ClipWindow(Win, Win^.BorderLeft, Win^.BorderTop, Win^.Width - Win^.BorderRight - 1, Win^.Height - Win^.BorderBottom - 1);
end;

// Wait for the user to select the close gadget.
procedure Wait_For_Close(win: PWindow);
var
  Msg: PIntuiMessage;
  Done: Boolean;
begin
  Done := False;
  while not Done do
  begin
    // we only have one signal bit, so we do not have to check which bit broke the Wait().
    Wait(1 shl win^.UserPort^.mp_SigBit);
    repeat
      Msg := PIntuiMessage(GetMsg(win^.UserPort));
      if not Assigned(Msg) then
        Break;
      //* use a switch statement if looking for multiple event types */
      if Msg^.IClass = IDCMP_CLOSEWINDOW then
        Done := True;

      ReplyMsg(PMessage(Msg));
    until Done;
  end;
end;


{ Simple routine to blast all bits in a window with color three to show
  where the window is clipped.  After a delay, flush back to color zero
  and refresh the window borders.}
procedure Draw_In_Window(Win: PWindow; Message: AnsiString);
begin
  Write(Message, '...');
  SetRast(Win^.RPort, 3);
  DOSDelay(200);
  SetRast(Win^.RPort, 0);
  RefreshWindowFrame(Win);
  Writeln('done');
end;


{ Show drawing into an unclipped window, a window clipped to the
 borders and a window clipped to a random rectangle.  It is possible
 to clip more complex shapes by AND'ing, OR'ing and exclusive-OR'ing
 regions and rectangles to build a user clip region.

 This example assumes that old regions are not going to be re-used,
 so it simply throws them away.}
procedure Clip_Test(Win: PWindow);
var
  Old_Region: PRegion;
begin
  Draw_In_Window(Win, 'Window with no clipping');

  // if the application has never installed a user clip region, then Old_Region will be nil here.
  // Otherwise, delete the old region (you could save it and re-install it later...)
  Old_Region := ClipWindowToBorders(Win);
  if not Assigned(Old_Region) then
    DisposeRegion(Old_Region);
  Draw_In_Window(Win, 'Window clipped to window borders');
  UnclipWindow(Win);

  // here we know Old_Region will be NULL, as that is what we installed with UnclipWindow()...
  Old_Region := ClipWindow(Win,20,20,100,50);
  if not Assigned(Old_Region) then
    DisposeRegion(Old_Region);
  Draw_In_Window(Win, 'Window clipped from (20,20) to (100,50)');
  UnclipWindow(Win);

  Wait_For_Close(Win);
end;

// Open and close resources, call the test routine when ready.
procedure StartMe;
var
  Win: PWindow;
begin
  Win := OpenWindowTags(nil, [
          TAG_(WA_Width)      , AsTag(MY_WIN_WIDTH),
          TAG_(WA_Height)     , AsTag(MY_WIN_HEIGHT),
          TAG_(WA_IDCMP)      , AsTag(IDCMP_CLOSEWINDOW),
          TAG_(WA_CloseGadget), AsTag(True),
          TAG_(WA_DragBar)    , AsTag(True),
          TAG_(WA_Activate)   , AsTag(True),
          TAG_END]);
  if Assigned(Win) then
  begin
    Clip_Test(Win);
    CloseWindow(Win);
  end;
end;


begin
  StartMe
end.
