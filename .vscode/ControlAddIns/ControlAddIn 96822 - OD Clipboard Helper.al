controladdin "OD Clipboard Helper"
{
    Scripts = '.vscode/ControlAddIns/ODClipboardHelper.js';

    RequestedHeight = 1;
    RequestedWidth = 1;
    MinimumHeight = 1;
    MinimumWidth = 1;
    MaximumHeight = 1;
    MaximumWidth = 1;
    HorizontalStretch = false;
    VerticalStretch = false;

    procedure CopyText(TextToCopy: Text);
    event CopySucceeded();
    event CopyFailed(ErrorText: Text);
}
