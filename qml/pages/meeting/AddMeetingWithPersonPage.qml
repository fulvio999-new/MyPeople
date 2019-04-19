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

//------------ ADD A NEW MEETING WITH the selected person ------------
Page{
    id:addMeetingWithPersonPage

    anchors.fill: parent

    /* values passed when the user has chosen a people in the  people list */
    property string id  /* PK field not shown */
    property string personName;
    property string personSurname

    header: PageHeader {
        id: headerAddMeetingPage
        title: i18n.tr("Create a meeting with")+ ": " + "<b>"+addMeetingWithPersonPage.personName + " "+addMeetingWithPersonPage.personSurname+"<\b>"
    }

    /* to have a scrollable column when the keyboard cover some input field */
    Flickable {
        id: addMeetingWithPersonPageFlickable
        clip: true
        contentHeight: Utility.getContentHeight()
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: addMeetingWithPersonPage.bottom
            bottomMargin: units.gu(2)
        }

        /* Show the details of the selected person */
        Layouts {
            id: layoutAddMeeting
            width: parent.width
            height: parent.height
            layouts:[

                ConditionalLayout {
                    name: "detailsContactLayout"
                    when: root.width > units.gu(80)

                        NewMeetingTablet{}
                }
            ]
            //else
            NewMeetingPhone{}
        }
    }

    /* To show a scrollbar on the side */
    Scrollbar {
        flickableItem: addMeetingWithPersonPageFlickable
        align: Qt.AlignTrailing
    }
}
