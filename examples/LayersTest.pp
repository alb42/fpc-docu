program LayersTest;
{ For the sake of brevity, the example is a single task.  No Layer
  locking is done.  Also note that the routine MyLabelLayer() is used
  to redraw a given layer.  It is called only when a layer needs
  refreshing.

  LayersTest.pp converted from original RKRM layers.c
  tested with FPC 3.2.0}
{$mode fpc}
uses
  Exec, AmigaDOS, AGraphics, Layers;
const
  L_DELAY = 100;
  S_DELAY =  50;

  DUMMY = 0;

  RED_PEN   = 1;
  GREEN_PEN = 2;
  BLUE_PEN  = 3;

  SCREEN_D =   2;
  SCREEN_W = 320;
  SCREEN_H = 200;

  // the starting size of example layers, offsets are used for placement
  W_H = 50;
  W_T = 5;
  W_B = (W_T + W_H) - 1;
  W_W = 80;
  W_L = (SCREEN_W div 2) - (W_W div 2);
  W_R = (W_L + W_W) - 1;

  // size of the superbitmap
  SUPER_H = SCREEN_H;
  SUPER_W = SCREEN_W;

  // starting size of the message layer
  M_H = 10;
  M_T = SCREEN_H - M_H;
  M_B = (M_T + M_H) - 1;
  M_W = SCREEN_W;
  M_L = 0;
  M_R = (M_L + M_W) - 1;

  // global constant data for initializing the layers
  TheLayerFlags: array[0..2] of LongInt = (LAYERSUPER, LAYERSMART, LAYERSIMPLE);
  ColorTable: array [0..3] of Word = ($000, $f44, $4f4, $44f);


// Clear the layer then draw in a text string.
procedure MyLabelLayer(Layer: PLayer; Color: LongInt; str: AnsiString);
begin
  // fill Layer with color
  SetRast(Layer^.rp, Color);

  // set up for writing text into Layer
  SetDrMd(Layer^.rp, JAM1);
  SetAPen(Layer^.rp, 0);
  GfxMove(Layer^.rp, 5, 7);

  // write into Layer
  GfxText(Layer^.rp, PChar(str), Length(str));
end;

// write a message into a layer with a delay.
procedure DoMessage(Layer: PLayer; Str: AnsiString);
begin
  DOSDelay(S_DELAY);
  MyLabelLayer(Layer, GREEN_PEN, str);
end;

// write an error message into a layer with a delay.
procedure Error(Layer: PLayer; Str: AnsiString);
begin
  MyLabelLayer(Layer, RED_PEN, Str);
  DOSDelay(L_DELAY);
end;

// do some layers manipulations to demonstrate their abilities.
procedure DoLayers(MsgLayer: PLayer; var Layer_Array: array of PLayer);
var
  ktr: SmallInt;
  ktr_2: SmallInt;
