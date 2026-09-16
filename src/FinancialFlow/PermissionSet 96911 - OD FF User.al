permissionset 96987 "OD FF User"
{
    Assignable = true;
    Caption = 'OD Financial Flow User';

    Permissions =
        table "OD FF Setup" = X,
        tabledata "OD FF Setup" = R,
        table "OD FF Buffer" = X,
        tabledata "OD FF Buffer" = RIMD,
        table "OD FF Snapshot Header" = X,
        tabledata "OD FF Snapshot Header" = R,
        table "OD FF Snapshot Line" = X,
        tabledata "OD FF Snapshot Line" = R,
        table "OD FF Compare Buffer" = X,
        tabledata "OD FF Compare Buffer" = RIMD,
        table "OD FF Contract Summary" = X,
        tabledata "OD FF Contract Summary" = RIMD,
        tabledata "Lease Contract" = R,
        tabledata "Lease Contract Line" = R,
        tabledata "Fixed Real Estate" = R,
        page "OD FF Map" = X,
        page "OD FF Snapshot List" = X,
        page "OD FF Snapshot Card" = X,
        page "OD FF Snapshot Subpage" = X,
        page "OD FF Compare" = X,
        page "OD FF Contract Summary" = X,
        codeunit "OD FF Management" = X,
        codeunit "OD FF Snapshot Mgt" = X,
        codeunit "OD FF Excel Export" = X;
}
