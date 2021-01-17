import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import "../../js/utility.js" as Utility

/* General info about the application and Help page */
Dialog {
       id: aboutDialogue
       title: i18n.tr("Product Info")
       contentWidth: Utility.getHelpPageWidth()

       text: "<b>"+"MyPeople version: "+root.appVersion+"  Author: fulvio"+"</b><br/><br/>"+
             "<b>"+i18n.tr("With MyPeople you can:")+"</b><br/>"
                  +i18n.tr("a) Store (locally) informations of people <br/> (No data are shared online)")+"<br/>"
                  +i18n.tr("b) Create an Agenda of meetings with the archived people")+"<br/>"+"<br/>"
                  +"<b>"+i18n.tr("What is the meeting status ?")+"</b><br/>"
                  +i18n.tr("Is a flag used to organize the stored meetings.")+"<br/>"
                  +i18n.tr("There are three status: <br/><b>'SCHEDULED', 'ARCHIVED', 'SCHEDULED (EXPIRED)''</b>")+"<br/><br/>"
                  +i18n.tr("A just created meeting (for a future data) get 'SCHEDULED' status (that means 'is programmed').")+"<br/><br/>"
                  +i18n.tr("Any meeting, can be deleted.")+ "<br/>"+i18n.tr("Archiving set the meeting status to 'ARCHIVED'")+"<br/>"
                  +i18n.tr("Archiving a meeting means 'leave it in database'. You can schedule again an archived meeting,")+"<br/>"
                  +i18n.tr("just set a future date and change his status to 'SCHEDULED'")+"<br/>"
                  +i18n.tr("Is not possible schedule a new meeting in a past date")+"<br/><br/>"
                  +i18n.tr("When current time is greater than the meeting one, the meeting is 'SCHEDULED (EXPIRED)'.")+"<br/><br/>"
                  +i18n.tr("Updating the date to a future one return to 'SCHEDULED'")

       Button {
           width: units.gu(18)
           anchors.horizontalCenter: parent.horizontalCenter
           text: i18n.tr("Close")
           onClicked: PopupUtils.close(aboutDialogue)
       }
}