begin
  DoMessage(MsgLayer, 'Label all Layers');
  MyLabelLayer(Layer_Array[0], RED_PEN,   'Super');
  MyLabelLayer(Layer_Array[1], GREEN_PEN, 'Smart');
  MyLabelLayer(Layer_Array[2], BLUE_PEN,  'Simple');

  DoMessage(MsgLayer, 'MoveLayer 1 InFrontOf 0');
  if not Boolean(MoveLayerInFrontOf(Layer_Array[1], Layer_Array[0])) then
    Error(MsgLayer, 'MoveLayerInFrontOf() failed.');

  DoMessage(MsgLayer, 'MoveLayer 2 InFrontOf 1');
  if not Boolean(MoveLayerInFrontOf(Layer_Array[2], Layer_Array[1])) then
    Error(MsgLayer, 'MoveLayerInFrontOf() failed.');

  DoMessage(MsgLayer, 'Refresh Simple Refresh Layer');
  MyLabelLayer(Layer_Array[2], BLUE_PEN, 'Simple');

  DoMessage(MsgLayer, 'Incrementally MoveLayers...');
  for ktr := 0 to 29 do
  begin
    if not Boolean(MoveLayer(DUMMY, Layer_Array[1], -1, 0)) then
      Error(MsgLayer, 'MoveLayer() failed.');
    if not Boolean(MoveLayer(DUMMY, Layer_Array[2], -2, 0)) then
      Error(MsgLayer, 'MoveLayer() failed.');
  end;

  DoMessage(MsgLayer, 'Refresh Simple Refresh Layer');
  MyLabelLayer(Layer_Array[2], BLUE_PEN, 'Simple');

  DoMessage(MsgLayer, 'make Layer 0 the UpfrontLayer');
  if not Boolean(UpfrontLayer(DUMMY, Layer_Array[0])) then
    Error(MsgLayer, 'UpfrontLayer() failed.');

  DoMessage(MsgLayer, 'make Layer 2 the BehindLayer');
  if not Boolean(BehindLayer(DUMMY, Layer_Array[2])) then
    Error(MsgLayer, 'BehindLayer() failed.');

  DoMessage(MsgLayer, 'Incrementally MoveLayers again...');
  for ktr := 0 to Pred(30) do
  begin
    if not Boolean(MoveLayer(DUMMY, Layer_Array[1], 0, 1)) then
      Error(MsgLayer, 'MoveLayer() failed.');
    if not Boolean(MoveLayer(DUMMY, Layer_Array[2], 0, 2)) then
      Error(MsgLayer, 'MoveLayer() failed.');
  end;

  DoMessage(MsgLayer, 'Refresh Simple Refresh Layer');
  MyLabelLayer(Layer_Array[2], BLUE_PEN, 'Simple');

  DoMessage(MsgLayer, 'Big MoveLayer');
  for ktr := 0 to High(Layer_Array) do
    if not Boolean(MoveLayer(DUMMY, Layer_Array[ktr], -Layer_Array[ktr]^.bounds.MinX, 0)) then
      Error(MsgLayer, 'MoveLayer() failed.');


  DoMessage(MsgLayer, 'Incrementally increase size');
  for ktr := 0 to 4 do
    for ktr_2 := 0 to High(Layer_Array) do
      if not Boolean(SizeLayer(DUMMY, Layer_Array[ktr_2], 1, 1)) then
        Error(MsgLayer, 'SizeLayer() failed.');

  DoMessage(MsgLayer, 'Refresh Smart Refresh Layer');
  MyLabelLayer(Layer_Array[1], GREEN_PEN, 'Smart');
  DoMessage(MsgLayer, 'Refresh Simple Refresh Layer');
  MyLabelLayer(Layer_Array[2], BLUE_PEN,  'Simple');

  DoMessage(MsgLayer, 'Big SizeLayer');
  for ktr := 0 to High(Layer_Array) do
    if not Boolean(SizeLayer(DUMMY, Layer_Array[ktr], SCREEN_W - (Layer_Array[ktr]^.bounds.MaxX) - 1, 0)) then
      Error(MsgLayer, 'SizeLayer() failed.');

  DoMessage(MsgLayer, 'Refresh Smart Refresh Layer');
  MyLabelLayer(Layer_Array[1], GREEN_PEN, 'Smart');
  DoMessage(MsgLayer, 'Refresh Simple Refresh Layer');
  MyLabelLayer(Layer_Array[2], BLUE_PEN,  'Simple');

  DoMessage(MsgLayer, 'ScrollLayer down');
  for ktr := 0 to 29 do
    for ktr_2 := 0 to High(Layer_Array) do
      ScrollLayer(DUMMY, Layer_Array[ktr_2], 0, -1);

  DoMessage(MsgLayer, 'Refresh Smart Refresh Layer');
  MyLabelLayer(Layer_Array[1], GREEN_PEN, 'Smart');
  DoMessage(MsgLayer, 'Refresh Simple Refresh Layer');
  MyLabelLayer(Layer_Array[2], BLUE_PEN,  'Simple');

  DoMessage(MsgLayer, 'ScrollLayer up');
  for ktr := 0 to 29 do
    for ktr_2 := 0 to High(Layer_Array) do
      ScrollLayer(DUMMY, Layer_Array[ktr_2], 0, 1);

  DoMessage(MsgLayer, 'Refresh Smart Refresh Layer');
  MyLabelLayer(Layer_Array[1], GREEN_PEN, 'Smart');
  DoMessage(MsgLayer, 'Refresh Simple Refresh Layer');
  MyLabelLayer(Layer_Array[2], BLUE_PEN,  'Simple');

  DOSDelay(L_DELAY);
end;


// delete the layer array created by allocLayers().
procedure DisposeLayers(MsgLayer: PLayer; var Layer_Array: array of PLayer);
var
  ktr: SmallInt;
begin
  for ktr := 0 to High(Layer_Array) do
    if (Layer_Array[ktr] <> nil) then
      if not Boolean(DeleteLayer(DUMMY, Layer_Array[ktr])) then
        Error(MsgLayer, 'Error deleting layer');
end;


{Create some hard-coded layers.  The first must be super-bitmap, with
 the bitmap passed as an argument.  The others must not be super-bitmap.
 The pointers to the created layers are returned in Layer_Array.

 Return False on failure.  On a False return, the layers are
 properly cleaned up.}
function AllocLayers(MsgLayer: PLayer; var Layer_Array: array of PLayer; Super_Bitmap: PBitmap; TheLayerInfo: PLayer_Info; TheBitMap: PBitMap): Boolean;
var
  ktr: SmallInt;
  Create_Layer_Ok: Boolean = True;
