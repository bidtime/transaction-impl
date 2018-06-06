unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ToolWin,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    ToolBar1: TToolBar;
    Button1: TButton;
    StatusBar1: TStatusBar;
    MemoFiles: TMemo;
    Splitter1: TSplitter;
    memoTarget: TMemo;
    ToolButton1: TToolButton;
    Edit2: TEdit;
    Splitter2: TSplitter;
    MemoSrc: TMemo;
    cbxRmTrans: TCheckBox;
    cbxAddTrans: TCheckBox;
    cbxWriteFile: TCheckBox;
    ToolButton2: TToolButton;
    procedure Button1Click(Sender: TObject);
  private
    FCounts: integer;
    { Private declarations }
    procedure deleteCounts();
    procedure insertCounts();
    procedure setStatue(const S: string);
    procedure setStatueN(const S: string; const n: integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Masks;

{$R *.dfm}

// 遍历目录及子目录

procedure GetFileListEx(FilePath, ExtMask: string; FileList: TStrings;
  SubDirectory: Boolean = True);

  function Match(FileName: string; MaskList: TStrings): Boolean;
  var
    i: integer;
  begin
    Result := False;
    for i := 0 to MaskList.Count - 1 do
    begin
      if MatchesMask(FileName, MaskList[i]) then
      begin
        Result := True;
        break;
      end;
    end;
  end;

var
  FileRec: TSearchRec;
  MaskList: TStringList;
begin
  if DirectoryExists(FilePath) then
  begin
    if FilePath[Length(FilePath)] <> '\' then
      FilePath := FilePath + '\';
    if FindFirst(FilePath + '*.*', faAnyFile, FileRec) = 0 then
    begin
      MaskList := TStringList.Create;
      try
        ExtractStrings([';'], [], PChar(ExtMask), MaskList);
        FileList.BeginUpdate;
        repeat
          if ((FileRec.Attr and faDirectory) <> 0) and SubDirectory then begin
            if (FileRec.Name <> '.') and (FileRec.Name <> '..') then
              GetFileListEx(FilePath + FileRec.Name + '\', ExtMask, FileList);
          end else begin
            if Match(FilePath + FileRec.Name, MaskList) then begin
              FileList.Add( FilePath + FileRec.Name);
            end;
          end;
        until FindNext(FileRec) <> 0;
        FileList.EndUpdate;
      finally
        MaskList.Free;
      end;
    end;
    FindClose(FileRec);
  end;
end;

function getFileTree(const filepath:string):TStringlist;
var
  sr:TSearchrec;
begin
   result:=TStringlist.Create;
   if Findfirst(filepath+'\*',faanyfile,sr)=0 then
   begin
     repeat
        if (sr.Name = '.') or (sr.Name='..') then continue;
        if sr.Attr = fadirectory then begin
          result.Add(sr.Name);
          result.AddStrings(getFileTree(filepath+'\'+sr.Name)) ;
        end else begin
          result.Add(sr.Name);
        end;
     until findnext(sr) <>0;
     findclose(sr);
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);

  procedure readFile(const S: string; strs: TStrings);
  begin
    strs.LoadFromFile(S, TEncoding.UTF8);
  end;

  procedure testWriteFile(const S: string; strs: TStrings);
  begin
    if cbxWriteFile.Checked then begin
      strs.SaveToFile(S, TEncoding.UTF8);
    end;
  end;

  procedure getFiles();
  begin
    self.MemoFiles.Clear;
    self.MemoSrc.Clear;
    self.memoTarget.Clear;
    GetFileListEx(self.Edit1.Text, self.Edit2.Text, self.MemoFiles.Lines, true);
  end;

  procedure doIt(const strs: TStrings);

    const IMPORT_TRANS = 'import org.springframework.transaction.annotation.Transactional;';
    const TRANS_WRITE = '@Transactional(rollbackFor = Exception.class)';
    CONST TRANS_READ = '@Transactional(readOnly = true)';

    procedure removeTrans(const fName: string; strsSrc, strsDest: TStrings);
    var S: string;
      I: integer;
    begin
      strsSrc.Clear;
      strsDest.Clear;
      //
      readFile(fName, strsSrc);
      for I := 0 to strsSrc.Count - 1 do begin
        S := strsSrc[I];
        if S.IndexOf(IMPORT_TRANS)>=0 then begin
          continue;
        end else if (S.indexOf('@Transactional')>=0) then begin
          continue;
        end else begin
          strsDest.Add(S);
          //incCounts();
        end;
      end;
      //
      testWriteFile(fName, strsDest);
    end;

    procedure addTrans(const fName: string; strsSrc, strsDest: TStrings);

      function getMethodName(const strFunc: string): string;
      var i, j: integer;
      begin
        j := strFunc.LastIndexOf('(');
        i := strFunc.LastIndexOf(' ', j);
        Result := strFunc.Substring(i, j);
      end;

      function getTransV(const strFunc: string): string;
      var s: string;
      begin
        s := getMethodName(strFunc);
        if (s.IndexOf('insert')>=0) or (s.IndexOf('del')>=0)
          or (s.IndexOf('update')>=0) then begin
          Result := TRANS_WRITE;
        end else begin
          Result := TRANS_READ;
        end;
      end;

      function getSpace(const rawLen, trimLen: integer): string;
      var I: integer;
      begin
        Result := '';
        for I := 0 to rawLen - trimLen - 1 do begin
          Result := Result + ' ';
        end;
      end;

    var S, strTmp: string;
      I, lastImportIdx: integer;
      addImportT, addMethodT: boolean;
      method: boolean;
    begin
      strsSrc.Clear;
      strsDest.Clear;
      addImportT := false;
      addMethodT := false;
      method := false;
      lastImportIdx := 0;
      //
      readFile(fName, strsSrc);
      for I := 0 to strsSrc.Count - 1 do begin
        S := strsSrc[I];
        strTmp := s.Trim;
        if S.IndexOf('import')>=0 then begin
          if S.IndexOf(IMPORT_TRANS)>=0 then begin
            addImportT := true;
          end;
          lastImportIdx := I;
        end else if S.IndexOf('public class')>=0 then begin
          if not addImportT then begin
            strsDest.Insert(lastImportIdx+1, IMPORT_TRANS);
          end;
          method := true;
        end else if (method) then begin

          if strTmp.StartsWith('@Transactional') then begin
            addMethodT := true;
          end;

          if S.Trim.StartsWith('public ') then begin
            if not addMethodT then begin
              strsDest.Add(getSpace(S.Length, strTmp.Length) + getTransV(strTmp));
            end;
            addMethodT := false;
          end;

        end;
        strsDest.Add(S);
        //incCounts();
      end;
      //
      testWriteFile(fName, strsDest);
    end;

  var I: integer;
    javaFile: string;
  begin
    for I := 0 to strs.Count - 1 do begin
      javaFile := strs[I];
      if (self.cbxRmTrans.Checked) then begin
        removeTrans(javaFile, self.MemoSrc.Lines, self.memoTarget.Lines);
      end else if self.cbxAddTrans.Checked then begin
        addTrans(javaFile, self.MemoSrc.Lines, self.memoTarget.Lines);
      end;
    end;
  end;

begin
  FCounts := 0;
  getFiles();
  doIt(self.MemoFiles.Lines);
end;

procedure TForm1.insertCounts;
begin
  Inc(FCounts);
  setStatue('search: ' + IntToStr(FCounts));
end;

procedure TForm1.deleteCounts;
begin
  Inc(FCounts);
  setStatue('search: ' + IntToStr(FCounts));
end;

procedure TForm1.setStatue(const S: string);
begin
  self.StatusBar1.Panels[0].Text := S;
  Application.ProcessMessages;
end;

procedure TForm1.setStatueN(const S: string; const n: integer);
begin
  self.StatusBar1.Panels[n].Text := S;
  Application.ProcessMessages;
end;

end.
