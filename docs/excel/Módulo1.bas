Attribute VB_Name = "M�dulo1"
Option Explicit

Sub GenerarJournalLines()

    Dim wsSource As Worksheet
    Dim wsJournal As Worksheet
    Dim lastRowSource As Long
    Dim targetRow As Long
    Dim i As Long

    Dim fecha As Variant
    Dim movimiento As String
    Dim masDatos As String
    Dim importe As Variant
    Dim descripcionFinal As String
    Dim docNo As String

    Set wsSource = ThisWorkbook.Worksheets("Source")
    Set wsJournal = ThisWorkbook.Worksheets("Journal Lines")

    ' Limpiar contenido anterior en Journal Lines desde la fila 2
    wsJournal.Range("A2:H1048576").ClearContents

    ' Buscar ?ltima fila de Source
    lastRowSource = wsSource.Cells(wsSource.Rows.Count, 1).End(xlUp).Row

    targetRow = 2

    For i = 4 To lastRowSource

        fecha = wsSource.Cells(i, 1).Value          ' Data
        movimiento = Trim(CStr(wsSource.Cells(i, 3).Value))   ' Moviment
        masDatos = Trim(CStr(wsSource.Cells(i, 4).Value))     ' M?s dades
        importe = wsSource.Cells(i, 5).Value        ' Import

        ' Saltar filas vac?as
        If Trim(CStr(fecha)) <> "" Or Trim(CStr(movimiento)) <> "" Or Trim(CStr(importe)) <> "" Then

            ' Construir descripci?n
            If masDatos <> "" Then
                descripcionFinal = movimiento & " - " & masDatos
            Else
                descripcionFinal = movimiento
            End If

            ' Construir n? de documento autom?tico
            docNo = "SRC-" & Format(i - 1, "00000")

            ' A - Date
            wsJournal.Cells(targetRow, 1).Value = fecha

            ' B - Document Type
            wsJournal.Cells(targetRow, 2).Value = ""

            ' C - Document No.
            wsJournal.Cells(targetRow, 3).Value = docNo

            ' D - Line Type
            wsJournal.Cells(targetRow, 4).Value = "Realizado"

            ' E - Fixed Real Estate Description
            wsJournal.Cells(targetRow, 5).Value = ""

            ' F - Description
            wsJournal.Cells(targetRow, 6).Value = descripcionFinal

            ' G - Description Row No.
            wsJournal.Cells(targetRow, 7).Value = ""

            ' H - Amount
            wsJournal.Cells(targetRow, 8).Value = importe

            targetRow = targetRow + 1
        End If

    Next i

    MsgBox "Se han generado " & (targetRow - 2) & " l?neas en Journal Lines.", vbInformation

End Sub
