import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import Ubuntu.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0

import "utility.js" as Utility
import "storage.js" as Storage

/* Display a form with the components to insert/add a new contact: usec in Tablet view */
Column{
    id: addPersonPageLayout
    spacing: units.gu(3)

    Component {
        id: confirmAddPeopleDialog
        ConfirmInsertPeople{}
    }

    /* transparent placeholder */
    Rectangle {
        color: "transparent"
        width: parent.width
        height: units.gu(6)
    }

    //-------- Name ------------
    Row{
        id: newNameRow
        spacing: units.gu(5)

        Label {
            id: newNameLabel
            anchors.verticalCenter:  newNameField.verticalCenter
            text: i18n.tr("Name:")
        }

        TextField {
            id: newNameField
            text: ""
            placeholderText: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(35)
        }

        Label {
            id: newSurnameLabel
            anchors.verticalCenter: newSurnameField.verticalCenter
            text: i18n.tr("Surname:")
        }

        TextField {
            id: newSurnameField
            placeholderText: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(35)
        }
    }

    //--------------- Job --------------
    Row{
        id: newJobRow
        spacing: units.gu(6.6)

        Label {
            id: newCategoryLabel
            anchors.verticalCenter: newJobField.verticalCenter
            text: i18n.tr("Job:")
        }

        TextField {
            id: newJobField
            placeholderText: ""
            text: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(35)
        }

        Label {
            id: newBirthdayLabel
            anchors.verticalCenter: newBirthdayButton.verticalCenter
            text: i18n.tr("Birthday:")
        }

        Button {
            id: newBirthdayButton
            width: units.gu(18)
            property date date: new Date()
            text: Qt.formatDateTime(date, "dd MMMM yyyy")
            /* Don't use the PickerPanel api because doesn't allow to set a minum date */
            onClicked: PopupUtils.open(newPopoverDatePickerComponent, newBirthdayButton)
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
    Row{
        id: newTaxCodeRow
        spacing: units.gu(2.6)

        Label {
            id: newTaxCodeFieldLabel
            anchors.verticalCenter: newTaxCodeField.verticalCenter
            text: i18n.tr("Tax code:")
        }

        TextField {
            id: newTaxCodeField
            placeholderText: ""
            text: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(35)
        }
    }

    //----------- VAT Code ------------
    Row{
        id:newVatNumberRow
        spacing: units.gu(2.8)

        Label {
            id: newVatNumberLabel
            anchors.verticalCenter: newVatNumberField.verticalCenter
            text: i18n.tr("Vat code:")
        }

        TextField {
            id: newVatNumberField
            placeholderText: ""
            text: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(35)
        }
    }

    //--------------- Address -------------------
    Row{
        id: newAddressRow
        spacing: units.gu(3.6)

        Label {
            id: newAddressLabel
            anchors.verticalCenter: newAddressField.verticalCenter
            text: i18n.tr("Address:")
        }

        TextField {
            id: newAddressField
            placeholderText: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(35)
        }
    }

    //----------- Phone -----------
    Row{
        id: newPhoneRow
        spacing: units.gu(5.4)

        Label{
            id: newPhoneLabel
            anchors.verticalCenter: newPhoneField.verticalCenter
            text: i18n.tr("Phone:")
        }

        TextField
        {
            id: newPhoneField
            placeholderText: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(35)
        }

        //-------- mobile phone
        Label {
            id: newMobilePhoneLabel
            anchors.verticalCenter: newMobilePhoneField.verticalCenter
            text: i18n.tr("Mobile:")
        }

        TextField
        {
            id: newMobilePhoneField
            placeholderText: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(30)
        }
    }

    //------------ Email & Skype------------
    Row{
        id: newEmailRow
        spacing: units.gu(6)

        Label {
            id: newEmailLabel
            anchors.verticalCenter: newEmailField.verticalCenter
            text: i18n.tr("Email:")
        }

        TextField {
            id: newEmailField
            placeholderText: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(35)
        }

        Label {
            id: newSkypeLabel
            anchors.verticalCenter: newSkypeField.verticalCenter
            text: i18n.tr("Skype:")
        }

        TextField {
            id: newSkypeField
            placeholderText: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(30)
        }
    }

    //----------- Telegram ----------
    Row{
        id: newTelegramRow
        spacing: units.gu(3)

        Label {
            id: newTelegramLabel
            anchors.verticalCenter: newTelegramField.verticalCenter
            text: i18n.tr("Telegram:")
        }

        TextField {
            id: newTelegramField
            placeholderText: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(35)
        }
    }

    //------------ Note -------------
    Row{
        id: newNoteRow
        spacing: units.gu(6)

        Label {
            id: newNoteLabel
            anchors.verticalCenter: newNoteTextArea.verticalCenter
            text: i18n.tr("Note:")
        }

        TextArea {
            id: newNoteTextArea
            textFormat:TextEdit.AutoText
            height: units.gu(15)
            width: units.gu(70)
            readOnly: false
        }
    }

    //------------- Command buttom -------------
    Row{
        x: newNoteLabel.width + units.gu(6)

        Button {
            id: addButton
            objectName: "Add"
            text: i18n.tr("Add")
            width: units.gu(18)
            onClicked: {
                PopupUtils.open(confirmAddPeopleDialog)
            }
        }
    }

}
