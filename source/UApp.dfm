object FrmGen: TFrmGen
  Left = 217
  Top = 94
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Running Apps'
  ClientHeight = 323
  ClientWidth = 285
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 285
    Height = 323
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object BtnGen: TButton
      Left = 21
      Top = 10
      Width = 115
      Height = 33
      Caption = 'Generate'
      TabOrder = 0
      OnClick = BtnGenClick
    end
    object BtnFinish: TButton
      Left = 150
      Top = 10
      Width = 110
      Height = 33
      Caption = 'End Task'
      TabOrder = 1
      OnClick = BtnFinishClick
    end
  end
  object ListV: TListBox
    Left = 13
    Top = 52
    Width = 262
    Height = 262
    ItemHeight = 17
    PopupMenu = Menu
    TabOrder = 1
  end
  object Menu: TPopupMenu
    Left = 128
    Top = 8
    object BtnEnd: TMenuItem
      Caption = 'EndTask'
      OnClick = BtnFinishClick
    end
  end
end
