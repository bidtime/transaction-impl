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
  object Splitter1: TSplitter
    Left = 377
    Top = 29
    Width = 4
    Height = 740
    ExplicitLeft = 373
    ExplicitTop = 8
    ExplicitHeight = 621
  end
  object Splitter2: TSplitter
    Left = 758
    Top = 29
    Width = 4
    Height = 740
    ExplicitLeft = 385
    ExplicitTop = 37
    ExplicitHeight = 621
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
      Width = 801
      Height = 21
      TabOrder = 0
      Text = 'C:\tools\working\svn\yuntong\dev\ecarpo-bms\ecarpo-bms-server'
    end
    object Edit2: TEdit
      Left = 801
      Top = 0
      Width = 103
      Height = 21
      TabOrder = 2
      Text = '*Manager.java'
    end
    object ToolButton1: TToolButton
      Left = 904
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object Button1: TButton
      Left = 912
      Top = 0
      Width = 75
      Height = 21
      Caption = 'go'
      TabOrder = 1
      OnClick = Button1Click
    end
    object cbxAddTrans: TCheckBox
      Left = 987
      Top = 0
      Width = 53
      Height = 21
      Caption = 'AddT'
      TabOrder = 4
    end
    object cbxRmTrans: TCheckBox
      Left = 1040
      Top = 0
      Width = 48
      Height = 21
      Caption = 'delT'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object ToolButton2: TToolButton
      Left = 1088
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object cbxWriteFile: TCheckBox
      Left = 1096
      Top = 0
      Width = 56
      Height = 21
      Caption = 'write'
      TabOrder = 5
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 769
    Width = 1345
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 200
      end>
  end
  object MemoFiles: TMemo
    Left = 0
    Top = 29
    Width = 377
    Height = 740
    Align = alLeft
    Lines.Strings = (
      'MemoFiles')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object memoTarget: TMemo
    Left = 762
    Top = 29
    Width = 583
    Height = 740
    Align = alClient
    Lines.Strings = (
      'MemoTarget')
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object MemoSrc: TMemo
    Left = 381
    Top = 29
    Width = 377
    Height = 740
    Align = alLeft
    Lines.Strings = (
      'MemoSrc')
    ScrollBars = ssBoth
    TabOrder = 4
  end
end
