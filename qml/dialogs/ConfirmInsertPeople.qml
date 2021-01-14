import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import QtQuick.LocalStorage 2.0

import "../js/storage.js" as Storage


/*
    Ask a confirmation before inserting a new People in the database
*/
Dialog {
    id: confirmDialogue
    title:  i18n.tr("Confirmation")
    text: i18n.tr("Save this person ?")

    Button {
        text: "Close"
        onClicked: PopupUtils.close(confirmDialogue)
    }

    Button {
        text: "Save"
        onClicked: {
            PopupUtils.close(confirmDialogue)

            Storage.insertPeople(Storage.getUUID('people'),
                                 newNameField.text,
                                 newSurnameField.text,
                                 newJobField.text,
                                 newTaxCodeField.text,
                                 newVatNumberField.text,
                                 newBirthdayButton.text,
                                 newAddressField.text,
                                 newPhoneField.text,
                                 newMobilePhoneField.text,
                                 newEmailField.text,
                                 newSkypeField.text,   /* NEW: field added in MyPeople 1.2 */
                                 newNoteTextArea.text,
                                 newTelegramField.text /* NEW: field added in MyPeople 1.6 */
                                 );

            PopupUtils.open(operationResultDialogue)

            /* clean form fields */
            newNameField.text = ""
            newSurnameField.text = ""
            newJobField.text = ""
            newTaxCodeField.text = ""
            newVatNumberField.text = ""
            newAddressField.text = ""
            newPhoneField.text = ""
            newMobilePhoneField.text = ""
            newEmailField.text = ""
            newSkypeField.text = ""
            newTelegramField.text = ""
            newNoteTextArea.text = ""

            //adaptivePageLayout.removePages(addPersonPage)

            Storage.loadAllPeople();

            /* refresh in case of persan have today birthday */
            Storage.getTodayBirthDays();
        }
    }
}
