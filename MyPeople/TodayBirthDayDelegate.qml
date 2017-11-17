import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import "./utility.js" as Utility
import "./storage.js" as Storage

    /*
       Delegate Component that display the details of a person with a birthday
    */
    Item {
        id: birthdayItem
        width: parent.width
        height: units.gu(11)

        /* a container for each person summary info */
        Rectangle {
            id: background
            x: 2; y: 2; width: parent.width - x*2; height: parent.height - y*1
            border.color: "black"
            radius: 5
        }


        MouseArea {
            id: selectableMouseArea
            anchors.fill: parent
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
                spacing: 1

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

