import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0


/* Display a dialog with the new features list added in the current Application version */

 Dialog {
        id: newFeaturesDialogue
        title: i18n.tr("What's new in this version")
        Row {
            spacing: units.gu(1)
            TextArea {
                width: parent.width
                height: units.gu(20)
                enabled: false
                autoSize: true
                horizontalAlignment: TextEdit.AlignHCenter
                placeholderText: "*"+i18n.tr("Code refactoring")+"<br/> *"+i18n.tr("Little fix for layout")+"<br/>"
            }
        }

        Row {
            spacing: units.gu(2)
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                text: i18n.tr("Don't show again")
            }
            CheckBox {
                id: hideNewsListNextTime
                checked: false
                onClicked: {
                    if(hideNewsListNextTime.checked){
                        settings.isFirstUse = false
                        settings.isNewVersion = false
                    }else{
                        settings.isFirstUse = true
                        settings.isNewVersion = true
                    }
                }
            }
        }

        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.gu(2)

            /* placeholder */
            Rectangle {
                color: "transparent"
                width: units.gu(7)
                height: units.gu(3)
            }

            Button {
                text: i18n.tr("Close")
                onClicked: PopupUtils.close(newFeaturesDialogue)
            }
        }
    }
