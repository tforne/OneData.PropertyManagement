codeunit 96825 "FRE Tenant Notice Mgt."
{
    procedure PublishNotice(var TenantNotice: Record "FRE Tenant Notice Header")
    begin
        TenantNotice.TestField(Title);
        TenantNotice.TestField(Description);

        if TenantNotice.Status <> TenantNotice.Status::Draft then
            Error('Only draft notices can be published.');

        TenantNotice.Status := TenantNotice.Status::Published;
        TenantNotice."Published DateTime" := CurrentDateTime;

        if TenantNotice."Publish From" = 0DT then
            TenantNotice."Publish From" := CurrentDateTime;

        TenantNotice.Modify(true);
    end;

    procedure CloseNotice(var TenantNotice: Record "FRE Tenant Notice Header")
    begin
        if TenantNotice.Status in [TenantNotice.Status::Closed, TenantNotice.Status::Cancelled] then
            Error('The notice is already closed or cancelled.');

        TenantNotice.Status := TenantNotice.Status::Closed;
        TenantNotice.Modify(true);
    end;

    procedure CancelNotice(var TenantNotice: Record "FRE Tenant Notice Header")
    begin
        TenantNotice.Status := TenantNotice.Status::Cancelled;
        TenantNotice.Modify(true);
    end;

    procedure GetNextRecipientLineNo(NoticeId: Guid): Integer
    var
        Recipient: Record "FRE Tenant Notice Recipient";
    begin
        Recipient.SetRange("Notice Id.", NoticeId);

        if Recipient.FindLast() then
            exit(Recipient."Line No." + 10000);

        exit(10000);
    end;

    procedure AddCustomerRecipient(var TenantNotice: Record "FRE Tenant Notice Header"; CustomerNo: Code[20])
    var
        Customer: Record Customer;
        Recipient: Record "FRE Tenant Notice Recipient";
    begin
        TenantNotice.TestField("Notice Id.");
        Customer.Get(CustomerNo);

        Recipient.Init();
        Recipient."Notice Id." := TenantNotice."Notice Id.";
        Recipient."Line No." := GetNextRecipientLineNo(TenantNotice."Notice Id.");
        Recipient."Customer No." := Customer."No.";
        Recipient.Name := Customer.Name;
        Recipient.Email := Customer."E-Mail";
        Recipient."Portal Visible" := TenantNotice."Show In Portal";
        Recipient.Insert(true);
    end;

    procedure MarkRecipientAsRead(var Recipient: Record "FRE Tenant Notice Recipient")
    begin
        if Recipient."Read In Portal" then
            exit;

        Recipient."Read In Portal" := true;
        Recipient."Read DateTime" := CurrentDateTime;
        Recipient.Modify(true);
    end;

    procedure SimulateSendEmail(var TenantNotice: Record "FRE Tenant Notice Header")
    var
        Recipient: Record "FRE Tenant Notice Recipient";
    begin
        TenantNotice.TestField(Title);
        TenantNotice.TestField(Description);

        Recipient.SetRange("Notice Id.", TenantNotice."Notice Id.");
        Recipient.SetRange("Email Sent", false);

        if Recipient.FindSet(true) then
            repeat
                if Recipient.Email <> '' then begin
                    Recipient."Email Sent" := true;
                    Recipient."Email Sent DateTime" := CurrentDateTime;
                    Recipient.Modify(true);
                end;
            until Recipient.Next() = 0;

        TenantNotice.Status := TenantNotice.Status::Sent;
        TenantNotice."Sent DateTime" := CurrentDateTime;
        TenantNotice.Modify(true);
    end;
}
