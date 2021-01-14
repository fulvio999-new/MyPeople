import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

import "../../js/storage.js" as Storage
import "../../js/DateUtils.js" as DateUtils

 /*
    Item that display a meeting with a SPECIFIC person
    (Note: a delegate object can access directly a the values in the dataModel associated at the ListView or similar)
 */
 Item {
        property string todayDateFormatted : DateUtils.formatFullDateToString(new Date());

        id: peopleMeetingFoundDelegate
        width: parent.width
        height: units.gu(13) /* the heigth of the rectangle that contains a meeting in the list */

        /* meeting container */
        Rectangle {
            id: background
            x: 2;
            y: 2;
            width: parent.width - x*2;
            height: parent.height - y*1
            border.color: "black"
            radius: 5
            /* to get the background color of the curreunt theme. Necessary if default theme is not used */
            color: theme.palette.normal.background
        }

        Component {
            id: confirmDeleteMeetingComponent

            Dialog {
                id: confirmDeleteMeeting
                title: i18n.tr("Confirmation")
                modal:true
                text: i18n.tr("Delete selected Meeting ?")

                Label{
                    id: operationResultLabel
                    text: ""
                    color: UbuntuColors.green
                }

                Row{
                    spacing: units.gu(1)
                    anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        text: i18n.tr("Close")
                        width: units.gu(14)
                        onClicked: {
                            /* refresh and repeat the user search */
                            Storage.getTodayMeetings();
                            Storage.searchMeetingByTimeAndPerson(searchMeetingWithPersonPage.personName,searchMeetingWithPersonPage.personSurname,searchMeetingWithPersonPage.dateFrom,searchMeetingWithPersonPage.dateTo,searchMeetingWithPersonPage.meetingStatus);

                            PopupUtils.close(confirmDeleteMeeting)
                        }
                    }

                    Button {
                        id:executeButton
                        text: i18n.tr("Execute") //DELETE
                        width: units.gu(14)

                        onClicked: {
                            /* the 'id' of the selected meeting */
                            var meetingId = meetingWithPersonFoundModel.get(meetingSearchResultList.currentIndex).id;
                            Storage.deleteMeetingById(meetingId);
                            /* refresh */
                            Storage.getTodayMeetings();

                            operationResultLabel.text = i18n.tr("Operation executed successfully")
                            executeButton.enabled = false;
                         }
                    }
                }
            }
        }


        Component {
            id: confirmArchiveMeetingComponent

            Dialog {
                id: confirmArchiveMeeting
                title: i18n.tr("Confirmation")
                modal:true
                contentWidth: units.gu(47)

                Text {
                    anchors.horizontalCenter: parent.Center
                    text: "<b>"+ i18n.tr("Mark as 'ARCHIVED' and leave it in the database ?")  +"</b><br/>"
                                +"<br/>"+i18n.tr("(if you archive a meeting you can reuse it")+"<br/>"
                                +i18n.tr("in the future simply updating the date)")
                }

                Label{
                    id: operationResultLabel
                    text: ""
                    color: UbuntuColors.green
                }

                Row{
                    spacing: units.gu(1)
                    x: units.gu(5)

                    Button {
                        text: i18n.tr("Close")
                        width: units.gu(14)
                        onClicked: {
                            // Storage.searchMeetingByTimeAndPerson(peopleMeetingFoundDelegate.personName,peopleMeetingFoundDelegate.personSurname,peopleMeetingFoundDelegate.dateFrom,peopleMeetingFoundDelegate.dateTo,peopleMeetingFoundDelegate.meetingStatus);
                            Storage.searchMeetingByTimeAndPerson(searchMeetingWithPersonPage.personName,searchMeetingWithPersonPage.personSurname,searchMeetingWithPersonPage.dateFrom,searchMeetingWithPersonPage.dateTo,searchMeetingWithPersonPage.meetingStatus);

                            PopupUtils.close(confirmArchiveMeeting)
                        }
                    }

                    Button {
                        id:executeButton
                        width: units.gu(14)
                        text: i18n.tr("Execute") //ARCHIVE

                        onClicked: {
                            /* get the 'id' of the currently selected meeting */
                            var meetingId = meetingWithPersonFoundModel.get(meetingSearchResultList.currentIndex).id;

                            Storage.updateMeetingStatus(meetingId,i18n.tr("ARCHIVED"));

                            operationResultLabel.text = i18n.tr("Operation executed successfully")
                            executeButton.enabled = false;
                        }
                    }
                }
            }
        }


        /* This mouse region covers the entire delegate */
        MouseArea {
            id: selectableMouseArea
            anchors.fill: parent
            onClicked: {
                /* move the highlight component to the currently selected item */
                meetingSearchResultList.currentIndex = index
            }
        }

        /* create a row for each entry in the Model */
        Row {
            id: topLayout
            x: 10;
            y: 10;
            height: background.height;
            width: parent.width
            spacing: units.gu(0.5)

            Column {
                width: background.width - units.gu(2) - editMeetingColumn.width;
                height: peopleMeetingFoundDelegate.height
                spacing: units.gu(0.2)

                Label {
                      text: "<b>"+i18n.tr("Name")+": </b>"+name +"   <b>"+i18n.tr("Surname")+": </b>"+ surname
                      fontSize: "medium"
                }

                Label {
                    text: "<b>"+i18n.tr("Date")+" (yyyy-mm-dd): </b>"+date.split(' ')[0] + "  <b>"+i18n.tr("Time")+": </b>"+date.split(' ')[1]
                    fontSize: "medium"
                }

                Label {
                    text: "<b>"+i18n.tr("Place")+": </b>"+place
                    fontSize: "medium"
                }

                Label {
                    text: "<b>"+i18n.tr("Subject")+": </b>"+subject
                    fontSize: "medium"
                }

                Label {
                    id: meetingStatusLabel
                    text: "<b>"+i18n.tr("Meeting status")+": </b>"+"<b>"+status+"</b>"
                    fontSize: "medium"
                    color: "grey"
                }

                Component.onCompleted: {

                    /* if a meeting with status SCHEDULED and date greater than now is notified as SCHEDULED (expired) */
                    if(date < todayDateFormatted && status !== i18n.tr("ARCHIVED")) {
                       meetingStatusLabel.text =  meetingStatusLabel.text + " "+i18n.tr("(EXPIRED)")
                       meetingStatusLabel.color = "orange"
                    }
                }
            }

            Column{
                id: editMeetingColumn
                width: units.gu(5)
                anchors.verticalCenter: topLayout.verticalCenter
                spacing: units.gu(1)

                Row{
                    /* note: use Icon Object insted of Image to access at system default icon without specify a full path to image */
                    Icon {
                        id: editMeetingIcon
                        width: units.gu(3)
                        height: units.gu(3)
                        name: "edit"

                        MouseArea {
                            width: editMeetingIcon.width
                            height: editMeetingIcon.height
                            onClicked: {

                                  pageStack.push(Qt.resolvedUrl("EditMeetingPage.qml"),
                                                                       {
                                                                          /* <page-variable-name>:<property-value-to-pass> */
                                                                          id:id,
                                                                          name:name,
                                                                          surname:surname,
                                                                          subject:subject,
                                                                          date:date,
                                                                          place:place,
                                                                          status:status,
                                                                          note:note,
                                                                          isFromGlobalMeetingSearch:searchMeetingWithPersonPage.isFromGlobalMeetingSearch,
                                                                          dateFrom:searchMeetingWithPersonPage.dateFrom,
                                                                          dateTo:searchMeetingWithPersonPage.dateTo,
                                                                          meetingStatus:searchMeetingWithPersonPage.meetingStatus
                                                                        }
                                                    );

                             }
                        }

                    }
                }

                Row{
                    Icon {
                         id: deleteMeetingIcon
                         width: units.gu(3)
                         height: units.gu(3)
                         name: "delete"

                         MouseArea {
                              width: deleteMeetingIcon.width
                              height: deleteMeetingIcon.height
                              onClicked: {
                                  PopupUtils.open(confirmDeleteMeetingComponent);
                              }
                         }
                    }
                }

                Row{
                    id: archiveMeetingRow
                    Icon {
                         id: archiveMeetingIcon
                         width: units.gu(3)
                         height: units.gu(3)
                         name: "ok"

                         MouseArea {
                              width: archiveMeetingIcon.width
                              height: archiveMeetingIcon.height
                              onClicked: {
                                  PopupUtils.open(confirmArchiveMeetingComponent);
                              }
                         }
                      }
                      /* if the meeting is already marked as ARCHIVED hide the icons */
                      Component.onCompleted: {
                            if (status ==="ARCHIVED"){
                                archiveMeetingRow.visible = false
                           }
                      }
                }
            }
        }
    }
