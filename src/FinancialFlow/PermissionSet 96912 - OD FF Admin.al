permissionset 96988 "OD FF Admin"
{
    Assignable = true;
    Caption = 'OD Financial Flow Admin';

    Permissions =
        tabledata "OD FF Setup" = RIMD,
        tabledata "OD FF Buffer" = RIMD,
        tabledata "OD FF Snapshot Header" = RIMD,
        tabledata "OD FF Snapshot Line" = RIMD,
        tabledata "OD FF Compare Buffer" = RIMD,
        tabledata "OD FF Contract Summary" = RIMD,
        tabledata "Lease Contract" = R,
        tabledata "Lease Contract Line" = R,
        tabledata "Fixed Real Estate" = R,
        page "OD FF Setup" = X,
        page "OD FF Map" = X,
        page "OD FF Snapshot List" = X,
        page "OD FF Snapshot Card" = X,
        page "OD FF Compare" = X,
        page "OD FF Contract Summary" = X,
        codeunit "OD FF Contract Adapter" = X,
        codeunit "OD FF Analyzer" = X,
        codeunit "OD FF Management" = X,
        codeunit "OD FF Snapshot Mgt" = X,
        codeunit "OD FF Excel Export" = X;
}
