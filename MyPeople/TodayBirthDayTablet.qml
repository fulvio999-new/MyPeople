import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Layouts 1.0

import Ubuntu.Components.ListItems 1.3 as ListItem


//--------------- For TABLET Page: today birthday list  ---------------


Column{
    id: todayBirthDayTablet

    anchors.fill: parent
    spacing: units.gu(3.5)
    anchors.leftMargin: units.gu(2)


                Component{
                    id: birthDayFoundDelegate
                    BirthDayFoundDelegate{}
                }


                UbuntuListView {
                       id: todayBirthDayResultList
                       /* necessary, otherwise hide the search criteria row */
                       anchors.topMargin: units.gu(36)
                       anchors.fill: parent
                       focus: true
                       /* nececessary otherwise the list scroll under the header */
                       clip: true
                       model: todayBirthdayModel
                       boundsBehavior: Flickable.StopAtBounds
                      // highlight: HighlightComponent{}
                       delegate: birthDayFoundDelegate
                }


    /* transparent placeholder */
    Rectangle {
        color: "transparent"
        width: parent.width
        height: units.gu(6)
    }

    Row{
        id: headerCurrencyRow
        x: todayBirthDayTablet.width/3
        Label{
            text: "<b>"+i18n.tr("TODAY BIRTHDAY")+": "+todayBirthdayModel.count+"</b>"
        }
    }


    //LIStViv
    Row{
        id: nameRow
       // x: todayBirthDayTablet.width/3
        Label{
            text: "<b>"+i18n.tr("TODAY BIRTHDAY")+": "+todayBirthdayModel.count+"</b>"
        }
    }

}

