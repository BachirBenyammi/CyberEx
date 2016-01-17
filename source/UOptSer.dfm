object Options: TOptions
  Left = 192
  Top = 107
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 105
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 257
    Height = 105
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 84
      Width = 65
      Height = 13
      Caption = 'Second port :'
    end
    object Label1: TLabel
      Left = 8
      Top = 52
      Width = 51
      Height = 13
      Caption = 'Fisrt port :'
    end
    object Label3: TLabel
      Left = 8
      Top = 17
      Width = 59
      Height = 13
      Caption = 'Ip Address :'
    end
    object EditFp: TSpinEdit
      Left = 80
      Top = 43
      Width = 89
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 2222
    end
    object EditSp: TSpinEdit
      Left = 80
      Top = 75
      Width = 89
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 4444
    end
    object BtnOk: TBitBtn
      Left = 174
      Top = 72
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = BtnOkClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object EditIp: TEdit
      Left = 80
      Top = 16
      Width = 121
      Height = 21
      ReadOnly = True
      TabOrder = 1
      Text = '127.0.0.1'
    end
  end
end
