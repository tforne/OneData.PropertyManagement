pageextension 96997 "OD AM Fixed Asset Card" extends "Fixed Asset Card"
{
    actions
    {
        addlast(processing)
        {
            action(ODCreateRealEstateAsset)
            {
                ApplicationArea = All;
                Caption = 'Crear activo inmobiliario';
                Image = FixedAssets;
                ToolTip = 'Crea un activo inmobiliario a partir del activo fijo actual y abre su ficha para completar el resto de datos. Si ya existe un vínculo activo, abre la ficha existente.';

                trigger OnAction()
                var
                    FAtoFREMgt: Codeunit "OD AM FA to FRE Mgt.";
                begin
                    FAtoFREMgt.OpenOrCreateRealEstateFromFixedAsset(Rec);
                end;
            }
        }
    }
}
