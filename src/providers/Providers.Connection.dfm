object ProviderConnection: TProviderConnection
  Height = 192
  Width = 223
  object Connection: TFDConnection
    Params.Strings = (
      'OpenMode=OpenOrCreate'
      'CharacterSet=UTF8'
      'User_Name=sysdba'
      'Password=masterkey'
      'Server=localhost'
      'DriverID=FB')
    LoginPrompt = False
    Left = 48
    Top = 48
  end
end
