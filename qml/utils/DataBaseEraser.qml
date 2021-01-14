import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.LocalStorage 2.0

import "../js/storage.js" as Storage


/*
    Show a Dialog where the user can choose to delete ALL the save contacts/people and/or the saved meetings
 */
Dialog {
        id: dataBaseEraserDialog
        text: "<b>"+ i18n.tr("Select item type(s) to remove")+"<br/>"+i18n.tr("(there is NO restore)")+ "</b>"

        Column{
                id: mainColumn
                spacing: units.gu(2)
                anchors.horizontalCenter: parent.horizontalCenter

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(2.3)

                    Label {
                        text: i18n.tr("People")
                    }
                    CheckBox {
                        id: deleteContactsCheckBox
                        checked: false
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(0.5)

                    Label {
                        text: i18n.tr("Meetings")
                    }
                    CheckBox {
                        id: deleteMeetingsCheckBox
                        checked: false
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(1)

                    Button {
                        id: closeButton
                        width: units.gu(12)
                        text:  i18n.tr("Close")
                        onClicked: PopupUtils.close(dataBaseEraserDialog)
                    }

                    Button {
                        id: deleteButton
                        width: units.gu(12)
                        text:  i18n.tr("Delete")
                        color: UbuntuColors.red
                        onClicked: {
                            loadingPageActivity.running = true

                            if(!deleteContactsCheckBox.checked && !deleteMeetingsCheckBox.checked){

                                deleteOperationResult.color = UbuntuColors.red
                                deleteOperationResult.text = i18n.tr("Please, select an option");

                            }else{

                                var deletedPeople = 0;
                                var deletedMeeting = 0;

                                if(deleteContactsCheckBox.checked){
                                   deletedPeople = Storage.deleteAllPeople();
                                }

                                if(deleteMeetingsCheckBox.checked) {
                                  deletedMeeting = Storage.deleteAllMeeting();
                                }

                                deleteOperationResult.color = UbuntuColors.green
                                deleteOperationResult.text = i18n.tr("Deletion executed successfully")+"<br>"+ i18n.tr("Deleted")+" "+deletedPeople+ " "+ i18n.tr("pepole and")+" "+deletedMeeting +" "+ i18n.tr("meetings")
                                closeButton.enabled = true
                                /* blank flag that notify previously data import form version 1.0 and 1.2
                                   Note: for versions > 1.5 the import is not necessary
                                */
                                settings.importAlreadyDone = false

                                /* refresh lists */
                                Storage.loadAllPeople();
                                Storage.getTodayBirthDays();
                                Storage.getTodayMeetings();

                                //adaptivePageLayout.removePages(personDetailsPage)
                                loadingPageActivity.running = false
                            }
                        }
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label{
                        id: deleteOperationResult
                    }
                }
          }
}
