permissionset 96987 "OD FF User"
{
    Assignable = true;
    Caption = 'OD Financial Flow User';

    Permissions =
        tabledata "OD FF Setup" = R,
        tabledata "OD FF Buffer" = RIMD,
        tabledata "OD FF Snapshot Header" = R,
        tabledata "OD FF Snapshot Line" = R,
        tabledata "OD FF Compare Buffer" = RIMD,
        tabledata "OD FF Contract Summary" = RIMD,
        tabledata "Lease Contract" = R,
        tabledata "Lease Contract Line" = R,
        tabledata "Fixed Real Estate" = R,
        page "OD FF Map" = X,
        page "OD FF Snapshot List" = X,
        page "OD FF Snapshot Card" = X,
        page "OD FF Compare" = X,
        page "OD FF Contract Summary" = X,
        codeunit "OD FF Management" = X,
        codeunit "OD FF Snapshot Mgt" = X,
        codeunit "OD FF Excel Export" = X;
}
