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
import "DateUtils.js" as DateUtils

/*
  For TABLET: Component that allow to edit an already saved Meeting chosen from a ListModel
*/
Column {

    property string todayDateFormatted : DateUtils.formatFullDateToString(new Date());
    property string meetingStatus;  /* currently saved meeting status */
    property string meetingStatusToSave; /* the meeting status to save */
    property string meetingDate;
    property bool isFromGlobalMeetingSearch; /* flag to know the user search to repeat (global or user) */

    property string dateFrom;
    property string dateTo;

    id: editMeetingLayout
    anchors.fill: parent
    spacing: units.gu(2.5)
    anchors.leftMargin: units.gu(2)

    /* Only if the meeting is ARCHIVED is show a button to change the status bask to SCHEDULED status */
    onMeetingStatusChanged: {

      if(meetingStatus.indexOf("SCHEDULED") !== -1){ //if true == found
         changeStatusButton.visible = false;
         meetingStatusToSave = "SCHEDULED";
      }else{
         changeStatusButton.visible = true;
         /* the status must be manually changed with the dedicated button */
      }
    }

    /* to have a refresh of the meeting date Button */
    onMeetingDateChanged: {
       editMeetingDateButton.text = Qt.formatDateTime(meetingDate.split(' ')[0], "dd MMMM yyyy");
        meetingTimeButton.text = meetingDate.split(' ')[1].trim();
    }

    Rectangle{
        color: "transparent"
        width: parent.width
        height: units.gu(4)
    }

    Rectangle {
        id:statusContainer
        width: parent.width -units.gu(2);
        height: units.gu(4)
        border.color: "lightsteelblue"

        Button{
            id: changeStatusButton
            anchors.verticalCenter: statusContainer.verticalCenter
            height: statusContainer.height -units.gu(1)
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
            anchors.centerIn: parent
            text: editMeetingPage.status
        }
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
            width: units.gu(18)
            text: editMeetingPage.date.split(' ')[0].trim()
            onClicked: PopupUtils.open(popoverDatePickerComponent, editMeetingDateButton)
        }

        /* Create a PopOver conteining a DatePicker, use a PopOver as container due to a bug on setting minimum date
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
            onClicked: PopupUtils.open(popoverDatePickerComponent2, meetingTimeButton)
        }

        /* Create a PopOver with a DatePicker, necessary use a PopOver a container due to a 'bug' on setting minimum date
           with a simple DatePicker Component
        */
        Component {
            id: popoverDatePickerComponent2

            Popover {
                id: popoverDatePicker

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

        /* Ask a confirmation before updating a Meeting */
        Dialog {
            id: dialogue
            title: "Confirmation"
            modal:true

            property string meetingId;

            Button {
               text: i18n.tr("Cancel")
               onClicked: PopupUtils.close(dialogue)
            }

            Button {
                text: i18n.tr("Execute")
                onClicked: {
                    PopupUtils.close(dialogue)

                    /* compose the full date because in the UI come from two different components */
                    var meetingFullDate = editMeetingDateButton.text +" "+meetingTimeButton.text;

                    Storage.updateMeeting(nameField.text,surnameField.text,meetingSubjectField.text,meetingPlaceField.text,meetingFullDate,meetingNote.text,editMeetingPage.id,meetingStatusToSave);

                    PopupUtils.open(operationResultDialogue)

                    /* update today meetings in case of the user has edited meeting date */
                    Storage.getTodayMeetings();

                    /* repeat the user search depending with the user has made a all people meeting seartch or by pesron */
                    if(isFromGlobalMeetingSearch === false){
                        console.log("Repeat Search for user specific");
                        Storage.searchMeetingByTimeAndPerson(searchMeetingWithPersonPage.personName,searchMeetingWithPersonPage.personSurname,searchMeetingWithPersonPage.dateFrom,searchMeetingWithPersonPage.dateTo,searchMeetingWithPersonPage.meetingStatus);
                    }else{
                        console.log("Repeat Search for ALL user meetings");
                        Storage.searchMeetingByTimeRange(dateFrom,dateTo,meetingStatusToSave);
                    }

                    adaptivePageLayout.removePages(editMeetingPage)
                }
            }
        }
    }
}
