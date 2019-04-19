import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import "./js/utility.js" as Utility

/* General info about the application and Help page */
Dialog {
       id: aboutDialogue
       title: i18n.tr("Product Info")
       contentWidth: Utility.getHelpPageWidth()

       text: "<b>"+"MyPeople version: "+root.appVersion+"  Author: fulvio"+"</b><br/><br/>"+
             "<b>"+i18n.tr("What you can do with MyPeople")+"</b><br/>"
                  +i18n.tr("Store (locally) informations of people <br/> (eg: name, address, phone, mail, telegram...)")+"<br/>"
                  +i18n.tr("Store meetings with the archived people")+"<br/>"+"<br/>"
                  +"<b>"+i18n.tr("What is the meeting status ?")+"</b><br/>"
                  +i18n.tr("Is a flag used to keep the status of the meeting.")+"<br/>"
                  +i18n.tr("There are three status: <br/><b>SCHEDULED, ARCHIVED, SCHEDULED (EXPIRED)</b>")+"<br/><br/>"
                  +i18n.tr("When a future meeting is created get the 'SCHEDULED' status to indicate that is programmed.")+"<br/><br/>"
                  +i18n.tr("The user can delete a meeting or archive it")+ "<br/>"+i18n.tr("(for example when is finished or deleted)")+"<br/>"+i18n.tr("Archiving a meeting place it in ARCHIVED status")+"<br/>"
                  +i18n.tr("Archiving a meeting means that is kept in the database,so that can be re-scheduled in the future, or simply to keep it as a report.")+"<br/><br/>"
                  +i18n.tr("When the current time is greater than the meeting datetime, the meeting is 'SCHEDULED (EXPIRED)'.")+"<br/><br/>"
                  +i18n.tr("Updating the date of an 'SCHEDULED (EXPIRED)' meeting with a future date, it return automatically in SCHEDULED status again.")+"<br/><br/>"
                  +i18n.tr("An ARCHIVED meeting can return in SCHEDULED status setting his datetime to a future date and manually change his status")+"<br/>"


       Button {
           width: units.gu(18)
           text: i18n.tr("Close")
           onClicked: PopupUtils.close(aboutDialogue)
       }
}
