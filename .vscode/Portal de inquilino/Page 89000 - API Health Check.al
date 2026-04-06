page 89000 "API Health Check"
{
    PageType = API;
    APIPublisher = 'onedata';
    APIGroup = 'health';
    APIVersion = 'v1.0';

    EntityName = 'health';
    EntitySetName = 'healthCheck';

    SourceTable = Company;

    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(name; rec.Name)
                {
                }
            }
        }
    }
}
