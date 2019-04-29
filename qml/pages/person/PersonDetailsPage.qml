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
import "../../dialogs"

//-------------------- PERSON DETAILS PAGE -------------------------------
Page{
    id:personDetailsPage

    anchors.fill: parent

    /* Values passed as input properties when the AdaptiveLayout add the details page (See: PeopleListDelegate.qml)
       Are the details of the selected person in the people list used to fill the TextField
    */
    property string id  /* PK Person Id (not shown) */
    property string personName;
    property string personSurname
    property string personPhone
    property string personEmail
    property string personJob
    property string personTaxCode
    property string personVatNumber
    property string personBirthday
    property string personAddress
    property string personSkype
    property string personTelegram
    property string personMobilePhone
    property string personNote

    header: PageHeader {
        id: headerDetailsPage
        title: i18n.tr("Details for") + " <b>"+personDetailsPage.personName + " "+personDetailsPage.personSurname+"<\b>"
    }

    /* to have a scrollable column when the keyboard cover some input field */
    Flickable {
        id: personDetailsFlickable
        clip: true
        contentHeight: Utility.getPageHeight(personDetailsPage)
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: personDetailsPage.bottom
            bottomMargin: units.gu(2)
        }

        /* Show the details of the selected person */
        Layouts {
            id: layoutsDetailsContact
            width: parent.width
            height: parent.height
            layouts:[

                ConditionalLayout {
                    name: "detailsContactLayout"
                    when: root.width > units.gu(120)

                        DetailsPersonTablet{}
                }
            ]
            //else
            DetailsPersonPhone{}
        }
    }

    /* To show a scrollbar on the side */
    Scrollbar {
        flickableItem: personDetailsFlickable
        align: Qt.AlignTrailing
    }
}
