Attribute VB_Name = "Module2"
Public Declare Function GetSystemDirectory Lib "kernel32" Alias "GetSystemDirectoryA" _
        (ByVal lpBuffer As String, ByVal nSize As Long) As Long

Public Declare Function GetTempPath Lib "kernel32" Alias "GetTempPathA" _
        (ByVal nSize As Long, ByVal lpBuffer As String) As Long

Public Declare Function GetWindowsDirectory Lib "kernel32" Alias "GetWindowsDirectoryA" _
        (ByVal lpBuffer As String, ByVal nSize As Long) As Long




