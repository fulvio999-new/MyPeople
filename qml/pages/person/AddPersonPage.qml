import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

import U1db 1.0 as U1db

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0

/* note: alias name must have first letter in upperCase */
import "../../js/utility.js" as Utility
import "../../js/storage.js" as Storage

/* import folder */
import "../../dialogs"

//------------- ADD NEW PERSON --------------------
Page {
    id: addPersonPage
    visible: false

    property int inputTextWidth;

    header: PageHeader {
       title: i18n.tr("Add new person")
    }

    Component.onCompleted: {
      inputTextWidth: units.gu(10);
    }

    Component {
       id: confirmAddPeopleDialog
       ConfirmInsertPeople{}
    }

    Flickable {
        id: newPersonPageFlickable
        clip: true
        contentHeight: addPersonPage.height * 2 + units.gu(10)
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: units.gu(2)
        }

        /* Display a form with the components to insert/add a new contact: used in Phone view */
        Column{
            id: addPersonPageLayout
            anchors.fill: parent

            /* transparent placeholder */
            Rectangle {
                /* to get the background color of the curreunt theme. Necessary if default theme is not used */
                color: theme.palette.normal.background
                width: parent.width
                height: units.gu(6)
            }

            //-------- Name ------------
            ListItem{
                id: newNameRow
                divider.visible: false

                Label {
                    id: newNameLabel
                    text: i18n.tr("Name")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newNameField.verticalCenter
                   }
                }

                TextField {
                    id: newNameField
                    echoMode: TextInput.Normal
                    inputMethodHints: Qt.ImhNoPredictiveText
                    hasClearButton: true
                    width: units.gu(28)
                    anchors {
                       leftMargin: units.gu(1)
                       rightMargin: units.gu(2)
                       right: parent.right
                       verticalCenter: parent.verticalCenter
                    }
                }
            }

            //-------- SurName ------------
            ListItem{
                id: newSurnameRow
                divider.visible: false

                Label {
                    id: newSurnameLabel
                    text: i18n.tr("Surname")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newSurnameField.verticalCenter
                   }
                }

                TextField {
                    id: newSurnameField
                    echoMode: TextInput.Normal
                    inputMethodHints: Qt.ImhNoPredictiveText
                    width: units.gu(28)
                    anchors {
                          leftMargin: units.gu(1)
                          rightMargin: units.gu(2)
                          right: parent.right
                          verticalCenter: parent.verticalCenter
                    }
                }
            }

            //--------------- Job --------------
            ListItem{
                id: newJobRow
                divider.visible: false

                Label {
                    id: newJobLabel
                    text: i18n.tr("Job")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newJobField.verticalCenter
                   }
                }

                TextField {
                    id: newJobField
                    echoMode: TextInput.Normal
                    width: units.gu(28)
                    inputMethodHints: Qt.ImhNoPredictiveText
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }

            //-------- Birthday ------------
            ListItem{
                id:newBirthdayRow
                divider.visible: false

                Label {
                    id: newBirthdayLabel
                    text: i18n.tr("Birthday")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newBirthdayButton.verticalCenter
                   }
                }

                Button {
                    id: newBirthdayButton
                    width: units.gu(18)
                    property date date: new Date()
                    text: Qt.formatDateTime(date, "dd MMMM yyyy")
                    //Don't use the PickerPanel api because doesn't allow to set minum date
                    onClicked: PopupUtils.open(newPopoverDatePickerComponent, newBirthdayButton)
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }

                /* Create a PopOver conteining a DatePicker, necessary use a PopOver a container due to a bug on setting minimum date
                       with a simple DatePicker Component
                */
                Component {
                    id: newPopoverDatePickerComponent

                    Popover {
                        id: popoverDatePicker

                        DatePicker {
                            id: timePicker
                            mode: "Days|Months|Years"
                            minimum: {
                                var time = new Date()
                                time.setFullYear(1900)
                                return time
                            }

                            Component.onDestruction: {
                                newBirthdayButton.text = Qt.formatDateTime(timePicker.date, "dd MMMM yyyy")
                            }
                        }
                    }
                }
            }

            //------------- Tax code ------------
            ListItem{
                id: newTaxCodeRow
                divider.visible: false

                Label {
                    id: newTaxCodeFieldLabel
                    text: i18n.tr("Tax code")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newTaxCodeField.verticalCenter
                   }
                }

                TextField {
                    id: newTaxCodeField
                    echoMode: TextInput.Normal
                    width: units.gu(28)
                    inputMethodHints: Qt.ImhNoPredictiveText
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }

            //----------- VAT Code ------------
            ListItem{
                id:newVatNumberRow
                divider.visible: false

                Label {
                    id: newVatNumberLabel
                    text: i18n.tr("Vat code")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newVatNumberField.verticalCenter
                   }
                }

                TextField {
                    id: newVatNumberField
                    echoMode: TextInput.Normal
                    width: units.gu(28)
                    inputMethodHints: Qt.ImhNoPredictiveText
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }

            //------------ Address -------------
            ListItem{
                id: newAddressRow
                divider.visible: false

                Label {
                    id: newAddressLabel
                    text: i18n.tr("Address")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newAddressField.verticalCenter
                   }
                }

                TextField {
                    id: newAddressField
                    echoMode: TextInput.Normal
                    width: units.gu(28)
                    inputMethodHints: Qt.ImhNoPredictiveText
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }

            //----------- Phone -----------
            ListItem{
                id: newPhoneRow
                divider.visible: false

                Label{
                    id: newPhoneLabel
                    text: i18n.tr("Phone")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newPhoneField.verticalCenter
                   }
                }

                TextField
                {
                    id: newPhoneField
                    echoMode: TextInput.Normal
                    width: units.gu(28)
                    inputMethodHints: Qt.ImhNoPredictiveText
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }

            //-------- mobile phone ------------
            ListItem{
                id: newMobilePhoneRow
                divider.visible: false

                Label {
                    id: newMobilePhoneLabel
                    text: i18n.tr("Mobile")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newMobilePhoneField.verticalCenter
                   }
                }

                TextField
                {
                    id: newMobilePhoneField
                    echoMode: TextInput.Normal
                    width: units.gu(28)
                    inputMethodHints: Qt.ImhNoPredictiveText
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }

            //---------- Email ------------
            ListItem{
                id: newEmailRow
                divider.visible: false

                Label {
                    id: newEmailLabel
                    text: i18n.tr("Email")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newEmailField.verticalCenter
                   }
                }

                TextField {
                    id: newEmailField
                    echoMode: TextInput.Normal
                    width: units.gu(28)
                    inputMethodHints: Qt.ImhNoPredictiveText
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }

            //-------- Skype------------
            ListItem{
                id: newSkypeRow
                divider.visible: false

                Label {
                    id: newSkypeLabel
                    text: i18n.tr("Skype")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newSkypeField.verticalCenter
                   }
                }

                TextField {
                    id: newSkypeField
                    echoMode: TextInput.Normal
                    width: units.gu(28)
                    inputMethodHints: Qt.ImhNoPredictiveText
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }

            //----------- Telegram ----------
            ListItem{
                id: newTelegramRow
                divider.visible: false

                Label {
                    id: newTelegramLabel
                    text: i18n.tr("Telegram")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newTelegramField.verticalCenter
                   }
                }

                TextField {
                    id: newTelegramField
                    echoMode: TextInput.Normal
                    width: units.gu(28)
                    inputMethodHints: Qt.ImhNoPredictiveText
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }

            //------------ Note -------------
            ListItem{
                id: newNoteRow
                divider.visible: false
                height: units.gu(18)
                Label {
                    id: newNoteLabel
                    text: i18n.tr("Note")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newNoteTextArea.verticalCenter
                   }
                }

                TextArea {
                    id: newNoteTextArea
                    textFormat:TextEdit.AutoText
                    height: units.gu(15)
                    width: units.gu(28)
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }

            //------------- Command buttom -------------
            ListItem{
                divider.visible: false

                Button {
                    id: addButton
                    objectName: "Add"
                    text: i18n.tr("Add")
                    color: UbuntuColors.orange
                    width: units.gu(12)
                    onClicked: {
                        PopupUtils.open(confirmAddPeopleDialog)
                    }
                    anchors {
                        top: newNoteTextArea.bottom
                        topMargin: units.gu(5)
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        } //col
    }

    /* To show a scrolbar on the side */
    Scrollbar {
        flickableItem: newPersonPageFlickable
        align: Qt.AlignTrailing
    }
}
