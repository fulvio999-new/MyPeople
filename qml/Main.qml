
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

/* import folder */
import "./utils"
import "./dialogs"
import "./pages/meeting"
import "./pages/person"
import "./pages/common"

/*
  App Main View
*/
MainView {

    id: root
    objectName: "mainView"
    automaticOrientation: true
    anchorToKeyboard: true

    property string appVersion: "1.7.3"

    /* applicationName needs to match the "name" field in the application manifest
       Note:' applicationName' value sets the DB storage path if using U1DB api (remove the blank spaces in the url):
       eg: ~phablet/.local/share/<applicationName>/file:/opt/<click.ubuntu.com>/<applicationName>/<version-number>/MyPeople/MyPeople_db
    */
    applicationName: "mypeople.fulvio999"
    width: units.gu(160)
    height: units.gu(90)

    /* phone */
    //width: units.gu(50)
    //height: units.gu(96)

    /* Settings file is saved in ~user/.config/<applicationName>/<applicationName>.conf  File */
    Settings {
        id:settings

        property bool isFirstUse: true;
        property bool isNewVersion: true;
        /* to notify user in case of import old contact form version < 1.5 was already done */
        property bool importAlreadyDone: false;
        property bool createMeetingTable: true;
        property bool addTelegramField: true;
        /* on startup display the today meetings: value set in the App Configuration page */
        property bool rememberMeetingsEnabled; /* not used starting from 1.7 version */
    }

    ActivityIndicator {
       id: loadingPageActivity
    }

    /* Executed at application startup */
    Component.onCompleted:{
        Storage.setDefaultConfig();
        Storage.initialize();
        Storage.createMeetingTable();
        Storage.addTelegramField();
        Storage.loadAllPeople();
        /* New: from v1.7 */
        Storage.getTodayBirthDays();
        Storage.getTodayMeetings();

        Utility.showNewFeatures();
    }

    /* ---- Common models used in sub-pages ---- */
    ListModel {
       id: meetingWithPersonFoundModel
    }

    ListModel {
       id: allPeopleMeetingFoundModel
    }

    /* saved people list */
    ListModel{
        id: modelListPeople
    }

    /* today birthdays list */
    ListModel {
       id: todayBirthdayModel
    }

    /* today Meeting list (in any status) */
    ListModel {
       id: todayMeetingModel
    }
    /* ------------------------------------- */

    Component {
        id: dataBaseEraser
        DataBaseEraser{}
    }

    Component {
        id: dataBaseImporter
        DatabaseImporter{}
    }

    Component {
        id: showNewFeaturesDialogue
        ProductNewFeatures{}
    }

    Component {
        id: operationResultDialogue
        OperationResult{}
    }


    /* AdaptivePageLayout provides a flexible way of viewing a stack of pages in one or more columns */
    AdaptivePageLayout {

        id: adaptivePageLayout
        anchors.fill: parent

        /* mandatory field for AdaptivePageLayout */
        primaryPage: PeopleListPage{}

        //------- Edit an existing Meeting with a specific Person -------------
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
                contentHeight: Utility.getContentHeight()
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
                            when: root.width > units.gu(80)
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


    }


    /*
      USED ONLY FOR THE LEGACY MyPeople VERSIONS

      U1DB Databases "connetcors" to MyPeole 1.0 and 1.1 Databases. Used only to import old contacts into new Mypeople 1.2 database
      MyPeople 1.2 (and futere release) uses QT LocalStorage API instead of QML U1DB, so that the Database  will be located
      in a fixed folder independent from thre application version and NO import was necessary.
    */


    /* For MyPepole version 1.0 importing data */
    U1db.Database {
        id: mypeopleDb1_0
        /* create an empty db in: ~phablet/.local/share/<applicationName>/1.1/
           the user will replace that empty database with his one taken from MyPeople1.0  */
         path: "1.0/MyPeople_db";
     }

    U1db.Index{
        database: mypeopleDb1_0
        id: all_field_index1_0
        expression: ["name","surname","email","job","birthday","vatNumber","taxCode","address","phone","mobilePhone","note"]
    }

    U1db.Query {
        id: allPeopleQuery1_0
        index: all_field_index1_0
        query: [{"name":"*"},{"surname":"*"},{"email":"*"},{"job":"*"},{"birthday":"*"},{"vatNumber":"*"},{"taxCode":"*"},{"address":"*"},{"phone":"*"},{"mobilePhone":"*"},{"note":"*"}]
    }


    /* For MyPeole version 1.1 importing data */
    U1db.Database {
        id: mypeopleDb1_1
        /* create an empty db in: ~phablet/.local/share/mypeople.fulvio999/1.1/
           the user will replace it his with his one about MyPeople1.0*/
        path: "1.1/MyPeople_db";
    }

    U1db.Index{
        database: mypeopleDb1_1
        id: all_field_index1_1
        expression: ["name","surname","email","job","birthday","vatNumber","taxCode","address","phone","mobilePhone","note"]
    }

    U1db.Query {
        id: allPeopleQuery1_1
        index: all_field_index1_1
        query: [{"name":"*"},{"surname":"*"},{"email":"*"},{"job":"*"},{"birthday":"*"},{"vatNumber":"*"},{"taxCode":"*"},{"address":"*"},{"phone":"*"},{"mobilePhone":"*"},{"note":"*"}]
    }

}
