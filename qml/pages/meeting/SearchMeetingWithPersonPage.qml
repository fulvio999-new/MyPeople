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
  Form to search meetings **ONLY WITH** the currenlty selected person in the people list.
  User must provide a time range for the search operation
*/
Page{
    id:searchMeetingWithPersonPage

    anchors.fill: parent

    /* Values passed as input properties when the AdaptiveLayout add the details page (See: PeopleListDelegate.qml)
       Are the details vaules of the selected person to fill the TextField (See delegate object)
    */
    property string id;  /* PK field not shown */
    property string personName;
    property string personSurname;
    /* the values chosen in the search meeting form */
    property string dateFrom;
    property string dateTo;
    property string meetingStatus;
    property string isFromGlobalMeetingSearch;

    header: PageHeader {
        id: headersearchAnyMeetingPage
        title: i18n.tr("Search meeting with") + ": <b>"+searchMeetingWithPersonPage.personName + " "+searchMeetingWithPersonPage.personSurname+"<\b>"
    }

     UbuntuListView {
         id: meetingSearchResultList
         anchors.topMargin: units.gu(36)
         anchors.fill: parent
         focus: true
         /* necessary otherwise the list scroll under the header */
         clip: true
         model: meetingWithPersonFoundModel
         boundsBehavior: Flickable.StopAtBounds
         highlight:
             Component {
             id: highlightMeetingComponent

             Rectangle {
                 width: 180; height: 44
                 color: "blue";
                 radius: 2
                 /* move the Rectangle on the currently selected List item with the keyboard */
                 y: meetingSearchResultList.currentItem.y

                 /* show an animation on change ListItem selection */
                 Behavior on y {
                     SpringAnimation {
                         spring: 5
                         damping: 0.1
                     }
                 }
             }
         }

         delegate: MeetingWithPersonFoundDelegate{}
     }

     /* Show the details of the selected person */
     Layouts {
           id: layoutSearchMeeting
           width: parent.width
           height: parent.height
           layouts:[

                ConditionalLayout {
                    name: "detailsContactLayout"
                    when: root.width > units.gu(80)

                        MeetingListWithPersonTablet{}
                }
           ]
           //else
           MeetingListWithPersonPhone{}
     }

     /* To show a scrollbar on the side to scroll meeting search result list */
     Scrollbar {
        flickableItem: meetingSearchResultList
        align: Qt.AlignTrailing
     }
}
