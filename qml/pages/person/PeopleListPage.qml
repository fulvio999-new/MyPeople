import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

import U1db 1.0 as U1db

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

/* note: alias name must have first letter in upperCase */
import "../../js/utility.js" as Utility
import "../../js/storage.js" as Storage

/* import folder */
import "../../utils"
import "../meeting"

/*
   Primary page loaded on startup by AdaptiveLayout. Show a list of saved persons and search form
*/
Page{
    id: peopleListPage
    anchors.fill: parent

    header: PageHeader {
        title: "MyPeople"

        leadingActionBar.actions: [
            Action {
                id: aboutPopover
                /* note: icons names are file names under: /usr/share/icons/suru */
                iconName: "help"
                text: i18n.tr("Help")
                onTriggered:{
                    PopupUtils.open(Qt.resolvedUrl("../common/AboutProduct.qml"))
                }
            }
        ]

        trailingActionBar.actions: [

            Action {
                iconName: "list-add"
                text: i18n.tr("Add")
                onTriggered:{
                    pageStack.push(Qt.resolvedUrl("../person/AddPersonPage.qml"));
                }
            },

            Action {
                iconName: "delete"
                text: i18n.tr("Delete")
                onTriggered:{
                    PopupUtils.open(dataBaseEraser)
                }
            },

            Action {
                iconName: "import"
                text: i18n.tr("Import")
                onTriggered:{
                    PopupUtils.open(dataBaseImporter)
                }
            },

            Action {
                iconName: "save"
                text: i18n.tr("Export as CSV")
                onTriggered:{
                    PopupUtils.open(dataBaseExporter)
                }
            },

            /* New config page from version 1.6 */
            Action {
                iconName: "settings"
                text: i18n.tr("Settings")
                onTriggered:{
                    pageStack.push(Qt.resolvedUrl("../common/ConfigurationPage.qml"));
                }
            }
        ]
    }

    Component.onCompleted: {
        Storage.loadAllPeople();
    }

    /* keep sorted the loaded people List */
    SortFilterModel {
        id: sortedListPeopleModel
        model: modelListPeople
        sort.order: Qt.AscendingOrder
        sortCaseSensitivity: Qt.CaseSensitive
    }

    /* A list of people */
    UbuntuListView {
        id: listView
        anchors.fill: parent
        anchors.topMargin: units.gu(30) /* amount of space from the above component */
        model: sortedListPeopleModel
        delegate: PeopleListDelegate{}  /* Component used to display an item */

        /* disable the dragging of the model list elements */
        boundsBehavior: Flickable.StopAtBounds
        highlight:
            Component {
            id: highlightComponent

            Rectangle {
                width: 180; height: 44
                color: "blue";
                radius: 2
                /* move the Rectangle on the currently selected List item with the keyboard */
                y: listView.currentItem.y

                /* show an animation on change ListItem selection */
                Behavior on y {
                    SpringAnimation {
                        spring: 5
                        damping: 0.1
                    }
                }
            }
        }

        focus: true
        /* note: clip:true prevent that UbuntuListView draw out of his assigned rectangle, default is false */
        clip: true
      }

        /* header for the list. Is declared here, inside at the UbuntuListView, to have access at the List items width param */
        Column{
                id: clo1
                anchors.fill: parent

                spacing: units.gu(1)
                anchors.verticalCenter: parent.verticalCenter
                /* placeholder */
                Rectangle {
                        color: "transparent"
                        width: parent.width
                        height: units.gu(7)
                }

                Row{
                      id:row1
                      spacing: units.gu(2)
                      anchors.horizontalCenter: parent.horizontalCenter

                      TextField{
                            id: searchField
                            width: units.gu(30)
                            placeholderText: i18n.tr("Filter by surname")
                            inputMethodHints: Qt.ImhNoPredictiveText /* disable text prediction with underlining */
                                            onTextChanged: {

                                                if (text.length > 0) /* do filter */ {
                                                    /* flag "i" = ignore case */
                                                    sortedListPeopleModel.filter.pattern = new RegExp(searchField.text, "i")
                                                    sortedListPeopleModel.sort.order = Qt.AscendingOrder
                                                    sortedListPeopleModel.sortCaseSensitivity = Qt.CaseSensitive

                                                    /* filter by surname */
                                                    sortedListPeopleModel.sort.property = "surname"
                                                    sortedListPeopleModel.filter.property = "surname"

                                                } else {
                                                    /* show all people */
                                                    sortedListPeopleModel.filter.pattern = /./
                                                    sortedListPeopleModel.sort.order = Qt.AscendingOrder
                                                    sortedListPeopleModel.sortCaseSensitivity = Qt.CaseSensitive
                                                }
                                            }

                            }

                    }

                    Row{
                        id:row2
                        spacing: units.gu(1)
                        anchors.horizontalCenter: parent.horizontalCenter
                        Label{
                            id: peopleFoundLabel
                            text: i18n.tr("Total people found")+": " + listView.count
                            font.bold: false
                            font.pointSize: units.gu(1.5)
                        }
                    }

                    Row{
                        id:row3
                        anchors.horizontalCenter: parent.horizontalCenter

                        Button{
                            id: showReportbutton
                            text: i18n.tr("Global Agenda Meetings")
                            color: UbuntuColors.green
                            height: units.gu(4)
                            onClicked: {
                                /* clean data to prevent caching after delete executed from maintenance page */
                                meetingWithPersonFoundModel.clear();
                                allPeopleMeetingFoundModel.clear();

                                pageStack.push(Qt.resolvedUrl("../meeting/SearchAnyMeetingPage.qml"));
                            }
                        }
                    }

                    Row{
                        id:todayInfo
                        anchors.horizontalCenter: parent.horizontalCenter
                        Grid {
                            id: categoryInstantReportChartRow
                            visible: true
                            columns:4
                            columnSpacing: units.gu(2)
                            verticalItemAlignment: Grid.AlignVCenter
                            horizontalItemAlignment: Grid.AlignHCenter

                            /* TODAY BIRTHDAY */
                            MouseArea{
                                width: todayBirthdayImage.width;
                                height:todayBirthdayImage.height;

                                Image{
                                    id:todayBirthdayImage
                                    width: 50; height:50
                                    fillMode: Image.PreserveAspectFit
                                    source: Qt.resolvedUrl("../../images/birthday.png")
                                }

                                onClicked: {
                                    Storage.getTodayBirthDays();
                                    pageStack.push(Qt.resolvedUrl("../birthday/TodayBirthdayPage.qml"));
                                }
                            }

                            Label{
                                id: todayBirthDay
                                text: i18n.tr("Today")+": "+ todayBirthdayModel.count
                            }

                            /* TODAY MEETING */
                            MouseArea{
                                width: todayBirthdayImage.width;
                                height:todayBirthdayImage.height;

                                Image{
                                    id:todayMeetingImage
                                    width: 60; height:60
                                    fillMode: Image.PreserveAspectFit
                                    source:  Qt.resolvedUrl("../../images/meeting.png")
                                }

                                onClicked: {
                                    Storage.getTodayMeetings();
                                    pageStack.push(Qt.resolvedUrl("../meeting/TodayMeetingPage.qml"));
                                }
                            }

                            Label{
                                id: todayMeeting
                                text: i18n.tr("Today")+": "+ todayMeetingModel.count
                            }
                        }
                    }
            }

    Scrollbar {
        flickableItem: listView
        align: Qt.AlignTrailing
    }
}
