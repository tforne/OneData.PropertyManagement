page 96702 "FRE Jnl. Batches"
{
    Caption = 'FRE Jnl. Batches';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = "FRE Jnl. Batch";
    ApplicationArea = All;

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

            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1900383208; Notes)
            {
                Visible = false;
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
        JnlManagement: Codeunit "FRE Journals Management";

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

