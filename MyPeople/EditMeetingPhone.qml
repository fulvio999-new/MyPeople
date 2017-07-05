import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

/* note: alias name must have first letter in upperCase */
import "utility.js" as Utility
import "storage.js" as Storage

/*
  For PHONE: Component that allow to edit an already saved Meeting chosen from a ListModel
*/
Column {

    property string todayDateFormatted : Storage.formatFullDateToString(new Date());
    property string meetingStatus;  /* currently saved meeting status */
    property string meetingStatusToSave; /* the meeting status to save */

    id: editMeetingLayout
    anchors.fill: parent
    spacing: units.gu(2.5)
    anchors.leftMargin: units.gu(2)


    /* ONLY for ARCHIVED meeting the user must change manually the status.
       For 'SCHEDULED (EXPIRED)' meetings is only necessary set his start date to a future one
       to automatically place the meeting to SCHEDULED status.
    */
    onMeetingStatusChanged: {

      if(meetingStatus.indexOf("SCHEDULED") !== -1){ //if true == found
         changeStatusButton.visible = false;
         meetingStatusToSave = "SCHEDULED";
      }else{
         changeStatusButton.visible = true;
         /* the status must be manually change with the dedicated button */
      }
    }

    Rectangle{
        color: "transparent"
        width: parent.width
        height: units.gu(5)
    }

    Row{
        spacing: units.gu(4.5)

        Button{
            id: changeStatusButton
            height: units.gu(3)
            text: i18n.tr("Change status")
            color: UbuntuColors.green
            onClicked: {

                if(meetingStatusLabel.text.indexOf("ARCHIVED") !== -1){  //true if "ARCHIVED" is found

                   meetingStatusToSave = "SCHEDULED";
                   meetingStatusLabel.text = meetingStatusLabel.text.replace("ARCHIVED","SCHEDULED")
                }

                else if(meetingStatusLabel.text.indexOf("SCHEDULED") !== -1){  //true "SCHEDULED" is found
                   meetingStatusToSave = "ARCHIVED";
                   meetingStatusLabel.text = meetingStatusLabel.text.replace("SCHEDULED","ARCHIVED")
                }
            }
        }

        Label {            
            id: meetingStatusLabel           
            anchors.verticalCenter: changeStatusButton.verticalCenter
            text: editMeetingPage.status
        }      
    }


    /* line separator */
    Rectangle {
         color: "grey"
         width: editMeetingLayout.width //units.gu(100)
         anchors.horizontalCenter: parent.horizontalCenter
         height: units.gu(0.1)
    }


    Row{
        id: nameRow
        spacing: units.gu(4.5)

        Label {
            id: nameLabel
            anchors.verticalCenter: nameField.verticalCenter
            text: i18n.tr("Name:")
        }

        TextField {
            id: nameField
            text: editMeetingPage.name
            placeholderText: ""
            echoMode: TextInput.Normal
            width: units.gu(35)
            hasClearButton: false
            readOnly: true
        }
     }

     Row{
        spacing: units.gu(2)

        Label {
            id: surnameLabel
            anchors.verticalCenter: surnameField.verticalCenter
            text: i18n.tr("Surname:")
        }

        TextField {
            id: surnameField
            placeholderText: ""
            text: editMeetingPage.surname
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
            text: i18n.tr("Subject:")
        }

        TextField {
            id: meetingSubjectField
            placeholderText: ""
            text: editMeetingPage.subject
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(35)
            hasClearButton: false
        }
    }

    Row{
        id: meetingPlaceRow
        spacing: units.gu(4)

        Label {
            id: meetingPlaceLabel
            anchors.verticalCenter: meetingPlaceField.verticalCenter
            text: i18n.tr("Place:")
        }

        TextField {
            id: meetingPlaceField
            placeholderText: ""
            text: editMeetingPage.place
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(35)
            hasClearButton: true
        }
    }

    Row{
        id: meetingTimeRow
        spacing: units.gu(4.5)

        Label {
            id: meetingDateLabel
            anchors.verticalCenter: editMeetingDateButton.verticalCenter
            text: i18n.tr("Date:")
        }

        Button {
            id: editMeetingDateButton
            property date date: new Date()
            text: Qt.formatDateTime(editMeetingPage.date.split(' ')[0], "dd MMMM yyyy")
            width: units.gu(18)
            //Don't use the PickerPanel api because doesn't allow to set minum date
            onClicked: PopupUtils.open(popoverDatePickerComponent, editMeetingDateButton)
        }

        /* Create a PopOver conteining a DatePicker, necessary use a PopOver a container due to a bug on setting minimum date
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

                    Component.onDestruction: {
                        editMeetingDateButton.text = Qt.formatDateTime(timePicker.date, "dd MMMM yyyy")
                    }
                }
            }
        }
    }

    Row{
        id: timeRow
        spacing: units.gu(4.5)

        Label {
            id: meetingTimeLabel
            anchors.verticalCenter: meetingTimeButton.verticalCenter
            text: i18n.tr("Time:")
        }

        Button {
            id: meetingTimeButton
            text: editMeetingPage.date.split(' ')[1].trim()
            //Don't use the PickerPanel api because doesn't allow to set minum date
            onClicked: PopupUtils.open(popoverDatePickerComponent2, meetingTimeButton)
        }

        /* Create a PopOver conteining a DatePicker, necessary use a PopOver a container due to a bug on setting minimum date
               with a simple DatePicker Component
        */
        Component {
            id: popoverDatePickerComponent2

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
                        meetingTimeButton.text = Qt.formatDateTime(timePicker.date, "hh:mm")
                    }
                }
            }
        }
    }

    Row{
        id: meetingObjectRow
        spacing: units.gu(4)

        Label {
            id: noteLabel
            anchors.verticalCenter: meetingNote.verticalCenter
            text: i18n.tr("Note:")
        }

        TextArea {
            id: meetingNote
            textFormat:TextEdit.AutoText
            text: editMeetingPage.note
            height: units.gu(13)
            width: units.gu(35)
            readOnly: false
        }
    }

    Row{
        x: editMeetingLayout.width/3

        Button {
            id: saveButton
            objectName: "update"
            text: i18n.tr("Update")
            width: units.gu(18)
            onClicked: {
                PopupUtils.open(confirmUpdateMeetingDialog, saveButton,{text: i18n.tr("Update the meeting ?")})
            }
        }
    }

    Component {
        id: confirmUpdateMeetingDialog
        ConfirmUpdateMeeting{ meetingId:editMeetingPage.id }
    }
}
