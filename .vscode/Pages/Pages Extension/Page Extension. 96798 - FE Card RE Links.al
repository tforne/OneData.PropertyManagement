pageextension 96798 "FA Card RE Links" extends "Fixed Asset Card"
{
    layout
    {
        addlast(Content)
        {
            group("Activos inmobiliarios")
            {
                Caption = 'Activos inmobiliarios';

                part(RelatedRealEstates; "OD FA RE Link ListPart")
                {
                    ApplicationArea = All;
                    SubPageLink = "FA No." = field("No.");
                }
            }
        }
    }
}