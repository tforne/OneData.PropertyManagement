codeunit 96984 "OD FF Excel Export"
{
    procedure ExportCurrentUserAnalysis()
    var
        Buffer: Record "OD FF Buffer";
        ExcelBuffer: Record "Excel Buffer" temporary;
        RowNo: Integer;
    begin
        Buffer.SetRange("User ID", CopyStr(UserId(), 1, 50));
        if not Buffer.FindSet() then
            Error('No existen líneas para exportar.');

        AddHeader(ExcelBuffer, RowNo);

        repeat
            RowNo += 1;
            AddCell(ExcelBuffer, RowNo, 1, Buffer."Company Name");
            AddCell(ExcelBuffer, RowNo, 2, Buffer."Property No.");
            AddCell(ExcelBuffer, RowNo, 3, Buffer."Property Description");
            AddCell(ExcelBuffer, RowNo, 4, Buffer."Contract No.");
            AddCell(ExcelBuffer, RowNo, 5, Buffer."Customer Name");
            AddCell(ExcelBuffer, RowNo, 6, Format(Buffer."Contract Start Date"));
            AddCell(ExcelBuffer, RowNo, 7, Format(Buffer."Contract End Date"));
            AddCell(ExcelBuffer, RowNo, 8, Buffer."Monthly Rent");
            AddCell(ExcelBuffer, RowNo, 9, Buffer."Annual Rent");
            AddCell(ExcelBuffer, RowNo, 10, Buffer."Market Value");
            AddCell(ExcelBuffer, RowNo, 11, Buffer."Forecast Income 12M");
            AddCell(ExcelBuffer, RowNo, 12, Buffer."Gross Yield Percentage");
            AddCell(ExcelBuffer, RowNo, 13, Buffer."Net Yield Percentage");
            AddCell(ExcelBuffer, RowNo, 14, Buffer."Cash Flow Amount");
            AddCell(ExcelBuffer, RowNo, 15, Format(Buffer."Risk Level"));
            AddCell(ExcelBuffer, RowNo, 16, Buffer."Risk Description");
        until Buffer.Next() = 0;

        ExcelBuffer.CreateNewBook('Financial Flow');
        ExcelBuffer.WriteSheet('Financial Flow', CompanyName(), UserId());
        ExcelBuffer.CloseBook();
        ExcelBuffer.OpenExcel();
    end;

    local procedure AddHeader(var ExcelBuffer: Record "Excel Buffer" temporary; var RowNo: Integer)
    begin
        RowNo := 1;
        AddCell(ExcelBuffer, RowNo, 1, 'Empresa');
        AddCell(ExcelBuffer, RowNo, 2, 'Activo');
        AddCell(ExcelBuffer, RowNo, 3, 'Descripción activo');
        AddCell(ExcelBuffer, RowNo, 4, 'Contrato');
        AddCell(ExcelBuffer, RowNo, 5, 'Cliente');
        AddCell(ExcelBuffer, RowNo, 6, 'Fecha inicio');
        AddCell(ExcelBuffer, RowNo, 7, 'Fecha fin');
        AddCell(ExcelBuffer, RowNo, 8, 'Renta mensual');
        AddCell(ExcelBuffer, RowNo, 9, 'Renta anual');
        AddCell(ExcelBuffer, RowNo, 10, 'Valor');
        AddCell(ExcelBuffer, RowNo, 11, 'Previsión 12M');
        AddCell(ExcelBuffer, RowNo, 12, 'Yield bruto %');
        AddCell(ExcelBuffer, RowNo, 13, 'Yield neto %');
        AddCell(ExcelBuffer, RowNo, 14, 'Cash flow');
        AddCell(ExcelBuffer, RowNo, 15, 'Riesgo');
        AddCell(ExcelBuffer, RowNo, 16, 'Descripción riesgo');
    end;

    local procedure AddCell(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColNo: Integer; CellValue: Variant)
    begin
        ExcelBuffer.Init();
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColNo);
        ExcelBuffer."Cell Value as Text" := CopyStr(Format(CellValue), 1, MaxStrLen(ExcelBuffer."Cell Value as Text"));
        ExcelBuffer.Insert();
    end;
}
