Attribute VB_Name = "modFunctions"
Option Explicit

Public Function IsLoaded(ByVal frm As Form) As Boolean
    
    Dim m_frm As Form
    
    For Each m_frm In Forms
        If m_frm.Name = frm.Name Then
            IsLoaded = True
            Exit Function
        End If
    Next
    
    IsLoaded = False
    
End Function

Public Function ShowForm(frm As Form)
    
    Screen.MousePointer = vbHourglass
    If Not IsLoaded(frm) Then
        frm.Show
    Else
        frm.ZOrder 0
    End If
    Screen.MousePointer = vbDefault
    
End Function

Public Function ToggleModal(ByVal blnModal As Boolean, Optional frm As Form)
    
    Dim blnEnabled As Boolean
    
    If blnModal = True Then
        Call EnableOneForm(frm)
        blnEnabled = False
    Else
        Call EnableAllForms
        blnEnabled = True
    End If
    
    With frmMain
        .tbar.Enabled = blnEnabled
        .tvwContents.Enabled = blnEnabled
        .mnuFile.Enabled = blnEnabled
        .mnuWindow.Enabled = blnEnabled
        .mnuHelp.Enabled = blnEnabled
    End With
    
End Function

Private Function EnableOneForm(frm As Form)

    Dim m_frm As Form
    
    For Each m_frm In Forms
        If m_frm.Name = "frmMain" Or m_frm.Name = frm.Name Then
            m_frm.Enabled = True
        Else
            m_frm.Enabled = False
        End If
    Next m_frm

End Function

Private Function EnableAllForms()

    Dim m_frm As Form
    
    For Each m_frm In Forms
        m_frm.Enabled = True
    Next m_frm
    
End Function

Public Sub CenterWindow(frm As Form)
    frm.Left = (Screen.Width - frm.Width) / 2
    frm.Top = (Screen.Height - frm.Height) / 2
End Sub
