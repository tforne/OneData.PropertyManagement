function CopyText(textToCopy) {
    if (!textToCopy) {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CopyFailed', ['No se ha recibido ningún texto para copiar.']);
        return;
    }

    if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(textToCopy)
            .then(function () {
                Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CopySucceeded', []);
            })
            .catch(function (error) {
                fallbackCopyText(textToCopy, error);
            });
        return;
    }

    fallbackCopyText(textToCopy);
}

function fallbackCopyText(textToCopy, originalError) {
    try {
        var textArea = document.createElement('textarea');

        textArea.value = textToCopy;
        textArea.setAttribute('readonly', 'readonly');
        textArea.style.position = 'fixed';
        textArea.style.opacity = '0';
        textArea.style.pointerEvents = 'none';

        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        textArea.setSelectionRange(0, textArea.value.length);

        if (document.execCommand('copy')) {
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CopySucceeded', []);
        } else {
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CopyFailed', ['El navegador ha bloqueado la copia al portapapeles.']);
        }

        document.body.removeChild(textArea);
    } catch (error) {
        var errorText = 'No se ha podido copiar el dato al portapapeles.';

        if (originalError && originalError.message) {
            errorText += ' ' + originalError.message;
        } else if (error && error.message) {
            errorText += ' ' + error.message;
        }

        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CopyFailed', [errorText]);
    }
}