begin
  ktr := 0;
  while (ktr < Length(Layer_Array)) and (Create_Layer_Ok) do
  begin
    DoMessage(MsgLayer, 'Create BehindLayer');
    if ktr = 0 then
    begin
      Layer_Array[ktr] := CreateBehindLayer(TheLayerInfo, TheBitMap, W_L + (ktr * 30), W_T + (ktr * 30), W_R + (ktr * 30), W_B + (ktr * 30), TheLayerFlags[ktr], Super_Bitmap);
      if not Assigned(Layer_Array[ktr]) then
        Create_Layer_Ok := False;
    end
    else
    begin
      Layer_Array[ktr] := CreateBehindLayer(TheLayerInfo, TheBitMap, W_L + (ktr * 30), W_T + (ktr * 30), W_R + (ktr * 30), W_B + (ktr * 30), TheLayerFlags[ktr], nil);
      if not Assigned(Layer_Array[ktr]) then
        Create_Layer_Ok := FALSE;
    end;
    if Create_Layer_Ok then
    begin
      DoMessage(MsgLayer, 'Fill the RastPort');
      SetRast(Layer_Array[ktr]^.rp, ktr + 1);
    end;
    Inc(ktr);
  end;
  if not Create_Layer_Ok then
    DisposeLayers(MsgLayer, Layer_Array);

  AllocLayers := Create_Layer_Ok;
end;

// Set up to run the layers example, doLayers(). Clean up when done.
procedure StartLayers(TheLayerInfo: PLayer_Info; TheBitMap: PBitMap);
var
  MsgLayer: PLayer;
  TheSuperBitMap: PBitMap;
  TheLayers: array[0..2] of PLayer = (nil, nil, nil);
begin
  MsgLayer := CreateUpfrontLayer(TheLayerInfo, TheBitMap, M_L, M_T, M_R, M_B, LAYERSMART, nil);
  if Assigned(MsgLayer) then
  begin
    DoMessage(MsgLayer, 'Setting up Layers');
    TheSuperBitMap := AllocBitMap(SUPER_W, SUPER_H, SCREEN_D, BMF_CLEAR or BMF_DISPLAYABLE, nil);
    if Assigned(TheSuperBitMap) then
    begin
      if Boolean(AllocLayers(MsgLayer, TheLayers, TheSuperBitMap, TheLayerInfo, TheBitMap)) then
      begin
        DoLayers(MsgLayer, TheLayers);
        DisposeLayers(MsgLayer, TheLayers);
      end;
      FreeBitMap(TheSuperBitMap);
    end;
    if not Boolean(DeleteLayer(DUMMY, MsgLayer)) then
      Error(MsgLayer, 'Error deleting layer');
  end;
end;


{ Set up a low-level graphics display for layers to work on.  Layers
 should not be built directly on Intuition screens, use a low-level
 graphics view. If you need mouse or other events for the layers
 display, you have to get them directly from the input device. The
 only supported method of using layers library calls with Intuition
 (other than the InstallClipRegion() call) is through Intuition windows.

 See graphics primitives chapter for details on creating and using the
 low-level graphics calls.}
procedure RunNewView;
var
  TheView: TView;
  Oldview: PView;
  TheViewPort: TViewPort;
  TheRasInfo: TRasInfo;
  TheColorMap: PColorMap;
  TheLayerInfo: PLayer_Info;
  TheBitMap: PBitMap;
  ColorPalette: PWord;
  ktr: SmallInt;
begin
  //* save current view, to be restored when done */
  Oldview := PGfxBase(GfxBase)^.ActiView;
  if Assigned(Oldview) then
  begin
    //* get a LayerInfo structure */
    TheLayerInfo := NewLayerInfo;
    if Assigned(TheLayerInfo) then
    begin
      TheColorMap := GetColorMap(4);
      if Assigned(TheColorMap) then
      begin
        ColorPalette := PWord(TheColorMap^.ColorTable);
        for ktr := 0 to 3 do
        begin
          ColorPalette^ := colortable[ktr];
          Inc(ColorPalette);
        end;

        TheBitMap := AllocBitMap(SCREEN_W, SCREEN_H, SCREEN_D, BMF_CLEAR or BMF_DISPLAYABLE, nil);
        if Assigned(TheBitMap) then
        begin
          InitView(@TheView);
          InitVPort(@TheViewPort);

          TheView.ViewPort := @TheViewPort;

          TheViewPort.DWidth   := SCREEN_W;
          TheViewPort.DHeight  := SCREEN_H;
          TheViewPort.RasInfo  := @TheRasInfo;
          TheViewPort.ColorMap := TheColorMap;

          TheRasInfo.BitMap   := TheBitMap;
          TheRasInfo.RxOffset := 0;
          TheRasInfo.RyOffset := 0;
          TheRasInfo.Next     := nil;

          MakeVPort(@TheView, @TheViewPort);
          MrgCop(@TheView);
          LoadView(@TheView);
          WaitTOF;

          StartLayers(TheLayerInfo, TheBitMap);

          // put back the old view, wait for it to become active before freeing any of our display
          LoadView(Oldview);
          WaitTOF;

          // free dynamically created structures
          FreeVPortCopLists(@TheViewPort);
          FreeCprList(TheView.LOFCprList);

          FreeBitMap(TheBitMap);
        end;
        FreeColorMap(TheColorMap);  // free the color map
      end;
      DisposeLayerInfo(TheLayerInfo);
    end;
  end;
end;

begin
  RunNewView;
end.
