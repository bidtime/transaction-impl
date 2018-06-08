object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #20027#31383#21475
  ClientHeight = 788
  ClientWidth = 1345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter3: TSplitter
    Left = 0
    Top = 652
    Width = 1345
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 590
    ExplicitWidth = 179
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 1345
    Height = 29
    ButtonHeight = 21
    Caption = 'ToolBar1'
    TabOrder = 0
    object Edit1: TEdit
      Left = 0
      Top = 0
      Width = 377
      Height = 21
      TabOrder = 0
      Text = 
        'C:\tools\working\svn\yuntong\dev\ecarpo-bms\ecarpo-bms-server\ec' +
        'arpo-bms-fl-server\ecarpo-bms-fl-server-api\src\main\java\com\ec' +
        'arpo\bms\fl\server\salebizvch\dto\'
    end
    object ToolButton3: TToolButton
      Left = 377
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object ComboBox1: TComboBox
      Left = 385
      Top = 0
      Width = 145
      Height = 21
      TabOrder = 5
      Text = '*DTO.java'
      OnChange = ComboBox1Change
      Items.Strings = (
        '*Impl.java'
        '*Manager.java'
        '*DTO.java')
    end
    object ToolButton1: TToolButton
      Left = 530
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object Button2: TButton
      Left = 538
      Top = 0
      Width = 75
      Height = 21
      Caption = 'files'
      TabOrder = 6
      OnClick = Button2Click
    end
    object ToolButton4: TToolButton
      Left = 613
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object Button1: TButton
      Left = 621
      Top = 0
      Width = 75
      Height = 21
      Caption = 'go'
      TabOrder = 1
      OnClick = Button1Click
    end
    object cbxAddTrans: TCheckBox
      Left = 696
      Top = 0
      Width = 53
      Height = 21
      Caption = 'AddT'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object cbxRmTrans: TCheckBox
      Left = 749
      Top = 0
      Width = 48
      Height = 21
      Caption = 'delT'
      TabOrder = 2
    end
    object ToolButton2: TToolButton
      Left = 797
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object cbxWriteFile: TCheckBox
      Left = 805
      Top = 0
      Width = 56
      Height = 21
      Caption = 'write'
      TabOrder = 4
    end
    object Button3: TButton
      Left = 861
      Top = 0
      Width = 75
      Height = 21
      Caption = 'go'
      TabOrder = 7
      OnClick = Button3Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 771
    Width = 1345
    Height = 17
    Panels = <
      item
        Width = 200
      end
      item
        Width = 200
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 29
    Width = 1345
    Height = 623
    Align = alClient
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 378
      Top = 1
      Width = 4
      Height = 621
      ExplicitLeft = 374
      ExplicitTop = -7
      ExplicitHeight = 559
    end
    object Splitter2: TSplitter
      Left = 759
      Top = 1
      Width = 4
      Height = 621
      ExplicitLeft = 409
      ExplicitTop = -7
      ExplicitHeight = 559
    end
    object MemoFiles: TMemo
      Left = 1
      Top = 1
      Width = 377
      Height = 621
      Align = alLeft
      Lines.Strings = (
        
          'C:\tools\working\svn\yuntong\dev\ecarpo-bms\ecarpo-bms-server\ec' +
          'arpo-bms-fl-server\ecarpo-bms-fl-server-api\src\main\java\com\ec' +
          'arpo\bms\fl\server\salebizvch\dto\InsertAndUpdateFlSaleVchDTO.ja' +
          'va')
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object MemoSrc: TMemo
      Left = 382
      Top = 1
      Width = 377
      Height = 621
      Align = alLeft
      Lines.Strings = (
        'MemoSrc')
      ScrollBars = ssBoth
      TabOrder = 1
    end
    object memoTarget: TMemo
      Left = 763
      Top = 1
      Width = 581
      Height = 621
      Align = alClient
      Lines.Strings = (
        'MemoTarget')
      ScrollBars = ssBoth
      TabOrder = 2
    end
  end
  object memoResult: TMemo
    Left = 0
    Top = 655
    Width = 1345
    Height = 116
    Align = alBottom
    Lines.Strings = (
      'MemoResult')
    ScrollBars = ssBoth
    TabOrder = 3
  end
end
