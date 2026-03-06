page 96702 "FRE Jnl. Batches"
{
    Caption = 'FRE Jnl. Batches';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = "FRE Jnl. Batch";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the FRE journal.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies some information about the FRE journal.';
                }
                field("Periode Code"; Rec."Periode Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the month to report data for. Enter the period as a four-digit number, with no spaces or symbols. Depending on your country, enter either the month first and then the year, or vice versa. For example, enter either 1706 or 0617 for June, 2017.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1900383208; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(EditJournal)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ToolTip = 'Open a journal based on the journal batch.';

                trigger OnAction()
                begin
                    JnlManagement.TemplateSelectionFromBatch(Rec);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        Rec.SETRANGE("Journal Template Name");
    end;

    trigger OnOpenPage()
    begin
        JnlManagement.OpenJnlBatch(Rec);
    end;

    var
        JnlManagement: Codeunit "Journals Management";

    local procedure DataCaption(): Text[250]
    var
        IntraJnlTemplate: Record "FRE Jnl. Template";
    begin
        IF NOT CurrPage.LOOKUPMODE THEN
            IF (Rec.GETFILTER("Journal Template Name") <> '') AND (Rec.GETFILTER("Journal Template Name") <> '''''') THEN
                IF Rec.GETRANGEMIN("Journal Template Name") = Rec.GETRANGEMAX("Journal Template Name") THEN
                    IF IntraJnlTemplate.GET(Rec.GETRANGEMIN("Journal Template Name")) THEN
                        EXIT(IntraJnlTemplate.Name + ' ' + IntraJnlTemplate.Description);
    end;
}

