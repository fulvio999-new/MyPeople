import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Layouts 1.0

import Ubuntu.Components.ListItems 1.3 as ListItem


//--------------- For PHONE Page: today birthday list

Item{
    id: todayBirthDayPhone
    width: parent.width
    height: parent.height

    UbuntuListView {
        id: todayBirthDayResultList
        /* necessary, otherwise hide the search criteria row */
        anchors.topMargin: todayBirthdayPageHeader.height
        anchors.fill: parent
        focus: true
        /* nececessary otherwise the list scroll under the header */
        clip: true
        model: todayBirthdayModel
        boundsBehavior: Flickable.StopAtBounds
        highlight:
            Component {
                id: highlightBirthDayComponent

                Rectangle {
                    width: 180; height: 44
                    color: "blue";
                    radius: 2
                    /* move the Rectangle on the currently selected List item with the keyboard */
                    y: todayBirthDayResultList.currentItem.y

                    /* show an animation on change ListItem selection */
                    Behavior on y {
                        SpringAnimation {
                            spring: 5
                            damping: 0.1
                        }
                    }
                }
           }

        delegate:
            Item{
            /*
               Delegate Component to show details of a person with a birthday
            */
            id: birthdayItem
            width: parent.width
            height: units.gu(11)

            /* a container for each person */
            Rectangle {
                id: background
                x: 2; y: 2; width: parent.width - x*2; height: parent.height - y*1
                border.color: "black"
                radius: 5
            }

            MouseArea {
                id: selectableMouseArea
                width: parent.width
                height: parent.height

                onClicked: {
                    /* move the highlight component to the currently selected item */
                    todayBirthDayResultList.currentIndex = index
                }
            }

            /* Crete a row for EACH entry (ie Person) in the ListModel */
            Row {
                id: topLayout
                x: 10; y: 7;
                height: background.height;
                width: parent.width
                spacing: units.gu(4)

                Column {
                    id:personInfoColumn
                    width: background.width/3 *2.2;
                    height: birthdayItem.height
                    spacing: units.gu(0.1)

                    Label {
                        text: name+ "<br> "+surname
                        font.bold: true;
                        font.pointSize: units.gu(1.3)
                    }
                    Label {
                        text: "phone: "+phone
                        fontSize: "small"
                    }
                    Label {
                        text: "mobile: "+mobilePhone
                        fontSize: "small"
                    }
                    Label {
                        text: "mail: "+email
                        fontSize: "small"
                    }
                }
            }
        }
    }
}

