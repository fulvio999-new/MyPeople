import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

/* note: alias name must have first letter in upperCase */
import "../../js/utility.js" as Utility
import "../../js/storage.js" as Storage

/* import folder */
import "../../dialogs"

/*
 Used in Main.qml to show the details of a selectd Person/contact in the contacts list. Used for Phone

 NOTE: All the TextField have set 'hasClearButton: false'. If 'hasClearButton: true' is shown a clear button
 in the field, and when is used there are refresh problem of the TextField when another person is chosen in the list

*/
Column {
    id: personDetailPageLayout
    anchors.fill: parent
    spacing: units.gu(3.5)
    anchors.leftMargin: units.gu(2)

    Rectangle {
        color: "transparent"
        width: parent.width
        height: units.gu(6)
    }

    //------------- Name --------------
    Row{
        id: nameRow
        spacing: units.gu(5)

        Label {
            id: nameLabel
            anchors.verticalCenter: nameField.verticalCenter
            text:  i18n.tr("Name")+":"
        }

        TextField {
            id: nameField
            text: personDetailsPage.personName
            placeholderText: ""
            echoMode: TextInput.Normal
            width: units.gu(30)
            hasClearButton: false
            /*  Dummy solution to have a refresh of the 'birthdayButton' when user select another person
                all the other text field are update in auto; 'birthdayButton' is not refreshed (bug?)
            */
            onTextChanged: {
                birthdayButton.text = personDetailsPage.personBirthday
            }
        }
    }

    //------------- Surname --------------
    Row{
        id: newSurnameRow
        spacing: units.gu(3)

        Label {
            id: surnameLabel
            anchors.verticalCenter: surnameField.verticalCenter
            text: i18n.tr("Surname")+":"
        }

        TextField {
            id: surnameField
            placeholderText: ""
            text: personDetailsPage.personSurname
            echoMode: TextInput.Normal
            width: units.gu(30)
            hasClearButton: false
        }
    }

    //------------- Job -------------
    Row{
        id: jobRow
        spacing: units.gu(6.6)

        Label {
            id: categoryLabel
            text: i18n.tr("Job")+":"
        }

        TextField {
            id: jobField
            placeholderText: ""
            text: personDetailsPage.personJob
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(30)
            hasClearButton: false
        }
    }

    //------------ Birthday ------------
    Row{
        id:newBirthdayRow
        spacing: units.gu(3)

        Label {
            id: birthdayLabel
            anchors.verticalCenter: birthdayButton.verticalCenter
            text: i18n.tr("Birthday")+":"
        }

        /* Create a PopOver containing a DatePicker, necessary use a PopOver a container due to a bug on setting minimum date
           with a simple DatePicker Component
        */
        Component {
            id: popoverDatePickerComponent
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

                    /* when Datepicker is closed, is updated the date shown in the button */
                    Component.onDestruction: {
                        birthdayButton.text = Qt.formatDateTime(timePicker.date, "dd MMMM yyyy")
                    }
                }
            }
        }

        /* open the popOver component with DatePicker */
        Button {
            id: birthdayButton
            width: units.gu(18)
            text: personDetailsPage.personBirthday
            onClicked: {
                PopupUtils.open(popoverDatePickerComponent, birthdayButton)
            }
        }
    }

    //--------------- Tax Code --------------
    Row{
        id: taxCodeRow
        spacing: units.gu(2.6)

        Label {
            id: taxCodeFieldLabel
            anchors.verticalCenter: taxCodeField.verticalCenter
            text: i18n.tr("Tax code")+":"
        }

        TextField {
            id: taxCodeField
            placeholderText: ""
            text: personDetailsPage.personTaxCode
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(30)
            hasClearButton: false
        }
    }

    //--------------- Vat Code --------------
    Row{
        id:vatNumberRow
        spacing: units.gu(2.8)

        Label {
            id: vatNumberLabel
            anchors.verticalCenter: vatNumberField.verticalCenter
            text: i18n.tr("Vat code")+":"
        }

        TextField {
            id: vatNumberField
            placeholderText: ""
            text: personDetailsPage.personVatNumber
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(30)
            hasClearButton: false
        }
    }

    //--------------- Address --------------
    Row{
        id: addressRow
        spacing: units.gu(3.6)

        Label{
            id: addressLabel
            anchors.verticalCenter: addressField.verticalCenter
            text: i18n.tr("Address")+":"
        }

        TextField {
            id: addressField
            placeholderText: ""
            text: personDetailsPage.personAddress
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(30)
            hasClearButton: false
        }
    }

    //--------------- Phone --------------
    Row{
        id: phoneRow
        spacing: units.gu(5.4)

        Label{
            id: phoneLabel
            anchors.verticalCenter: phoneField.verticalCenter
            text: i18n.tr("Phone")+":"
        }

        TextField
        {
            id: phoneField
            placeholderText: ""
            text: personDetailsPage.personPhone
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(30)
            hasClearButton: false
        }
    }

    //---------- Mobile phone ------------
    Row{
        id: newMobilePhoneRow
        spacing: units.gu(5)

        Label {
            id: mobilePhoneLabel
            anchors.verticalCenter: mobilePhoneField.verticalCenter
            text: i18n.tr("Mobile")+":"
        }

        TextField
        {
            id: mobilePhoneField
            placeholderText: ""
            text: personDetailsPage.personMobilePhone
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(30)
            hasClearButton: false
        }
    }

    //---------- Email -------------
    Row{
        id: emailRow
        spacing: units.gu(6)

        Label {
            id: emailLabel
            anchors.verticalCenter: emailField.verticalCenter
            text: i18n.tr("Email")+":"
        }

        TextField {
            id: emailField
            placeholderText: ""
            text: personDetailsPage.personEmail
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(30)
            hasClearButton: false
        }
    }

    //---------- Skype -------------
    Row{
        spacing: units.gu(5.5)
        id: newSkypeRow

        Label {
            id: skypeLabel
            anchors.verticalCenter: skypeField.verticalCenter
            text: i18n.tr("Skype")+":"
        }

        TextField {
            id: skypeField
            placeholderText: ""
            text: personDetailsPage.personSkype
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(30)
            hasClearButton: false
        }
    }

    //---------- Telegram ----------
    Row{
        id: telegramRow
        spacing: units.gu(3)

        Label {
            id: telegramLabel
            anchors.verticalCenter: telegramField.verticalCenter
            text: i18n.tr("Telegram")+":"
        }

        TextField {
            id: telegramField
            placeholderText: ""
            text: personDetailsPage.personTelegram
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(30)
            hasClearButton: false
        }
    }

    //---------- Note -------------
    Row{
        id: noteRow
        spacing: units.gu(6)

        Label {
            id: noteLabel
            anchors.verticalCenter: noteTextArea.verticalCenter
            text: i18n.tr("Note")+":"
        }

        TextArea {
            id: noteTextArea
            textFormat:TextEdit.AutoText
            text: personDetailsPage.personNote
            height: units.gu(15)
            width: units.gu(30)
            readOnly: false
        }
    }

    Component {
        id: confirmUpdateDialog
        ConfirmUpdatePeople{}
    }

    Component {
        id: confirmDeleteDialog
        ConfirmDeletePeople{}
    }


    //------------- Command buttoms -------------
    Row{
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: units.gu(2)

        Rectangle {
            color: "transparent"
            width: units.gu(8)
            height: updateButton.height
        }

        Button {
            id: updateButton
            objectName: "Update"
            text: i18n.tr("Update")
            width: units.gu(12)
            color: UbuntuColors.red
            onClicked: {
                PopupUtils.open(confirmUpdateDialog,updateButton,{text: i18n.tr("Confirm the update ?")})
            }
        }

        Button {
            id: deleteButton
            objectName: "Delete"
            text: i18n.tr("Delete")
            width: units.gu(12)
            onClicked: {
                PopupUtils.open(confirmDeleteDialog, deleteButton,{text: i18n.tr("Delete person AND his meetings ?")})
            }
        }
    }


}
