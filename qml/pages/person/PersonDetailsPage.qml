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
import "../../js/screenUtils.js" as ScreenUtils

/* import folder */
import "../../dialogs"


//-------------------- PERSON DETAILS PAGE -------------------------------
Page{
    id:personDetailsPage

    anchors.fill: parent

    /* Values passed as input properties when the AdaptiveLayout add the details page (See: PeopleListDelegate.qml)
       Are the details of the selected person in the people list used to fill the TextField
    */
    property string id  /* PK Person Id (not shown) */
    property string personName;
    property string personSurname
    property string personPhone
    property string personEmail
    property string personJob
    property string personTaxCode
    property string personVatNumber
    property string personBirthday
    property string personAddress
    property string personSkype
    property string personTelegram
    property string personMobilePhone
    property string personNote

    header: PageHeader {
        id: headerDetailsPage
        title: i18n.tr("Person details") //personDetailsPage.personName + "<br> "+personDetailsPage.personSurname+"<\b>"
    }

    Component {
        id: confirmUpdateDialog
        ConfirmUpdatePeople{}
    }

    Component {
        id: confirmDeleteDialog
        ConfirmDeletePeople{}
    }

    /* to have a scrollable column when the keyboard cover some input field */
    Flickable {
        id: personDetailsFlickable
        clip: true
        contentHeight: personDetailPageColumn.height + units.gu(5)
        anchors {
             top: parent.top
             left: parent.left
             right: parent.right
             bottom: commandButtonRow.top
             bottomMargin: units.gu(2)
        }

        Column {
            id: personDetailPageColumn
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: units.gu(1)
            }

            Rectangle {
                /* to get the background color of the curreunt theme. Necessary if default theme is not used */
                color: theme.palette.normal.background
                width: parent.width
                height: units.gu(6)
            }

            ListItem{
                id: newNameRow
                divider.visible: false

                Label {
                    id: nameLabel
                    text:  i18n.tr("Name")+":"
                    anchors {
                        leftMargin: units.gu(1)
                        left: parent.left
                        verticalCenter: nameField.verticalCenter
                   }
                }

                TextField {
                    id: nameField
                    text: personDetailsPage.personName
                    inputMethodHints: Qt.ImhNoPredictiveText
                    echoMode: TextInput.Normal
                    width: units.gu(27)
                    hasClearButton: false
                    /*  Dummy solution to have a refresh of the 'birthdayButton' when user select another person
                        all the other text field are update in auto; 'birthdayButton' is not refreshed (bug?)
                    */
                    //onTextChanged: {
                    //    birthdayButton.text = personDetailsPage.personBirthday
                    //}
                    anchors {
                       leftMargin: units.gu(0.5)
                       rightMargin: units.gu(1)
                       right: parent.right
                       verticalCenter: parent.verticalCenter
                    }
                }
            }


            ListItem{
                id: newSurnameRow
                divider.visible: false

                Label {
                    id: surnameLabel
                    anchors.verticalCenter: surnameField.verticalCenter
                    text: i18n.tr("Surname")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: surnameField.verticalCenter
                   }
                }

                TextField {
                    id: surnameField
                    inputMethodHints: Qt.ImhNoPredictiveText
                    text: personDetailsPage.personSurname
                    echoMode: TextInput.Normal
                    width: units.gu(27)
                    hasClearButton: false
                    anchors {
                          leftMargin: units.gu(0.5)
                          rightMargin: units.gu(1)
                          right: parent.right
                          verticalCenter: parent.verticalCenter
                    }
                }
            }

            ListItem{
                id: newJobRow
                divider.visible: false

                Label {
                    id: categoryLabel
                    text: i18n.tr("Job")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: jobField.verticalCenter
                   }
                }

                TextField {
                    id: jobField
                    inputMethodHints: Qt.ImhNoPredictiveText
                    text: personDetailsPage.personJob
                    echoMode: TextInput.Normal
                    width: units.gu(27)
                    hasClearButton: false
                    anchors {
                          leftMargin: units.gu(0.5)
                          rightMargin: units.gu(1)
                          right: parent.right
                          verticalCenter: parent.verticalCenter
                    }
                }
            }

            ListItem{
                id:newBirthdayRow
                divider.visible: false

                Label {
                    id: birthdayLabel
                    text: i18n.tr("Birthday")+":"
                    anchors {
                        leftMargin: units.gu(1)
                        left: parent.left
                        verticalCenter: birthdayButton.verticalCenter
                   }
                }

                /*
                   Create a PopOver containing a DatePicker, necessary use a PopOver a container due to a bug on setting minimum date
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
                    anchors {
                          leftMargin: units.gu(0.5)
                          rightMargin: units.gu(1)
                          right: parent.right
                          verticalCenter: parent.verticalCenter
                    }
                }
            }

            ListItem{
                id: newTaxCodeRow
                divider.visible: false

                Label {
                    id: taxCodeFieldLabel
                    text: i18n.tr("Tax code")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: taxCodeField.verticalCenter
                   }
                }

                TextField {
                    id: taxCodeField
                    inputMethodHints: Qt.ImhNoPredictiveText
                    text: personDetailsPage.personTaxCode
                    echoMode: TextInput.Normal
                    width: units.gu(27)
                    hasClearButton: false
                    anchors {
                          leftMargin: units.gu(0.5)
                          rightMargin: units.gu(1)
                          right: parent.right
                          verticalCenter: parent.verticalCenter
                    }
                }
            }


            ListItem{
                id:newVatNumberRow
                divider.visible: false

                Label {
                    id: vatNumberLabel
                    text: i18n.tr("Vat code")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: vatNumberField.verticalCenter
                   }
                }

                TextField {
                    id: vatNumberField
                    text: personDetailsPage.personVatNumber
                    echoMode: TextInput.Normal
                    inputMethodHints: Qt.ImhNoPredictiveText
                    width: units.gu(27)
                    anchors {
                            leftMargin: units.gu(0.5)
                            rightMargin: units.gu(1)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }


            ListItem{
                id: newAddressRow
                divider.visible: false

                Label{
                    id: addressLabel
                    text: i18n.tr("Address")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: addressField.verticalCenter
                   }
                }

                TextField {
                    id: addressField
                    text: personDetailsPage.personAddress
                    echoMode: TextInput.Normal
                    inputMethodHints: Qt.ImhNoPredictiveText
                    width: units.gu(27)
                    anchors {
                            leftMargin: units.gu(0.5)
                            rightMargin: units.gu(1)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }


            ListItem{
                id: newPhoneRow
                divider.visible: false

                Label{
                    id: phoneLabel
                    anchors.verticalCenter: phoneField.verticalCenter
                    text: i18n.tr("Phone")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: phoneField.verticalCenter
                   }
                }

                TextField
                {
                    id: phoneField
                    inputMethodHints: Qt.ImhNoPredictiveText
                    text: personDetailsPage.personPhone
                    echoMode: TextInput.Normal
                    width: units.gu(27)
                    anchors {
                          leftMargin: units.gu(0.5)
                          rightMargin: units.gu(1)
                          right: parent.right
                          verticalCenter: parent.verticalCenter
                    }
                }
            }


            ListItem{
                id: newMobilePhoneRow
                divider.visible: false

                Label {
                    id: mobilePhoneLabel
                    text: i18n.tr("Mobile")+":"
                    anchors {
                        leftMargin: units.gu(1)
                        left: parent.left
                        verticalCenter: mobilePhoneField.verticalCenter
                   }
                }

                TextField
                {
                    id: mobilePhoneField
                    inputMethodHints: Qt.ImhNoPredictiveText
                    text: personDetailsPage.personMobilePhone
                    echoMode: TextInput.Normal
                    width: units.gu(27)
                    anchors {
                          leftMargin: units.gu(0.5)
                          rightMargin: units.gu(1)
                          right: parent.right
                          verticalCenter: parent.verticalCenter
                    }
                }
            }


            ListItem{
                id: newEmailRow
                divider.visible: false

                Label {
                    id: emailLabel
                    text: i18n.tr("Email")+":"
                    anchors {
                        leftMargin: units.gu(1)
                        left: parent.left
                        verticalCenter: emailField.verticalCenter
                   }
                }

                TextField {
                    id: emailField
                    text: personDetailsPage.personEmail
                    echoMode: TextInput.Normal
                    width: units.gu(27)
                    inputMethodHints: Qt.ImhNoPredictiveText
                    anchors {
                          leftMargin: units.gu(0.5)
                          rightMargin: units.gu(1)
                          right: parent.right
                          verticalCenter: parent.verticalCenter
                    }
                }
            }


            ListItem{
                id: newSkypeRow
                divider.visible: false

                Label {
                    id: skypeLabel
                    text: i18n.tr("Skype")+":"
                    anchors {
                        leftMargin: units.gu(1)
                        left: parent.left
                        verticalCenter: skypeField.verticalCenter
                   }
                }

                TextField {
                    id: skypeField
                    text: personDetailsPage.personSkype
                    echoMode: TextInput.Normal
                    width: units.gu(27)
                    inputMethodHints: Qt.ImhNoPredictiveText
                    anchors {
                          leftMargin: units.gu(0.5)
                          rightMargin: units.gu(1)
                          right: parent.right
                          verticalCenter: parent.verticalCenter
                    }
                }
            }


            ListItem{
                id: newTelegramRow
                divider.visible: false

                Label {
                    id: telegramLabel
                    text: i18n.tr("Telegram")+":"
                    anchors {
                        leftMargin: units.gu(1)
                        left: parent.left
                        verticalCenter: telegramField.verticalCenter
                   }
                }

                TextField {
                    id: telegramField
                    text: personDetailsPage.personTelegram
                    echoMode: TextInput.Normal
                    width: units.gu(27)
                    inputMethodHints: Qt.ImhNoPredictiveText
                    anchors {
                          leftMargin: units.gu(0.5)
                          rightMargin: units.gu(1)
                          right: parent.right
                          verticalCenter: parent.verticalCenter
                    }
                }
            }


            ListItem{
                id: newNoteRow
                divider.visible: false
                height: units.gu(18)

                Label {
                    id: noteLabel
                    text: i18n.tr("Note")+":"
                    anchors {
                        leftMargin: units.gu(1)
                        left: parent.left
                        verticalCenter: noteTextArea.verticalCenter
                   }
                }

                TextArea {
                    id: noteTextArea
                    textFormat:TextEdit.AutoText
                    text: personDetailsPage.personNote
                    height: units.gu(15)
                    width: units.gu(27)
                    anchors {
                          leftMargin: units.gu(0.5)
                          rightMargin: units.gu(1)
                          right: parent.right
                          verticalCenter: parent.verticalCenter
                    }
                }
            }

        } //col

    } //flick

    //------------- Command buttoms -------------
    Row{
        id: commandButtonRow
        spacing:units.gu(2)
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            margins: units.gu(2)
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

    /* To show a scrollbar on the side */
    Scrollbar {
        flickableItem: personDetailsFlickable
        align: Qt.AlignTrailing
    }
}
