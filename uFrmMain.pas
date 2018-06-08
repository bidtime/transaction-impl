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
    Splitter2: TSplitter;
    MemoSrc: TMemo;
    cbxRmTrans: TCheckBox;
    cbxAddTrans: TCheckBox;
    cbxWriteFile: TCheckBox;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ComboBox1: TComboBox;
    Panel1: TPanel;
    Splitter3: TSplitter;
    memoResult: TMemo;
    Button2: TButton;
    ToolButton4: TToolButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    FChanged, FSearched: integer;
    { Private declarations }
    procedure insertCounts(const applies: integer);
    procedure setStatue(const S: string);
    procedure setStatueN(const S: string; const n: integer);
    procedure testWriteFile(const S: string; strs: TStrings;
      const applies: integer);
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

procedure TForm1.testWriteFile(const S: string; strs: TStrings; const applies: integer);
begin
  insertCounts(applies);
  if (applies <> 0) then begin
    self.memoResult.lines.add(S);
  end;
  //
  if (cbxWriteFile.Checked) then begin
    strs.SaveToFile(S, TEncoding.UTF8);
  end;
end;

  procedure readItFile(const S: string; strs: TStrings);
  begin
    strs.LoadFromFile(S, TEncoding.UTF8);
  end;

procedure TForm1.Button1Click(Sender: TObject);

  procedure doIt(const strs: TStrings);

    const IMPORT_TRANS = 'import org.springframework.transaction.annotation.Transactional;';
    const TRANS_WRITE = '@Transactional(rollbackFor = Exception.class)';
    CONST TRANS_READ = '@Transactional(readOnly = true)';

    procedure removeTrans(const fName: string; strsSrc, strsDest: TStrings);
    var S: string;
      I, changes, imports, totals: integer;
    begin
      strsSrc.Clear;
      strsDest.Clear;
      changes := 0;
      imports := 0;
      //
      readItFile(fName, strsSrc);
      for I := 0 to strsSrc.Count - 1 do begin
        S := strsSrc[I];
        if S.IndexOf(IMPORT_TRANS)>=0 then begin
          Inc(imports);
          continue;
        end else if (S.indexOf('@Transactional')>=0) then begin
          if S.IndexOf('Propagation.NESTED')>=0 then begin
            continue;
          end;
          Inc(changes);
          continue;
        end else begin
          strsDest.Add(S);
        end;
      end;
      //
      if changes>0 then begin
        totals := changes + imports;
      end else begin
        totals := changes;      
      end;
      testWriteFile(fName, strsDest, totals);
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
      I, lastImportIdx, changes: integer;
      addImportT, addMethodT: boolean;
      method: boolean;
    begin
      strsSrc.Clear;
      strsDest.Clear;
      addImportT := false;
      addMethodT := false;
      method := false;
      lastImportIdx := 0;
      changes := 0;
      //
      readItFile(fName, strsSrc);
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

          if (strTmp.StartsWith('public ')) and (not strTmp.Contains('callback'))
             and (not strTmp.Contains(';')) then begin
            if not addMethodT then begin
              strsDest.Add(getSpace(S.Length, strTmp.Length) + getTransV(strTmp));
              Inc(changes);
            end;
            addMethodT := false;
          end;

        end;
        strsDest.Add(S);
      end;
      //
      testWriteFile(fName, strsDest, changes);
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

  procedure clear();
  begin
    self.MemoSrc.Clear;
    self.memoTarget.Clear;
    self.memoResult.Clear;
  end;

begin
  FChanged := 0;
  FSearched := 0;
  clear();
  doIt(self.MemoFiles.Lines);
end;

procedure TForm1.Button2Click(Sender: TObject);

  procedure getFiles();
  begin
    self.MemoFiles.Clear;
    self.MemoSrc.Clear;
    self.memoTarget.Clear;
    self.memoResult.Clear;
    GetFileListEx(self.Edit1.Text, self.combobox1.Text, self.MemoFiles.Lines, true);
  end;

