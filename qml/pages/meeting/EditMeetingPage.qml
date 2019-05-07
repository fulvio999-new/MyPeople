import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

import "../../js/storage.js" as Storage
import "../../js/utility.js" as Utility


/*
  Edit an existing Meeting
*/
Page{
    id: editMeetingPage
    anchors.fill: parent

    /* meeting info to edit */
    property string id; /* meetingId */
    property string name;
    property string surname;
    property string subject;
    property string date : "1970-01-01 00:00"; /* placeholder value */
    property string place;
    property string status; /* ie: TODO, ARCHIVED */
    property string note;
    property bool isFromGlobalMeetingSearch; /* true if the user has made meeting search with any people */
    /* to repaeat the search */
    property string dateFrom;
    property string dateTo;
    property string meetingStatus;

    header: PageHeader {
        id: headerEditExpensePage
        title: i18n.tr("Edit meeting with") +": "+ "<b>" +editMeetingPage.name +" "+ editMeetingPage.surname+"</b>"
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

        /* Show the details of the selected meeting */
        Layouts {
            id: layoutEditExpensePage
            width: parent.width
            height: parent.height
            layouts:[

                ConditionalLayout {
                    name: "editMeetingLayout"
                    when: root.width > units.gu(120)
                    EditMeetingTablet{ meetingStatus:editMeetingPage.status;meetingDate:editMeetingPage.date;isFromGlobalMeetingSearch:editMeetingPage.isFromGlobalMeetingSearch;dateFrom:editMeetingPage.dateFrom;dateTo:editMeetingPage.dateTo}
                }
            ]
            //else
            EditMeetingPhone{ meetingStatus:editMeetingPage.status;meetingDate:editMeetingPage.date;isFromGlobalMeetingSearch:editMeetingPage.isFromGlobalMeetingSearch;dateFrom:editMeetingPage.dateFrom;dateTo:editMeetingPage.dateTo }
        }
    }

    /* To show a scrolbar on the side */
    Scrollbar {
        flickableItem: editMeetingPageFlickable
        align: Qt.AlignTrailing
    }
}
//page
