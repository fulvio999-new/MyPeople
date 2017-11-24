import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Layouts 1.0

import Ubuntu.Components.ListItems 1.3 as ListItem


//--------------- For TABLET Page: today meeting list  ---------------


Item{
    id: todayMeetingTablet

    anchors.fill: parent

    UbuntuListView {
        id: todayMeetingResultList
        /* necessary, otherwise hide the page header */
        anchors.topMargin: todayMeetingPageHeader.height
        anchors.fill: parent
        focus: true
        /* nececessary otherwise the list scroll under the header */
        clip: true
        model: todayMeetingModel
        boundsBehavior: Flickable.StopAtBounds
        highlight: Component{

            id: highlightComponent

            Rectangle {
                width: 180; height: 44
                color: "blue";

                radius: 2
                /* move the Rectangle on the currently selected List item with the keyboard */
                y: todayMeetingResultList.currentItem.y

                /* show an animation on change ListItem selection */
                Behavior on y {
                    SpringAnimation {
                        spring: 5
                        damping: 0.1
                    }
                }
            }
        }

        delegate: AllPeopleMeetingFoundDelegate{isFromTodayMeetingPage:true}
    }
}



