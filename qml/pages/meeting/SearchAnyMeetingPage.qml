
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


/*
  Form to search meetings ** WITH ANY** person in the people list.
  User must provide a time range for the search operation
*/
Page {
        id: searchAnyMeetingPage

        header: PageHeader {
           title: i18n.tr("Search meetings with any people")
        }

        /* the values chosen in the search meeting form */
        property string dateFrom;
        property string dateTo;
        property string meetingStatus;

        UbuntuListView {
            id: allPeopleMeetingSearchResultList
            /* necessary, otherwise hide the search criteria row */
            anchors.topMargin: units.gu(36)
            anchors.fill: parent
            focus: true
            /* necessary otherwise the list scroll under the header */
            clip: true
            model: allPeopleMeetingFoundModel
            boundsBehavior: Flickable.StopAtBounds
            highlight:
                Component{
                    id: highlightAnyMeetingComponent

                    Rectangle {
                        width: 180; height: 44
                        color: "blue";
                        radius: 2
                        /* move the Rectangle on the currently selected List item with the keyboard */
                        y: allPeopleMeetingSearchResultList.currentItem.y

                        /* show an animation on change ListItem selection */
                        Behavior on y {
                            SpringAnimation {
                                spring: 5
                                damping: 0.1
                            }
                        }
                    }
            }

            delegate: AllPeopleMeetingFoundDelegate{}
        }

        /* Show a form to search meeting with any contact */
        Layouts {
            id: agendaLayouts
            width: parent.width
            height: parent.height
            layouts:[

                ConditionalLayout {
                    name: "addContactLayout"
                    when: root.width > units.gu(120)
                    MeetingListGlobalTablet{}
                }
            ]
            //else
            MeetingListGlobalPhone{}
        }

    /* To show a scrolbar on the side */
    Scrollbar {
        flickableItem: allPeopleMeetingSearchResultList
        align: Qt.AlignTrailing
    }
}
