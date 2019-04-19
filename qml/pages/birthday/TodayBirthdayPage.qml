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

//----------------- Today BirthDay -----------------
Page {
     id: todayBirthdayPage
     anchors.fill: parent

     header: PageHeader {
        id: todayBirthdayPageHeader
        title: i18n.tr("Today BirthDay")+ ": " + todayBirthdayModel.count
     }

     Layouts {
         id: layouttodayBirthdayPage
         anchors.fill: parent
         layouts:[

             ConditionalLayout {
                 name: "layoutTodayBirthDay"
                 when: root.width > units.gu(50)
                 TodayBirthDayTablet{}
             }
         ]
         //else
         TodayBirthDayPhone{}
     }
}
