program RESIZE;

uses
  Windows,
  SysUtils,
  Vcl.Graphics,
  Jpeg,
  ActiveX,
  stretchf in 'stretchf.pas';

var
  Src: TBitmap;
  SrcName, DstName: TFileName;
  Width, Height, Quality: Integer;
  JpegImage: TJpegImage;
  WICImage: TWICImage;
begin
  CoInitialize(nil);
  try
    SrcName := ParamStr(1);
    if not FileExists(SrcName) then Exit;

    DstName := ParamStr(2);
    Width := StrToInt(ParamStr(3));
    Height := StrToInt(ParamStr(4));
    Quality := StrToIntDef(ParamStr(5), 80);

    Src := TBitmap.Create;
    try
      if AnsiLowerCase(ExtractFileExt(SrcName)) <> '.bmp' then
      begin
        WICImage := TWICImage.Create;
        try
          WICImage.LoadFromFile(SrcName);
          Src.Assign(WICImage);
        finally
          WICImage.Free;
        end;
      end
      else Src.LoadFromFile(SrcName);

      stretchf.Stretch(Src, Width, Height, nil);

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
  finally
    CoUninitialize;
  end;
end.
