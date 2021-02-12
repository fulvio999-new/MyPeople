import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import "../../js/utility.js" as Utility
import "../../js/storage.js" as Storage

/* import folder */
import "../meeting"

/*
    Component that display a Person item retrieved from the Database and inserted in a ListItem (See Main.qml)
    (Note: a delegate object is able to access at the data from the ListModel directly)
*/
Component {
    id: peopleListDelegate

    Item {
        id: personItem
        //width: listView.width
        width: parent.width
        height: units.gu(12)

        /* a container for each person summary info */
        Rectangle {
            id: background
            x: 2;
            y: 2;
            width: parent.width - x*2;
            height: parent.height - y*1
            border.color: "black"
            /* to get the background color of the curreunt theme. Necessary if default theme is not used */
            color: theme.palette.normal.background
            radius: 5
        }

        /* This mouse Area cover the entire delegate */
        MouseArea {
            id: selectableMouseArea
            anchors.fill: parent

            onClicked: {
                loadingPageActivity.running = true

                pageStack.push(Qt.resolvedUrl("PersonDetailsPage.qml"),
                                                       {
                                                           /* <variable-name>:<property-value> */
                                                           id:id,
                                                           personName:name,
                                                           personSurname:surname,
                                                           personPhone:phone,
                                                           personEmail:email,
                                                           personJob:job,
                                                           personTaxCode:taxCode,
                                                           personVatNumber:vatNumber,
                                                           personBirthday:birthday,
                                                           personAddress:address,
                                                           personMobilePhone:mobilePhone,
                                                           personSkype:skype,
                                                           personTelegram:telegram,
                                                           personNote:note
                                                       }
                                                       );


                /* move the highlight component to the currently selected item */
                listView.currentIndex = index
                loadingPageActivity.running = false
            }
        }

        /* Crete a row for EACH entry (ie Person) in the ListModel */
        Row {
            id: topLayout
            x: 10;
            y: 10;
            height: background.height;
            width: parent.width
            spacing: units.gu(0.5)

            Column {
                id:personInfoColumn
                width: background.width - units.gu(2) - manageMeetingColumn.width;
                height: personItem.height
                spacing: units.gu(0.2)

                Label {
                    text: name+ "<br> "+surname
                    font.bold: true;
                    font.pointSize: units.gu(1.3)
                }
                Label {
                    text: i18n.tr("phone")+": "+phone
                    fontSize: "small"
                }
                Label {
                    text: i18n.tr("mobile")+": "+mobilePhone
                    fontSize: "small"
                }
                Label {
                    text: i18n.tr("mail")+": "+email
                    fontSize: "small"
                }
            }

            /* Agenda meeting management functions */
            Column{
                id: manageMeetingColumn
                width: units.gu(6)
                anchors.verticalCenter: topLayout.right
                spacing: units.gu(1)

                Row{
                    //anchors.horizontalCenter: parent.right
                    /* Note: using an Icon Object insted of Image one to access at system default icon without specify a full path to an image */
                    Icon {
                        id: editExpenseIcon
                        width: units.gu(4)
                        height: units.gu(4)
                        name: "add"

                        MouseArea {
                            width: editExpenseIcon.width
                            height: editExpenseIcon.height
                            onClicked: {

                                 pageStack.push(Qt.resolvedUrl("../meeting/CreateMeetingWithPersonPage.qml"),
                                                                  {
                                                                            /* <variable-name>:<property-value> */
                                                                            id:id,
                                                                            personName:name,
                                                                            personSurname:surname

                                                                        }
                                                                );

                                /* move the highlight component to the currently selected item */
                                listView.currentIndex = index
                                loadingPageActivity.running = false
                            }
                        }
                    }
                }

                Row{
                    Icon {
                        id: searchMeetingIcon
                        width: units.gu(4)
                        height: units.gu(4)
                        name: "search"

                        MouseArea {
                            width: searchMeetingIcon.width
                            height: searchMeetingIcon.height
                            onClicked: {

                                /* clear meeting ListModel to prevent data caching after  deletes from maintenance page */
                                meetingWithPersonFoundModel.clear();

                                pageStack.push(Qt.resolvedUrl("../meeting/SearchMeetingWithPersonPage.qml"),
                                                                        {
                                                                            /* <variable-name>:<property-value> */
                                                                            id:id,
                                                                            personName:name,
                                                                            personSurname:surname

                                                                        }
                                                                );
                                /* move the highlight component to the currently selected item */
                                listView.currentIndex = index
                                loadingPageActivity.running = false
                            }
                        }
                    }
                }
            }
        }
    }
}
