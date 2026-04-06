page 96781 "FRE RC Headline"
{
    PageType = HeadlinePart;
    ApplicationArea = All;
    SourceTable = "Company Information";
    Caption = 'OneData Operations Headline';

    layout
    {
        area(content)
        {
            group(General)
            {
                field(HeadlineTxt; HeadlineTxt)
                {
                    ShowCaption = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        HeadlineTxt := 'OneData Operations · Extractos bancarios, FRE Journal, posting y movimientos por activo';
    end;

    var
        HeadlineTxt: Text[250];
}