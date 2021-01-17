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
import "../../js/DateUtils.js" as DateUtils

/* import folder */
import "../../dialogs"

/*
   CREATE A NEW MEETING WITH the selected person in the People listed
*/
Page{
    id:createMeetingWithPersonPage

    anchors.fill: parent

    /* values passed when the user has chosen a people in the  people list */
    property string id  /* PK field not shown */
    property string personName;
    property string personSurname

    /* the text to show in the message popUp */
    property string infoText: ""

    header: PageHeader {
        id: headerAddMeetingPage
        title: i18n.tr("new meeting with")+ ": " + "<b>"+createMeetingWithPersonPage.personName + " "+createMeetingWithPersonPage.personSurname+"<\b>"
    }

    /* to have a scrollable column when the keyboard cover some input field */
    Flickable {
        id: createMeetingWithPersonPageFlickable
        clip: true
        contentHeight: Utility.getNewMeetingContentHeight()
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: createMeetingWithPersonPage.bottom
            bottomMargin: units.gu(2)
        }

        Column {

            id: newMeetingwithPersonLayout
            anchors.fill: parent
            spacing: units.gu(3)
            //anchors.leftMargin: units.gu(2)

            Rectangle{
                color: "transparent"
                width: parent.width
                height: units.gu(6)
            }

            ListItem{
                id: newNameRow
                divider.visible: false

                //------------- Name --------------
                Label {
                    id: nameLabel
                    anchors.verticalCenter: nameField.verticalCenter
                    text: i18n.tr("Name")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: nameField.verticalCenter
                   }
                }

                TextField {
                    id: nameField
                    text: createMeetingWithPersonPage.personName
                    placeholderText: ""
                    echoMode: TextInput.Normal
                    width: units.gu(30)
                    readOnly: true
                    anchors {
                       leftMargin: units.gu(1)
                       rightMargin: units.gu(2)
                       right: parent.right
                       verticalCenter: parent.verticalCenter
                    }

                    /*  To clean input fields when user choose another person */
                    onTextChanged: {
                        meetingPlaceField.text = ""
                        newMeetingNote.text = ""
                        meetingSubjectField.text = ""
                    }
                }
            }

            ListItem{
                id: newSurnameRow
                divider.visible: false
                //------------- Surname --------------
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
                    text: createMeetingWithPersonPage.personSurname
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
                    text: i18n.tr("Subject")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: meetingSubjectField.verticalCenter
                   }
                }

                TextField {
                    id: meetingSubjectField
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

                //------------- Place --------------
                Label {
                    id:  meetingPlaceLabel
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
                id: meetingDateRow
                divider.visible: false

                //------------- Date --------------
                Label {
                    id: meetingDateLabel
                    text: i18n.tr("Date")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newMeetingDateButton.verticalCenter
                   }
                }

                Button {
                    id: newMeetingDateButton
                    property date date: new Date()
                    text: Qt.formatDateTime(date, "dd MMMM yyyy")
                    width: units.gu(18)
                    //Don't use the PickerPanel api because doesn't allow to set minum date
                    onClicked: PopupUtils.open(newPopoverDatePickerComponent, newMeetingDateButton)
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
                                newMeetingDateButton.text = Qt.formatDateTime(timePicker.date, "dd MMMM yyyy")
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

             ListItem{
                 id: timeRow
                 divider.visible: false

                //------------- Time --------------
                Label {
                    id: newMeetingTimeLabel
                    text: i18n.tr("Time")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newMeetingTimeButton.verticalCenter
                   }
                }

                Button {
                    id: newMeetingTimeButton
                    property date date: new Date()
                    text: Qt.formatDateTime(date, "hh:mm")
                    //Don't use the PickerPanel api because doesn't allow to set minum date
                    onClicked: PopupUtils.open(newPopoverDatePickerComponent2, newMeetingTimeButton)
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
                    id: newPopoverDatePickerComponent2

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
                                newMeetingTimeButton.text = Qt.formatDateTime(timePicker.date, "hh:mm")
                            }
                        }
                    }
                }
            }

            ListItem{
                id: meetingObjectRow
                height: units.gu(18)
                divider.visible: false

                //------------- Note --------------
                Label {
                    id: noteLabel
                    text: i18n.tr("Note")+":"
                    anchors {
                       leftMargin: units.gu(1)
                       left: parent.left
                       verticalCenter: newMeetingNote.verticalCenter
                   }
                }

                TextArea {
                    id: newMeetingNote
                    textFormat:TextEdit.AutoText
                    text: ""
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
                    objectName: "save"
                    text: i18n.tr("Save")
                    color: UbuntuColors.orange
                    width: units.gu(18)
                    onClicked: {
                        /* check for chosen date: Is no possible schedule a meeting with a passed date-time */
                        if(! DateUtils.isMeetingDateValid(newMeetingDateButton.text,newMeetingTimeButton.text)){
                            infoText = "\n" + i18n.tr("Can't schedule to a passed date") + "\n";
                            PopupUtils.open(popover);
                            //console.log("You are SCHEDULING the meeting to a passed date");
                        } else {
                           PopupUtils.open(confirmInsertMeetingDialog, saveButton,{text: i18n.tr("Save the new meeting ?")})
                        }
                    }
                    anchors {
                        top: meetingObjectRow.bottom
                        topMargin: units.gu(5)
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            Component {
                id: confirmInsertMeetingDialog
                ConfirmInsertMeeting{}
            }
        }
    }

    /* To show a scrollbar on the side */
    Scrollbar {
        flickableItem: createMeetingWithPersonPageFlickable
        align: Qt.AlignTrailing
    }
}
