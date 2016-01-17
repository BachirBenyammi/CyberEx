object FrmBrw: TFrmBrw
  Left = 155
  Top = 25
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'File Browser'
  ClientHeight = 345
  ClientWidth = 217
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 217
    Height = 345
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object Ok: TSpeedButton
      Left = 184
      Top = 8
      Width = 25
      Height = 22
      Caption = 'Ok'
      OnClick = OkClick
    end
    object EditDir: TComboBox
      Left = 8
      Top = 8
      Width = 169
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnKeyPress = EditDirKeyPress
    end
    object ListFiles: TFileListBox
      Left = 8
      Top = 37
      Width = 201
      Height = 300
      FileType = [ftReadOnly, ftHidden, ftSystem, ftVolumeID, ftDirectory, ftArchive, ftNormal]
      ItemHeight = 13
      TabOrder = 1
      OnContextPopup = ListFilesContextPopup
      OnDblClick = ListFilesDblClick
      OnKeyPress = ListFilesKeyPress
    end
  end
  object SD: TSaveDialog
    Left = 72
  end
  object Command: TActionList
    Left = 48
    object ExecuteAc: TAction
      Caption = 'Execute'
      OnExecute = ExecuteAcExecute
    end
    object CopyAc: TAction
      Caption = 'Copy'
      OnExecute = CopyAcExecute
    end
    object DeleteAc: TAction
      Caption = 'Delete'
      OnExecute = DeleteAcExecute
    end
  end
  object Menu: TPopupMenu
    Left = 16
    object Execute1: TMenuItem
      Action = ExecuteAc
    end
    object Copy1: TMenuItem
      Action = CopyAc
    end
    object Delete1: TMenuItem
      Action = DeleteAc
    end
    object Accept1: TMenuItem
      Caption = 'Add to Non Accept List'
      Enabled = False
      OnClick = Accept1Click
    end
  end
end
