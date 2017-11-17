import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Layouts 1.0

import Ubuntu.Components.ListItems 1.3 as ListItem


//--------------- For TABLET Page: today birthday list


Column{
    id: todayBirthDayTablet
    anchors.fill: parent

    UbuntuListView {
        id: todayBirthDayResultList
        /* necessary, otherwise hide the search criteria row */
        anchors.topMargin: units.gu(6)
        anchors.fill: parent
        focus: true
        /* nececessary otherwise the list scroll under the header */
        clip: true
        model: todayBirthdayModel
        boundsBehavior: Flickable.StopAtBounds   
        highlight: HighlightBirthDayComponent{}
        delegate: TodayBirthDayDelegate{}
    }
}

