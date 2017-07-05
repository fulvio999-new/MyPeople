import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import QtQuick.LocalStorage 2.0
import "./storage.js" as Storage


/* Ask a confirmation before updating an existing People */
Dialog {
    id: dialogue
    title: "Confirmation"
    modal:true
    text:""  /* value passed by the caller button */
    Button {
        text: i18n.tr("Cancel")
        onClicked: PopupUtils.close(dialogue)
    }

    Button {
        text: i18n.tr("Execute")
        onClicked: {
            PopupUtils.close(dialogue)
            //console.log("Updating to DB peopleId: "+personDetailsPage.id)

            Storage.updatePeople(personDetailsPage.id,
                                 nameField.text,
                                 surnameField.text,
                                 jobField.text,
                                 taxCodeField.text,
                                 vatNumberField.text,
                                 birthdayButton.text,
                                 addressField.text,
                                 phoneField.text,
                                 mobilePhoneField.text,
                                 emailField.text,
                                 skypeField.text,  /* NEW field added in MyPeople 1.2 */
                                 noteTextArea.text,
                                 telegramField.text/* NEW field added in MyPeople 1.6 */
                                 );

            PopupUtils.open(operationResultDialogue)

            Storage.loadAllPeople(); //refresh
        }
    }
}
