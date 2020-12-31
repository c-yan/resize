program RESIZE;

uses
  Windows,
  SysUtils,
  Vcl.Graphics,
  Jpeg,
  stretchf in 'stretchf.pas';

procedure TestProc(Progress: Integer);
begin
  WriteLn(Progress);
end;

var
  Src: TBitmap;
  SrcName, DstName: TFileName;
  Width, Height, Quality: Integer;
  JpegImage: TJpegImage;
begin
  SrcName := ParamStr(1);
  if not FileExists(SrcName) then Exit;

  DstName := ParamStr(2);
  Width := StrToInt(ParamStr(3));
  Height := StrToInt(ParamStr(4));
  Quality := StrToIntDef(ParamStr(5), 80);

  Src := TBitmap.Create;
  try
    if AnsiLowerCase(ExtractFileExt(SrcName)) = '.jpg' then
    begin
      JpegImage := TJpegImage.Create;
      try
        JpegImage.LoadFromFile(SrcName);
        Src.Assign(JpegImage);
      finally
        JpegImage.Free;
      end;
    end
    else Src.LoadFromFile(SrcName);

    stretchf.Stretch(Src, Width, Height, nil);
    //stretchf.Stretch(Src, Width, Height, TestProc);

    if AnsiLowerCase(ExtractFileExt(DstName)) = '.jpg' then
    begin
      JpegImage := TJpegImage.Create;
      try
        JpegImage.Assign(Src);
        JpegImage.ProgressiveEncoding := True;
        JpegImage.CompressionQuality := Quality;
        JpegImage.SaveToFile(DstName);
      finally
        JpegImage.Free;
      end;
    end
    else Src.SaveToFile(DstName);
  finally
    Src.Free;
  end;
end.
