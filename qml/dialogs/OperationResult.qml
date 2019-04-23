import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/* Generic Dialog to notify an operation executed successfully */
Dialog {
    id: operationResult
    title: i18n.tr("Operation Result")

    Label{
         text: i18n.tr("Operation executed successfully")
         color: UbuntuColors.green
    }

    Button {
        text: i18n.tr("Close")
        onClicked:
            PopupUtils.close(operationResult)
    }
}