begin
  getFiles();
end;

procedure TForm1.Button3Click(Sender: TObject);

    const IMPORT_NOTNULL = 'import javax.validation.constraints.NotNull;';
    const NOTNULL = '@NotNull';

    const IMPORT_NOTEMPTY = 'import org.hibernate.validator.constraints.NotEmpty;';
    const NOTEMPTY = '@NotEmpty';

    procedure replaceNotBlank(const fName: string; strsSrc_, strsDest_: TStrings);

      function doStrs(strsDst: TStrings): integer;
      var i, incNotEmpty, decNotEmpty: integer;
        incNotNull, decNotNull: integer;
        S, strTmp: string;
        hit: boolean;
      begin
        Result := 0;
        incNotEmpty := 0;
        decNotEmpty := 0;
        hit := false;
        for I := strsDst.Count - 1 downto 0 do begin
          S := strsDst[I];
          strTmp := S.Trim;
          if strTmp.IsEmpty then begin
            hit := false;
          end else begin
            //
            if (strTmp.StartsWith('private String '))
                or (strTmp.StartsWith('protected String '))
                 or (strTmp.StartsWith('String ')) then begin
              hit := true;
            end else begin
              if hit then begin
                if (strTmp.StartsWith(NOTNULL)) then begin
                  strsDst[I] := S.Replace(NOTNULL, NOTEMPTY);
                  Dec(decNotNull);
                end;
              end else begin
                if (strTmp.StartsWith(NOTNULL)) then begin
                  Inc(incNotNull);
                end else if (strTmp.StartsWith(NOTEMPTY)) then begin
                  Inc(incNotEmpty);
                end;
              end;
            end;
          end;
        end;
        Result := incNotNull - decNotNull; 
      end;

      function getSpace(const rawLen, trimLen: integer): string;
      var I: integer;
      begin
        Result := '';
        for I := 0 to rawLen - trimLen - 1 do begin
          Result := Result + ' ';
        end;
      end;

    var 
      changes: integer;
    begin
      strsSrc_.Clear;
      strsDest_.Clear;
      readItFile(fName, strsSrc_);
      strsDest_.AddStrings(strsSrc_);
      changes := doStrs(strsDest_);
      //
      testWriteFile(fName, strsDest_, changes);
    end;

  procedure doIt(const strs: TStrings);
  var I: integer;
    javaFile: string;
  begin
    for I := 0 to strs.Count - 1 do begin
      javaFile := strs[I];
      replaceNotBlank(javaFile, self.MemoSrc.Lines, self.memoTarget.Lines);
      break;
    end;
  end;

  procedure clear();
  begin
    self.MemoSrc.Clear;
    self.memoTarget.Clear;
    self.memoResult.Clear;
  end;

begin
  FChanged := 0;
  FSearched := 0;
  clear();
  doIt(self.MemoFiles.Lines);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var S: string;
begin
  if Sender is TComboBox then begin
    S := TComboBox(Sender).Text;
    if S = '*Impl.java' then begin
      cbxAddTrans.checked := true;
      cbxRmTrans.checked := false;
    end else if S = '*Manager.java' then begin
      cbxAddTrans.checked := false;
      cbxRmTrans.checked := true;
    end;
  end;
end;

procedure TForm1.insertCounts(const applies: integer);
begin
  if applies > 0 then begin
    Inc(FChanged);
  end;
  Inc(FSearched);
  setStatue('search: ' + IntToStr(FSearched) + '/' + IntToStr(MemoFiles.Lines.count)
    + ', ' + 'changed: ' + IntToStr(FChanged) + ' classes.'
  );
end;

procedure TForm1.setStatue(const S: string);
begin
  setStatueN(S, 0);
end;

procedure TForm1.setStatueN(const S: string; const n: integer);
begin
  self.StatusBar1.Panels[n].Text := S;
  Application.ProcessMessages;
end;

end.
