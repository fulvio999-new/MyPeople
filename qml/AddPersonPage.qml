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
import "./js/utility.js" as Utility
import "./js/storage.js" as Storage

//------------- ADD NEW PERSON --------------------
Page {
    id: addPersonPage
    anchors.fill: parent
    anchors.leftMargin: units.gu(2)

    header: PageHeader {
        title: i18n.tr("Add new person")
    }

    Flickable {
        id: newPersonPageFlickable
        clip: true
        contentHeight: Utility.getContentHeight()
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: addPersonPage.bottom
            bottomMargin: units.gu(2)
        }

        /* Show a form to add a new contact */
        Layouts {
            id: layouts
            width: parent.width
            height: parent.height

            layouts:[

                ConditionalLayout {
                    name: "addContactLayout"
                    when: root.width > units.gu(80)
                    InsertPersonTablet{}
                }
            ]
            //else
            InsertPersonPhone{}
        }
    }

    /* To show a scrolbar on the side */
    Scrollbar {
        flickableItem: newPersonPageFlickable
        align: Qt.AlignTrailing
    }
}
