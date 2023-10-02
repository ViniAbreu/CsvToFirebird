unit Views.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.DApt;

type
  TViewMain = class(TForm)
    pnlBackground: TPanel;
    pnlHeader: TPanel;
    pgcMain: TPageControl;
    tsStructure: TTabSheet;
    tsSettings: TTabSheet;
    dbgrdFiles: TDBGrid;
    Label1: TLabel;
    edtCsvDir: TEdit;
    btnLoadCSV: TButton;
    btnConvert: TButton;
    OpenDialog: TOpenDialog;
    mtFiles: TFDMemTable;
    mtFilesFileName: TStringField;
    dsFiles: TDataSource;
    mtSchema: TFDMemTable;
    mtFilesFileID: TIntegerField;
    mtSchemaFileID: TIntegerField;
    mtSchemaFieldName: TStringField;
    dbgrdSchema: TDBGrid;
    mtSchemaFieldType: TStringField;
    mtSchemaFieldSize: TSmallintField;
    dsSchema: TDataSource;
    btnLoadStructure: TButton;
    tsLog: TTabSheet;
    mmoLog: TMemo;
    grpDatabase: TGroupBox;
    Label2: TLabel;
    edtDataBase: TEdit;
    Label3: TLabel;
    edtUser: TEdit;
    Label4: TLabel;
    edtPassword: TEdit;
    Label5: TLabel;
    edtHostname: TEdit;
    Label6: TLabel;
    edtPort: TEdit;
    btnTest: TButton;
    Label7: TLabel;
    edtDLLDirectory: TEdit;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    cbbSeparator: TComboBox;
    edtSeparator: TEdit;
    Connection: TFDConnection;
    btnLoadDB: TButton;
    btnLoadDLL: TButton;
    mtSchemaTableCreated: TStringField;
    qryConvert: TFDQuery;
    procedure btnLoadCSVClick(Sender: TObject);
    procedure btnLoadFDBClick(Sender: TObject);
    procedure btnLoadStructureClick(Sender: TObject);
    procedure cbbSeparatorChange(Sender: TObject);
    procedure btnLoadDBClick(Sender: TObject);
    procedure btnLoadDLLClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure dbgrdSchemaCellClick(Column: TColumn);
    procedure mtSchemaFieldTypeChange(Sender: TField);
    procedure btnConvertClick(Sender: TObject);
  private
    procedure LoadFiles;
    procedure LoadStructure;
    procedure CreateSchema;
    procedure ConvertData;

    function TestConnection: Boolean;
    function GetDirectory: string;
    function CreateInsertSQL: string;
    function IncArraySize(const AQuery: TFDQuery; AValue: Integer = 1): Integer;
  end;

var
  ViewMain: TViewMain;

implementation

uses FileCtrl, System.IOUtils, System.StrUtils, System.Generics.Collections;

{$R *.dfm}

procedure TViewMain.btnConvertClick(Sender: TObject);
begin
  pgcMain.ActivePage := tsLog;
  CreateSchema;
  ConvertData;
end;

procedure TViewMain.btnLoadCSVClick(Sender: TObject);
begin
  edtCsvDir.Text := GetDirectory;
  LoadFiles;
end;

procedure TViewMain.btnLoadDBClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    edtDataBase.Text := OpenDialog.FileName;
end;

procedure TViewMain.btnLoadDLLClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    edtDataBase.Text := OpenDialog.FileName;
end;

procedure TViewMain.btnLoadFDBClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    edtDataBase.Text := OpenDialog.FileName;
end;

procedure TViewMain.btnLoadStructureClick(Sender: TObject);
begin
  if mtFiles.IsEmpty then
  begin
    Application.MessageBox('Files not found!', 'CsvToFirebird - Information', MB_OK);
    Exit;
  end;
  LoadStructure;
end;

procedure TViewMain.btnTestClick(Sender: TObject);
begin
  if TestConnection then
    Application.MessageBox('Connection established successfully', 'CsvToFirebird - Information', MB_OK);
end;

procedure TViewMain.cbbSeparatorChange(Sender: TObject);
begin
  edtSeparator.Enabled := True;
  if cbbSeparator.ItemIndex <> 3 then
    edtSeparator.Enabled := False;
end;

procedure TViewMain.ConvertData;
var
  LCSVFile: TStringList;
  LColumnsFile: TArray<string>;
  LIndex, I, J: Integer;
