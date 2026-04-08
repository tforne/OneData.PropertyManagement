page 96044 "Headline FFO Manager"
{
    Caption = 'Headline';
    PageType = HeadlinePart;
    RefreshOnActivate = true;
    ApplicationArea = All;
    SourceTable = "Company Information";

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                Visible = UserGreetingVisible;
                field(GreetingText; GreetingText)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Greeting headline';
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Control2)
            {
                ShowCaption = false;
                Visible = DefaultFieldsVisible;
                field(DocumentationText; DocumentationText)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Documentation headline';
                    DrillDown = true;
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        HyperLink(DocumentationUrlTxt);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        InitializeHeadlines();
    end;

    var
        DefaultFieldsVisible: Boolean;
        UserGreetingVisible: Boolean;
        GreetingText: Text[250];
        DocumentationText: Text[250];
        DocumentationUrlTxt: Text[250];

    local procedure InitializeHeadlines()
    begin
        GreetingText := GetGreetingText();
        DocumentationUrlTxt := 'https://tforne.github.io/OneData.PropertyManagement/docs/solutions/property-management/';
        DocumentationText := 'Consulte la documentación de Property Management para configuración, diarios e importaciones.';
        UserGreetingVisible := GreetingText <> '';
        DefaultFieldsVisible := DocumentationText <> '';
    end;

    local procedure GetGreetingText(): Text[250]
    var
        CurrentUser: Text;
        CurrentTime: Time;
        GreetingPrefix: Text;
    begin
        CurrentUser := UserId;
        CurrentTime := Time;

        if CurrentTime < 120000T then
            GreetingPrefix := 'Buenos días'
        else
            if CurrentTime < 190000T then
                GreetingPrefix := 'Buenas tardes'
            else
                GreetingPrefix := 'Buenas noches';

        if CurrentUser = '' then
            exit(StrSubstNo('%1. Bienvenido a Property Management.', GreetingPrefix));

        exit(StrSubstNo('%1, %2. Bienvenido a Property Management.', GreetingPrefix, CurrentUser));
    end;
}

