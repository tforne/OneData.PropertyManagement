namespace OneData.Property.Lease;

codeunit 96043 "OD Lease Contract Copy Subsc."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"OD Copy Lease Contract Mgt.", 'OnCopyComments', '', false, false)]
    local procedure OnCopyComments(SourceHeader: Record "Lease Contract"; var TargetHeader: Record "Lease Contract"; SourceCompanyName: Text[30])
    var
        SourceComment: Record "Lease Comment Line";
        TargetComment: Record "Lease Comment Line";
    begin
        TargetComment.SetRange("Table Name", TargetComment."Table Name"::"Lease Contract");
        TargetComment.SetRange("Table Subtype", TargetComment."Table Subtype"::"0");
        TargetComment.SetRange("No.", TargetHeader."Contract No.");
        if not TargetComment.IsEmpty() then
            TargetComment.DeleteAll();

        SourceComment.ChangeCompany(SourceCompanyName);
        SourceComment.SetRange("Table Name", SourceComment."Table Name"::"Lease Contract");
        SourceComment.SetRange("Table Subtype", SourceComment."Table Subtype"::"0");
        SourceComment.SetRange("No.", SourceHeader."Contract No.");

        if SourceComment.FindSet() then
            repeat
                TargetComment.Init();
                TargetComment."Table Name" := TargetComment."Table Name"::"Lease Contract";
                TargetComment."Table Subtype" := TargetComment."Table Subtype"::"0";
                TargetComment."No." := TargetHeader."Contract No.";
                TargetComment.Type := SourceComment.Type;
                TargetComment."Table Line No." := SourceComment."Table Line No.";
                TargetComment."Line No." := SourceComment."Line No.";
                TargetComment.Date := SourceComment.Date;
                TargetComment.Comment := SourceComment.Comment;
                TargetComment.Insert();
            until SourceComment.Next() = 0;
    end;
}
