import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

/* to replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import "./storage.js" as Storage


/*
    Show a Dialog where are shown the Today meetings (only if the features is enabled in the Application configuration page)
*/
Dialog {

    id: todayMeetingsAlert
    text: "<b>REMEMBER</b>"

    property int totalTodayMeetings;

    Rectangle {
        width: units.gu(120)
        height: units.gu(15)

        Item{
            Column{
                spacing: units.gu(1)

                Row{
                    x: units.gu(3)
                    Label {
                        text: "<b>Today you have: " + totalTodayMeetings + " Meeting(s)</b> <br/> (open the Agenda to show them)"
                        fontSize: "big"
                    }
                }

                Row{
                    Label {
                        text: "To disable this advice, go to Settings page"
                        fontSize: "small"
                    }
                }

                Row{
                    spacing: units.gu(3)

                    /* placeholder */
                    Rectangle {
                        color: "transparent"
                        width: units.gu(4)
                        height: units.gu(3)
                    }

                    Button {
                        id: closeButton
                        text: "Close"
                        width: units.gu(18)
                        onClicked: PopupUtils.close(todayMeetingsAlert)
                    }
                }

            }
        }
    }
}
