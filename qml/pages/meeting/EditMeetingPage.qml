import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0

import "../../js/storage.js" as Storage
import "../../js/utility.js" as Utility
import "../../js/DateUtils.js" as DateUtils


/*
  Edit an existing Meeting
*/
Page{
    id: editMeetingPage
    anchors.fill: parent

    property string todayDateFormatted : DateUtils.formatFullDateToString(new Date());

    /* the text to show in the message popUp */
    property string infoText: ""

    /* meeting info to edit */
    property string id; /* meetingId */
    property string name;
    property string surname;
    property string subject;
    property string date : "1970-01-01 00:00"; /* placeholder value */
    property string place;
    //property string status;
    property string note;
    property bool isFromGlobalMeetingSearch; /* true if the user has made meeting search with any people */
    /* info used to repeat the search */
    property string dateFrom;
    property string dateTo;
    property string meetingStatus; /* ie: SCHEDULED, ARCHIVED */
    property string meetingStatusToSave;

    header: PageHeader {
        id: headerEditExpensePage
        title: i18n.tr("Edit meeting with") +": "+ "<b>" +editMeetingPage.name +" "+ editMeetingPage.surname+"</b>"
    }

     Component.onCompleted: {
         console.log("Meeting status: "+meetingStatus);
         if(date < todayDateFormatted) {
             meetingStatusLabel.text = meetingStatus + " (" +i18n.tr("EXPIRED")+ ")"
         } else {
             meetingStatusLabel.text = meetingStatus
         }

         /* only for ARCHIVED meeting the user can "resume" them to SCHEDULED status.
         Meeting with status "SCHEDULED(EXPIRED)" are automatically passed to "SCHEDULED" settin a future date */
         if(meetingStatus.indexOf(i18n.tr("ARCHIVED")) !== -1){ //if true == found
            changeStatusButton.enabled = true;
            meetingStatusToSave = i18n.tr("SCHEDULED");
         }else{
            changeStatusButton.enabled = false;
            meetingStatusToSave = i18n.tr("SCHEDULED");
         }
     }

    Flickable {
        id: editMeetingPageFlickable
        clip: true
        contentHeight: Utility.getEditMeetingPageContentHeight()
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: editMeetingPage.bottom
            bottomMargin: units.gu(2)
        }

        /*
          Content of the EditMeeting page for PHONES
        */
        Column {
            id: editMeetingLayout
            anchors.fill: parent

            Rectangle{
                width: parent.width
                height: units.gu(8)
                /* to get the background color of the curreunt theme. Necessary if default theme is not used */
                color: theme.palette.normal.background
            }

            Rectangle {
                id:statusContainer
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - units.gu(4);
                height: units.gu(4)
                border.color: "lightsteelblue"
                /* to get the background color of the curreunt theme. Necessary if default theme is not used */
                color: theme.palette.normal.background

                Label {
                    id: meetingStatusLabel
                    anchors.centerIn: parent
                    text: editMeetingPage.meetingStatus
                    fontSize: Label.Small
                    anchors {
                       leftMargin: units.gu(3)
                       //rightMargin: units.gu(3)
                       right: parent.right
                       verticalCenter: parent.verticalCenter
                    }
                }

                /*  visible only for ARCHIVED meetings */
                Button{
                      id: changeStatusButton
                      anchors.verticalCenter: statusContainer.verticalCenter
                      anchors.leftMargin: units.gu(3)
                      height: units.gu(3)
                      width: units.gu(9)
                      text: i18n.tr("Change")
                      color: UbuntuColors.green
                      onClicked: {
                           meetingStatusToSave = i18n.tr("SCHEDULED");
                           meetingStatusLabel.text = meetingStatusLabel.text.replace(i18n.tr("ARCHIVED"),i18n.tr("SCHEDULED"))
                      }
                  }
            }

            ListItem{
                id: nameRow
                divider.visible: false

                Label {
                    id: nameLabel
                    text: i18n.tr("Name")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: nameField.verticalCenter
                   }
                }

                TextField {
                    id: nameField
                    text: editMeetingPage.name
                    echoMode: TextInput.Normal
                    width: units.gu(30)
                    hasClearButton: false
                    readOnly: true
                    anchors {
                       leftMargin: units.gu(1)
                       rightMargin: units.gu(2)
                       right: parent.right
                       verticalCenter: parent.verticalCenter
                    }
                }
            }

            ListItem{
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
                    placeholderText: ""
                    text: editMeetingPage.surname
                    echoMode: TextInput.Normal
                    width: units.gu(30)
                    hasClearButton: false
                    readOnly: true
                    anchors {
                          leftMargin: units.gu(1)
                          rightMargin: units.gu(2)
                          right: parent.right
                          verticalCenter: parent.verticalCenter
                    }
                }
            }

            ListItem{
                id: meetingSubjectRow
                divider.visible: false

                Label {
                    id:  meetingSubjectLabel
                    anchors.verticalCenter: meetingSubjectField.verticalCenter
                    text: i18n.tr("Subject")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: meetingSubjectField.verticalCenter
                   }
                }

                TextField {
                    id: meetingSubjectField
                    placeholderText: ""
                    text: editMeetingPage.subject
                    echoMode: TextInput.Normal
                    readOnly: false
                    width: units.gu(30)
                    hasClearButton: false
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }

            ListItem{
                id: meetingPlaceRow
                divider.visible: false

                Label {
                    id: meetingPlaceLabel
                    anchors.verticalCenter: meetingPlaceField.verticalCenter
                    text: i18n.tr("Place")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: meetingPlaceField.verticalCenter
                   }
                }

                TextField {
                    id: meetingPlaceField
                    placeholderText: ""
                    text: editMeetingPage.place
                    echoMode: TextInput.Normal
                    readOnly: false
                    width: units.gu(30)
                    hasClearButton: true
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }

            ListItem{
                id: meetingTimeRow
                divider.visible: false

                Label {
                    id: meetingDateLabel
                    anchors.verticalCenter: editMeetingDateButton.verticalCenter
                    text: i18n.tr("Date")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: editMeetingDateButton.verticalCenter
                   }
                }

                Button {
                    id: editMeetingDateButton
                    width: units.gu(18)
                    text: editMeetingPage.date.split(' ')[0].trim()
                    onClicked: PopupUtils.open(popoverDatePickerComponent, editMeetingDateButton)
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
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

            ListItem{
                id: timeRow
                divider.visible: false

                Label {
                    id: meetingTimeLabel
                    anchors.verticalCenter: meetingTimeButton.verticalCenter
                    text: i18n.tr("Time")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newBirthdayButton.verticalCenter
                   }
                }

                Button {
                    id: meetingTimeButton
                    text: editMeetingPage.date.split(' ')[1].trim()
                    onClicked: PopupUtils.open(popoverDatePickerComponent2, meetingTimeButton)
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
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

              ListItem{
                id: meetingObjectRow
                divider.visible: false
                height: units.gu(18)

                Label {
                    id: noteLabel
                    anchors.verticalCenter: meetingNote.verticalCenter
                    text: i18n.tr("Note")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newBirthdayButton.verticalCenter
                   }
                }

                TextArea {
                    id: meetingNote
                    textFormat:TextEdit.AutoText
                    text: editMeetingPage.note
                    height: units.gu(15)
                    width: units.gu(30)
                    readOnly: false
                    anchors {
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(2)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                    }
                }
            }

            ListItem{
                divider.visible: false

                Button {
                    id: saveButton
                    objectName: "update"
                    text: i18n.tr("Update")
                    color: UbuntuColors.orange
                    width: units.gu(18)
                    onClicked: {
                          /* check for chosen date: if the meeting is "SCHEDULED" and user choose a date lower than now,
                             notify that is not possbile: user is creating an already Expired meeting
                          */
                          if(! DateUtils.isMeetingDateValid(editMeetingDateButton.text,meetingTimeButton.text)){
                              infoText = "\n" + i18n.tr("Can't schedule to a passed date") + "\n";
                              PopupUtils.open(popover);
                              //console.log("You are SCHEDULING the meeting to a passed date");
                          } else {
                              PopupUtils.open(confirmUpdateMeetingDialog, saveButton,{text: i18n.tr("Update the meeting ?")})
                          }
                      }
                    anchors {
                        topMargin: units.gu(5)
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }

           /* Ask a confirmation before updating Meeting informations and/or status */
           Component {
                id: confirmUpdateMeetingDialog

                Dialog {
                    id: dialogue
                    title: i18n.tr("Confirmation")
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

                            console.log("Updating Meeting to status: "+meetingStatusToSave);
                            /* compose the full date because in the UI come from two different components */
                            var meetingFullDate = editMeetingDateButton.text +" "+meetingTimeButton.text;

                            Storage.updateMeeting(nameField.text,surnameField.text,meetingSubjectField.text,meetingPlaceField.text,meetingFullDate,meetingNote.text,editMeetingPage.id,meetingStatusToSave);

                            PopupUtils.open(operationResultDialogue)

                            /* update today meetings list, in case of the user has changed meeting date */
                            Storage.getTodayMeetings();

                            /* repeat the user search using the criteria provided in 'search all' o 'search with person' forms */
                            if(editMeetingPage.isFromGlobalMeetingSearch === false){
                                //console.log("Repeat Search for user specific");
                                Storage.searchMeetingByTimeAndPerson(nameField.text,surnameField.text,dateFrom,dateTo,meetingStatusToSave);
                            }else{
                                //console.log("Repeat Search for ALL user meetings, dateFrom: "+dateFrom+ "dateTo: "+dateTo+ " status: "+meetingStatusToSave);
                                Storage.searchMeetingByTimeRange(dateFrom,dateTo,meetingStatusToSave);
                            }

                            pageStack.pop(editMeetingPage)
                        }
                    }
                }
            }

            /* To notify messages at the user */
            Component {
                 id: popover
                 Dialog {
                     id: po
                     text: "<b>"+infoText+"</b>"
                     MouseArea {
                        anchors.fill: parent
                        onClicked: PopupUtils.close(po)
                     }
                 }
            }
        }
    }


    /* To show a scrolbar on the side */
    Scrollbar {
        flickableItem: editMeetingPageFlickable
        align: Qt.AlignTrailing
    }
}