begin
  if not TestConnection then
    Exit;

  while not mtFiles.Eof do
  begin
    LCSVFile := TStringList.Create;
    LCSVFile.LoadFromFile(Concat(edtCsvDir.Text, '\', mtFilesFileName.AsString), TEncoding.UTF8);
    try
      qryConvert.Close;
      qryConvert.Params.ArraySize := -1;
      qryConvert.SQL.Text := CreateInsertSQL;
      J := 0;

      for I := 1 to Pred(LCSVFile.Count) do
      begin
        LColumnsFile := LCSVFile.Strings[I].Split([',']);
        while not mtSchema.Eof do
        begin
          J := IncArraySize(qryConvert);
          LIndex := Pred(mtSchema.RecNo);

          qryConvert.ParamByName('id_cnv').AsIntegers[J] := Pred(I);

          if MatchStr(mtSchemaFieldType.AsString, ['CHAR', 'VARCHAR']) then
          begin
            qryConvert.ParamByName(mtSchemaFieldName.AsString).AsStrings[J] :=
              Copy(LColumnsFile[LIndex], 1, mtSchemaFieldSize.AsInteger);
          end;

          if MatchStr(mtSchemaFieldType.AsString, ['FLOAT', 'DOUBLE PRECISION']) then
            qryConvert.ParamByName(mtSchemaFieldName.AsString).AsFloats[J] := LColumnsFile[LIndex].ToDouble;

          if MatchStr(mtSchemaFieldType.AsString, ['SMALLINT', 'INTEGER']) then
            qryConvert.ParamByName(mtSchemaFieldName.AsString).AsIntegers[J] := LColumnsFile[LIndex].ToInteger;

          if mtSchemaFieldType.AsString.Equals('BIGINT') then
            qryConvert.ParamByName(mtSchemaFieldName.AsString).AsLargeInts[J] := LColumnsFile[LIndex].ToInt64;

          if mtSchemaFieldType.AsString.Equals('BOOLEAN') then
            qryConvert.ParamByName(mtSchemaFieldName.AsString).AsBooleans[J] := LColumnsFile[LIndex].ToBoolean;

          if MatchStr(mtSchemaFieldType.AsString, ['DATE', 'TIME']) then
            qryConvert.ParamByName(mtSchemaFieldName.AsString).AsDateTimes[J] := StrToDateTime(LColumnsFile[LIndex]);

          mtSchema.Next;
        end;
      end;

      Connection.StartTransaction;
      try
        qryConvert.Execute(J);
        Connection.Commit;
      except on Error: Exception do
        begin
          Connection.Rollback;
          mmoLog.Lines.Add(Format('[%s] - %s', [DateTimeToStr(Now), Error.Message]));
        end;
      end;

    finally
      LCSVFile.Free;
    end;
    mtFiles.Next;
  end;
end;

function TViewMain.CreateInsertSQL: string;
var
  LColumns, LValues: string;
begin
  Result := 'INSERT INTO (%s) VALUES (%s)';

  mtSchema.First;
  while not mtSchema.Eof do
  begin
    LColumns := LColumns + mtSchemaFieldName.AsString + ', ';
    LValues := LValues + ':' + mtSchemaFieldName.AsString + ', ';

    if mtSchema.RecNo = mtSchema.RecordCount then
    begin
      LColumns := LColumns.Replace(mtSchemaFieldName.AsString + ', ', mtSchemaFieldName.AsString);
      LValues := LValues.Replace(':' + mtSchemaFieldName.AsString + ', ', ':' + mtSchemaFieldName.AsString);
    end;
    mtSchema.Next;
  end;
  Result := Format(Result, [LColumns, LValues]);
  mtSchema.First;
end;

procedure TViewMain.CreateSchema;
var
  LSchemaTable: TStringBuilder;
  LFieldDDL, LTableName: string;
begin
  if not TestConnection then
    Exit;

  mtFiles.First;
  while not mtFiles.Eof do
  begin
    LSchemaTable := TStringBuilder.Create;

    try
      LTableName := mtFilesFileName.AsString.Replace('.csv', '');
      LSchemaTable.Append(Concat('CREATE TABLE ', LTableName , ' ('));
      LSchemaTable.Append('ID_CNV INTEGER PRIMARY KEY NOT NULL, ');

      while not mtSchema.Eof do
      begin
        LFieldDDL := Format('%s %s, ', [mtSchemaFieldName.AsString, mtSchemaFieldType.AsString]);

        if MatchStr(mtSchemaFieldType.AsString, ['CHAR', 'VARCHAR']) then
        begin
          LFieldDDL := Format('%s %s (%d), ',
            [mtSchemaFieldName.AsString, mtSchemaFieldType.AsString, mtSchemaFieldSize.AsInteger]);
        end;

        if mtSchema.RecNo = mtSchema.RecordCount then
          LFieldDDL := LFieldDDL.Replace(',', ');');

        LSchemaTable.Append(LFieldDDL);
        mtSchema.Next;
      end;

      Connection.StartTransaction;
      try
        Connection.ExecSQL(LSchemaTable.ToString);
        Connection.Commit;

        mtSchema.Edit;
        mtSchemaTableCreated.AsString := 'S';
        mtSchema.Post;

        mmoLog.Lines.Add(Format('[%s] - %s', [DateTimeToStr(Now), Concat(LTableName, ' Table created')]));
      except on Error: Exception do
        begin
          mtSchema.Edit;
          mtSchemaTableCreated.AsString := 'N';
          mtSchema.Post;

          Connection.Rollback;
          mmoLog.Lines.Add(Format('[%s] - %s', [DateTimeToStr(Now), Error.Message]));
        end;
      end;
    finally
      LSchemaTable.Free;
    end;
    mtFiles.Next;
  end;
end;

procedure TViewMain.dbgrdSchemaCellClick(Column: TColumn);
begin
  if Column.FieldName.Equals('FieldType') then
  begin
    Column.PickList.Clear;

    Column.PickList.Add('SMALLINT');
    Column.PickList.Add('INTEGER');
    Column.PickList.Add('BIGINT');
    Column.PickList.Add('BOOLEAN');
    Column.PickList.Add('FLOAT');
    Column.PickList.Add('DOUBLE PRECISION');
    Column.PickList.Add('DATE');
    Column.PickList.Add('TIME');
    Column.PickList.Add('CHAR');
    Column.PickList.Add('VARCHAR');
  end;
end;

function TViewMain.GetDirectory: string;
begin
  Result := EmptyStr;
  SelectDirectory('Selecione um diretório', 'C:\', Result);
end;

function TViewMain.IncArraySize(const AQuery: TFDQuery; AValue: Integer): Integer;
begin
  Result := AValue;
  Aquery.Params.ArraySize := AQuery.Params.ArraySize + AValue;
end;

procedure TViewMain.LoadFiles;
var
  LFileName: string;
  LCount: Integer;
begin
  if edtCsvDir.Text = '' then
    Exit;

  if not mtFiles.Active then
    mtFiles.Open;

  mtFiles.DisableControls;
  mtFiles.EmptyDataSet;

  LCount := 1;
  for LFileName in TDirectory.GetFiles(edtCsvDir.Text, '*.csv') do
  begin
    mtFiles.Append;
    mtFilesFileID.AsInteger := LCount;
    mtFilesFileName.AsString := ExtractFileName(LFileName);
    mtFiles.Post;

    Inc(LCount);
  end;

  mtFiles.First;
  mtFiles.EnableControls;
end;

procedure TViewMain.LoadStructure;
const
  RESERVED_WORDS: TArray<string> = ['LOCAL'];
var
  LCSVFile: TStringList;
  LFieldsUnique: TList<string>;
  LFields: TArray<string>;
  LCount, LFieldSize: Integer;
  LField, LColumn: string;
begin
  mtFiles.DisableControls;
  mtFiles.First;

  mtSchema.Open;

  mtSchema.DisableControls;
  mtSchema.EmptyDataSet;

  while not mtFiles.Eof do
  begin
    LCSVFile := TStringList.Create;
    LFieldsUnique := TList<string>.Create;
    LCount := 1;
    try
      LCSVFile.LoadFromFile(Concat(edtCsvDir.Text, '\', mtFilesFileName.AsString), TEncoding.UTF8);
      LFields := LCSVFile.Strings[0].Split([',']);

      LFieldSize := 255;
      if Length(LFields) >= 60 then
        LFieldSize := 100;

      for LField in LFields do
      begin
        LColumn := LField.ToUpper;
        while LFieldsUnique.Contains(LColumn) do
        begin
          LColumn := LColumn + '_' + LCount.ToString;
          Inc(LCount);
        end;

        LFieldsUnique.Add(LColumn);

        mtSchema.Append;
        mtSchemaFileID.AsInteger := mtFilesFileID.AsInteger;

        if MatchStr(LField.ToUpper, RESERVED_WORDS) then
          LColumn := LColumn + '_rsvrd_word';

        mtSchemaFieldName.AsString := LColumn;
        mtSchemaFieldType.AsString := 'VARCHAR';
        mtSchemaFieldSize.AsInteger := LFieldSize;
        mtSchema.Post;
      end;
    finally
      LFieldsUnique.Free;
      LCSVFile.Free;
    end;

    mtFiles.Next;
  end;

  mtFiles.First;
  mtSchema.EnableControls;
  mtFiles.EnableControls;
end;

procedure TViewMain.mtSchemaFieldTypeChange(Sender: TField);
begin
  mtSchemaFieldSize.AsInteger := 0;
  if MatchStr(Sender.AsString, ['CHAR', 'VARCHAR']) then
    mtSchemaFieldSize.AsInteger := 255;
end;

function TViewMain.TestConnection: Boolean;
begin
  Result := False;
  try
    Connection.Params.Database := edtDataBase.Text;
    Connection.Params.UserName := edtUser.Text;
    Connection.Params.Password := edtPassword.Text;
    Connection.Params.Add('Server=' + edtHostname.Text);
    Connection.Params.Add('Port=' + edtPort.Text);

    Connection.Connected := True;
    if Connection.Connected then
    begin
      mmoLog.Lines.Add(Format('[%s] - %s', [DateTimeToStr(Now),'Connection established successfully']));
      Result := True;
    end;
  except on Error: Exception do
    begin
      mmoLog.Lines.Add(Format('[%s] - %s', [DateTimeToStr(Now), Error.Message]));
    end;
  end;
end;

end.
