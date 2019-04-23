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
 PHONE Layout, Used in Main.qml to create a NEW meetimg wit a specific person. Used for Tablet

*/
Column {

    id: newMeetingwithPersonLayout
    anchors.fill: parent
    spacing: units.gu(3)
    anchors.leftMargin: units.gu(2)

    Rectangle{
        color: "transparent"
        width: parent.width
        height: units.gu(6)
    }

    Row{
        id: nameRow
        spacing: units.gu(4.5)

        //------------- Name --------------
        Label {
            id: nameLabel
            anchors.verticalCenter: nameField.verticalCenter
            text: i18n.tr("Name")+":"
        }

        TextField {
            id: nameField
            text: createMeetingWithPersonPage.personName
            placeholderText: ""
            echoMode: TextInput.Normal
            width: units.gu(35)
            hasClearButton: false
            readOnly: true

            /*  To clean input fields when user choose another person */
            onTextChanged: {
                meetingPlaceField.text = ""
                newMeetingNote.text = ""
                meetingSubjectField.text = ""
            }
        }
    }

    Row{
        spacing: units.gu(2)
        //------------- Surname --------------
        Label {
            id: surnameLabel
            anchors.verticalCenter: surnameField.verticalCenter
            text: i18n.tr("Surname")+":"
        }

        TextField {
            id: surnameField
            placeholderText: ""
            text: createMeetingWithPersonPage.personSurname
            echoMode: TextInput.Normal
            width: units.gu(35)
            hasClearButton: false
            readOnly: true
        }
    }


    Row{
        id: meetingSubjectRow
        spacing: units.gu(2.5)

        //------------- Subject --------------
        Label {
            id:  meetingSubjectLabel
            anchors.verticalCenter: meetingSubjectField.verticalCenter
            text: i18n.tr("Subject")+":"
        }

        TextField {
            id: meetingSubjectField
            placeholderText: ""
            text: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(35)
            hasClearButton: false
        }
    }


    Row{
        id: meetingPlaceRow
        spacing: units.gu(4)

        //------------- Place --------------
        Label {
            id:  meetingPlaceLabel
            anchors.verticalCenter: meetingPlaceField.verticalCenter
            text: i18n.tr("Place")+":"
        }

        TextField {
            id: meetingPlaceField
            placeholderText: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(35)
            hasClearButton: false
        }
    }


    Row{
        id: meetingTimeRow
        spacing: units.gu(4.5)

        //------------- Date --------------
        Label {
            id: newBirthdayLabel
            anchors.verticalCenter: newMeetingDateButton.verticalCenter
            text: i18n.tr("Date")+":"
        }

        Button {
            id: newMeetingDateButton
            property date date: new Date()
            text: Qt.formatDateTime(date, "dd MMMM yyyy")
            width: units.gu(18)
            //Don't use the PickerPanel api because doesn't allow to set minum date
            onClicked: PopupUtils.open(newPopoverDatePickerComponent, newMeetingDateButton)
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
                        newMeetingDateButton.text = Qt.formatDateTime(timePicker.date, "dd MMMM yyyy")
                    }
                }
            }
        }
     }

     Row{
        id: timeRow
        spacing: units.gu(4.5)

        //------------- Time --------------
        Label {
            id: newMeetingTimeLabel
            anchors.verticalCenter: newMeetingTimeButton.verticalCenter
            text: i18n.tr("Time")+":"
        }

        Button {
            id: newMeetingTimeButton
            property date date: new Date()
            text: Qt.formatDateTime(date, "hh:mm")
            //Don't use the PickerPanel api because doesn't allow to set minum date
            onClicked: PopupUtils.open(newPopoverDatePickerComponent2, newMeetingTimeButton)
        }

        /* Create a PopOver conteining a DatePicker, necessary use a PopOver a container due to a bug on setting minimum date
               with a simple DatePicker Component
        */
        Component {
            id: newPopoverDatePickerComponent2

            Popover {
                id: popoverDatePicker
                //contentWidth: units.gu(25)

                DatePicker {
                    id: timePicker
                    mode: "Hours|Minutes"
                    minimum: {
                        var time = new Date()
                        time.setFullYear(1900)
                        return time
                    }

                    Component.onDestruction: {
                        newMeetingTimeButton.text = Qt.formatDateTime(timePicker.date, "hh:mm")
                    }
                }
            }
        }
    }

    Row{
        id: meetingObjectRow
        spacing: units.gu(4)

        //------------- Note --------------
        Label {
            id: noteLabel
            anchors.verticalCenter: newMeetingNote.verticalCenter
            text: i18n.tr("Note")+":"
        }

        TextArea {
            id: newMeetingNote
            textFormat:TextEdit.AutoText
            text: ""
            height: units.gu(15)
            width: units.gu(35)
            readOnly: false
        }
    }


    Row{
        x: newMeetingwithPersonLayout.width/3

        Button {
            id: saveButton
            objectName: "save"
            text: i18n.tr("Save")
            width: units.gu(18)
            onClicked: {
                PopupUtils.open(confirmInsertMeetingDialog, saveButton,{text: i18n.tr("Save the new meeting ?")})
            }
        }
    }

    Component {
        id: confirmInsertMeetingDialog
        ConfirmInsertMeeting{}
    }
}
