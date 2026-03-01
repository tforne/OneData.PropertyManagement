table 97000 "Tenant User Mapping"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User Email"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
    }

    keys
    {
        key(PK; "User Email")
        {
            Clustered = true;
        }
    }
}