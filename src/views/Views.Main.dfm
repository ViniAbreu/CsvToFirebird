object ViewMain: TViewMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '..:: Csv2Firebird ::..'
  ClientHeight = 673
  ClientWidth = 833
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Reference Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 16
  object pnlBackground: TPanel
    Left = 0
    Top = 0
    Width = 833
    Height = 673
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 829
    ExplicitHeight = 672
    object pnlHeader: TPanel
      Left = 0
      Top = 0
      Width = 833
      Height = 38
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 829
      ExplicitHeight = 37
      object Label1: TLabel
        Left = 7
        Top = 11
        Width = 68
        Height = 16
        Caption = 'CSV Folder'
      end
      object edtCsvDir: TEdit
        Left = 81
        Top = 8
        Width = 344
        Height = 24
        TabOrder = 0
      end
      object btnLoadCSV: TButton
        Left = 431
        Top = 7
        Width = 25
        Height = 25
        Caption = '...'
        TabOrder = 1
        StyleName = 'Windows'
        OnClick = btnLoadCSVClick
      end
      object btnConvert: TButton
        AlignWithMargins = True
        Left = 703
        Top = 3
        Width = 127
        Height = 32
        Align = alRight
        Caption = 'Convert'
        TabOrder = 2
        OnClick = btnConvertClick
        ExplicitLeft = 699
        ExplicitHeight = 31
      end
      object btnLoadStructure: TButton
        AlignWithMargins = True
        Left = 579
        Top = 3
        Width = 118
        Height = 32
        Align = alRight
        Caption = 'Load Structure'
        TabOrder = 3
        OnClick = btnLoadStructureClick
        ExplicitLeft = 575
        ExplicitHeight = 31
      end
    end
    object pgcMain: TPageControl
      Left = 0
      Top = 38
      Width = 833
      Height = 635
      ActivePage = tsStructure
      Align = alBottom
      TabOrder = 1
      ExplicitTop = 37
      ExplicitWidth = 829
      object tsStructure: TTabSheet
        Caption = 'Structure'
        object dbgrdFiles: TDBGrid
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 340
          Height = 598
          Align = alLeft
          DataSource = dsFiles
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'MS Reference Sans Serif'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'FileID'
              Title.Alignment = taCenter
              Title.Caption = 'ID'
              Width = 48
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FileName'
              Title.Alignment = taCenter
              Width = 250
              Visible = True
            end>
        end
        object dbgrdSchema: TDBGrid
          AlignWithMargins = True
          Left = 349
          Top = 3
          Width = 473
          Height = 598
          Align = alClient
          DataSource = dsSchema
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'MS Reference Sans Serif'
          TitleFont.Style = []
          OnCellClick = dbgrdSchemaCellClick
          Columns = <
            item
              Expanded = False
              FieldName = 'FileID'
              Title.Alignment = taCenter
              Title.Caption = 'File'
              Width = 48
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FieldName'
              Title.Alignment = taCenter
              Width = 210
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'FieldType'
              Title.Alignment = taCenter
              Title.Caption = 'Type'
              Width = 102
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'FieldSize'
              Title.Alignment = taCenter
              Title.Caption = 'Size'
              Width = 75
              Visible = True
            end>
        end
      end
      object tsSettings: TTabSheet
        Caption = 'Settings'
        ImageIndex = 1
        object grpDatabase: TGroupBox
          Left = 0
          Top = 0
          Width = 825
          Height = 129
          Align = alTop
          Caption = ' DataBase '
          TabOrder = 0
          object Label2: TLabel
            Left = 11
            Top = 32
            Width = 61
            Height = 16
            Caption = 'Database'
          end
          object Label3: TLabel
            Left = 327
            Top = 92
            Width = 29
            Height = 16
            Caption = 'User'
          end
          object Label4: TLabel
            Left = 497
            Top = 92
            Width = 62
            Height = 16
            Caption = 'Password'
          end
          object Label5: TLabel
            Left = 56
            Top = 92
            Width = 29
            Height = 16
            Caption = 'Host'
          end
          object Label6: TLabel
            Left = 223
            Top = 92
            Width = 26
            Height = 16
            Caption = 'Port'
          end
          object Label7: TLabel
            Left = 11
            Top = 62
            Width = 74
            Height = 16
            Caption = 'Firebird DLL'
          end
          object edtDataBase: TEdit
            Left = 91
            Top = 29
            Width = 687
            Height = 24
            TabOrder = 0
          end
          object edtUser: TEdit
            Left = 362
            Top = 89
            Width = 121
            Height = 24
            TabOrder = 1
            Text = 'SYSDBA'
          end
          object edtPassword: TEdit
            Left = 565
            Top = 89
            Width = 121
            Height = 24
            TabOrder = 2
            Text = 'masterkey'
          end
          object edtHostname: TEdit
            Left = 91
            Top = 89
            Width = 121
            Height = 24
            TabOrder = 3
            Text = '127.0.0.1'
          end
          object edtPort: TEdit
            Left = 255
            Top = 89
            Width = 58
            Height = 24
            TabOrder = 4
            Text = '3050'
          end
          object btnTest: TButton
            Left = 734
            Top = 89
            Width = 75
            Height = 25
            Caption = 'Test'
            TabOrder = 5
            OnClick = btnTestClick
          end
          object edtDLLDirectory: TEdit
            Left = 91
            Top = 59
            Width = 687
            Height = 24
            TabOrder = 6
          end
          object btnLoadDB: TButton
            Left = 784
            Top = 27
            Width = 25
            Height = 25
            Caption = '...'
            TabOrder = 7
            OnClick = btnLoadDBClick
          end
          object btnLoadDLL: TButton
            Left = 784
            Top = 58
            Width = 25
            Height = 25
            Caption = '...'
            TabOrder = 8
            OnClick = btnLoadDLLClick
          end
        end
        object GroupBox1: TGroupBox
          Left = 0
          Top = 129
          Width = 825
          Height = 72
          Align = alTop
          Caption = ' CSV File '
          TabOrder = 1
          object Label8: TLabel
            Left = 11
            Top = 32
            Width = 63
            Height = 16
            Caption = 'Separator'
          end
          object cbbSeparator: TComboBox
            Left = 91
            Top = 29
            Width = 78
            Height = 24
            Style = csDropDownList
            ItemIndex = 3
            TabOrder = 0
            Text = 'Custom'
            OnChange = cbbSeparatorChange
            Items.Strings = (
              ','
              ';'
              '.'
              'Custom')
          end
          object edtSeparator: TEdit
            Left = 183
            Top = 29
            Width = 29
            Height = 24
            TabOrder = 1
            Text = ','
          end
        end
      end
      object tsLog: TTabSheet
        Caption = 'Log'
        ImageIndex = 2
        object mmoLog: TMemo
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 819
          Height = 598
          Align = alClient
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
  object OpenDialog: TOpenDialog
    Left = 544
    Top = 8
  end
  object mtFiles: TFDMemTable
    MasterFields = 'FileID'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 160
    Top = 176
    object mtFilesFileID: TIntegerField
      FieldName = 'FileID'
    end
    object mtFilesFileName: TStringField
      FieldName = 'FileName'
      Size = 250
    end
  end
  object dsFiles: TDataSource
    DataSet = mtFiles
    Left = 160
    Top = 240
  end
  object mtSchema: TFDMemTable
    IndexFieldNames = 'FileID'
    MasterSource = dsFiles
    MasterFields = 'FileID'
    DetailFields = 'FileID'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 504
    Top = 184
    object mtSchemaFileID: TIntegerField
      FieldName = 'FileID'
    end
    object mtSchemaFieldName: TStringField
      FieldName = 'FieldName'
      Size = 255
    end
    object mtSchemaFieldType: TStringField
      FieldName = 'FieldType'
      OnChange = mtSchemaFieldTypeChange
      Size = 30
    end
    object mtSchemaFieldSize: TSmallintField
      FieldName = 'FieldSize'
    end
    object mtSchemaTableCreated: TStringField
      FieldName = 'TableCreated'
      Size = 1
    end
  end
  object dsSchema: TDataSource
    DataSet = mtSchema
    Left = 504
    Top = 240
  end
  object Connection: TFDConnection
    Params.Strings = (
      'OpenMode=OpenOrCreate'
      'CharacterSet=UTF8'
      'DriverID=FB'
      'User_Name=sysdba'
      'Password=masterkey')
    LoginPrompt = False
    Left = 680
    Top = 216
  end
  object qryConvert: TFDQuery
    Connection = Connection
    Left = 680
    Top = 280
  end
end
