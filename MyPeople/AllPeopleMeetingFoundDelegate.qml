import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

import "./storage.js" as Storage

 /*
    Item that display a meeting item retrieved from the database.
    Used to diplay the search result for meetings with ANY people
    (Note: a delegate object can access directly ath values in the dataModel)
 */
 Item {
        property string todayDateFormatted : Storage.formatFullDateToString(new Date());

        id: allPeopleMeetingFoundDelegate
        width: searchAnyMeetingPage.width
        height: units.gu(13) /* the heigth of the rectangle that contains an meeting in the list */

        /* container for each meeting */
        Rectangle {
            id: background
            x: 2;
            y: 2;
            width: parent.width - x*2;
            height: parent.height - y*1
            border.color: "black"
            radius: 5
        }

        Component {
            id: confirmDeleteMeetingComponent          
            Dialog {
                id: confirmDeleteExpense
                title: i18n.tr("Confirmation")
                modal:true
                text: i18n.tr("Delete selected Meeting ?")

                Label{
                    id: operationResultLabel
                    text: ""
                    color: UbuntuColors.green
                }

                Button {
                    text: i18n.tr("Close")
                    onClicked: PopupUtils.close(confirmDeleteExpense)
                }

                Button {
                    id:executeButton
                    text: i18n.tr("Execute")

                    onClicked: {
                        /* from ListModel get the 'id' of the currently selected meeting */
                        var meetingId = allPeopleMeetingFoundModel.get(allPeopleMeetingSearchResultList.currentIndex).id;
                        Storage.deleteMeetingById(meetingId);

                        operationResultLabel.text = i18n.tr("Operation executed successfully")
                        executeButton.enabled = false;

                        //TODO: refresh list
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
                                +i18n.tr("in the future simply updating it)")

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
                        onClicked: PopupUtils.close(confirmArchiveMeeting)
                    }

                    Button {
                        id:executeButton
                        width: units.gu(14)
                        text: i18n.tr("Execute")

                        onClicked: {
                            /* from ListModel get the 'id' of the currently selected meeting */
                            var meetingId = allPeopleMeetingFoundModel.get(allPeopleMeetingSearchResultList.currentIndex).id;
                            Storage.updateMeetingStatus(meetingId,"ARCHIVED");

                            operationResultLabel.text = i18n.tr("Operation executed successfully")
                            executeButton.enabled = false;

                            //TODO: refresh list
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
                allPeopleMeetingSearchResultList.currentIndex = index
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
                width: background.width - 10 - editMeetingColumn.width;
                height: allPeopleMeetingFoundDelegate.height
                spacing: units.gu(0.2)

                Label {
                      text: "<b>Name: </b>"+name +"   <b>Surname: </b>"+ surname
                      fontSize: "medium"
                }

                Label {
                    text: "<b>Date (yyyy-mm-dd): </b>"+date.split(' ')[0] + "  <b>Time: </b>"+date.split(' ')[1]
                    fontSize: "medium"
                }

                Label {
                    text: "<b>Place: </b>"+place
                    fontSize: "medium"
                }

                Label {
                    text: "<b>Subject: </b>"+subject
                    fontSize: "medium"
                }

                Label {
                    id: meetingStatusLabel
                    text: "<b>Meeting status: </b>"+"<b>"+status+"</b>"
                    fontSize: "medium"
                    color: "grey"
                }

                Component.onCompleted: {

                    /* if a meeting with status TODO and date greater than now is notified as expired */
                    if(date < todayDateFormatted && status !== 'ARCHIVED') {
                       meetingStatusLabel.text =  meetingStatusLabel.text + " (EXPIRED)"
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
                    /* note: use Icon Object insted of Image to access at sytem default icon without specify a full path to image */
                    Icon {
                        id: editMeetingIcon
                        width: units.gu(3)
                        height: units.gu(3)
                        name: "edit"

                        MouseArea {
                            width: editMeetingIcon.width
                            height: editMeetingIcon.height
                            onClicked: {
                                adaptivePageLayout.addPageToNextColumn(searchAnyMeetingPage, editMeetingPage,
                                                                       {
                                                                          /* <page-variable-name>:<property-value-to-pass> */
                                                                          id:id,
                                                                          name:name,
                                                                          surname:surname,
                                                                          subject:subject,
                                                                          date:date,
                                                                          place:place,
                                                                          status: meetingStatusLabel.text,
                                                                          note:note
                                                                        }
                                                                       )

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
