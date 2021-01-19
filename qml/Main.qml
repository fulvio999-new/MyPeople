/*
 * Copyright (C) 2019  fulvio
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * ubuntu-calculator-app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Fileutils 1.0

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


MainView {

    id: root
    objectName: "mainView"
    automaticOrientation: true
    anchorToKeyboard: true

    /* enable to test themes others then default one */
    //theme.name: "Ubuntu.Components.Themes.SuruDark"

    /* application hidden folder where are saved the files. (path is fixed due to Appp confinement rules) */
    property string fileSavingPath: "/.local/share/mypeople.fulvio999/"

    property string appVersion: "1.8.1"

    applicationName: 'mypeople.fulvio999'

    /*------- Tablet (width >= 110) -------- */
    //vertical
    //width: units.gu(75)
    //height: units.gu(111)

    //horizontal (rel)
    //width: units.gu(100)
    //height: units.gu(75)

    //Tablet horizontal
    //width: units.gu(128)
    //height: units.gu(80)

    //Tablet vertical
    //width: units.gu(80)
    //height: units.gu(128)

    /* ----- phone 4.5 (the smallest one) ---- */
    //vertical
    //width: units.gu(50)
    //height: units.gu(96)

    //horizontal
    width: units.gu(96)
    height: units.gu(50)
    /* -------------------------------------- */

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

    /* list of meeting with a specific person */
    ListModel {
       id: meetingWithPersonFoundModel
    }

    /* list of meeting with any people */
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
        id: dataBaseExporter
        DatabaseExporter{}
    }

    Component {
        id: operationResultDialogue
        OperationResult{}
    }

    PageStack {
           id: pageStack

           /* set the firts page of the application */
           Component.onCompleted: {
                pageStack.push(Qt.resolvedUrl("./pages/person/PeopleListPage.qml"));
            }
    }

    /*
      USED ONLY FOR THE LEGACY MyPeople VERSIONS (1.0 and 1.1)

      U1DB Databases "connetcors" to MyPeole 1.0 and 1.1 Databases. Used only to import old contacts into new Mypeople 1.2 database
      MyPeople 1.2 (and futere release) uses QT LocalStorage API instead of QML U1DB, so that the Database  will be located
      in a fixed folder independent from thre application version and NO import was necessary.
    */

    /* For MyPepole LEGACY version 1.0 importing data. Will be removed in the future */
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
