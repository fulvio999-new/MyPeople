import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
//import Ubuntu.Components.ListItems 1.3 as ListItem
import Fileutils 1.0
import QtQuick.LocalStorage 2.0

import "../js/storage.js" as Storage
import "../js/DateUtils.js" as DateUtils

/*
   Dialog to export People or Mettings to a CSV file. Destination folder depends on the device.
   On PC desktop export path is: /<home-folder>/.clickable/home/.local/share/<applicationName>
*/
Dialog {
        id: dataBaseExportDialog
        title: i18n.tr("Export as CSV file")
        text: i18n.tr("to")+": " +root.fileSavingPath

        Column{
                id: mainColumn
                spacing: units.gu(1)
                anchors.horizontalCenter: parent.horizontalCenter

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(4)

                    Label {
                        text: i18n.tr("People")
                    }
                    CheckBox {
                        id: exportContactsCheckBox
                        checked: false
                    }

                    Label {
                        text: i18n.tr("Meetings")
                    }
                    CheckBox {
                        id: exportMeetingsCheckBox
                        checked: false
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(2)

                    Button {
                        id: closeButton
                        width: units.gu(12)
                        text:  i18n.tr("Close")
                        onClicked: PopupUtils.close(dataBaseExportDialog)
                    }

                    Button {
                        id: exportButton
                        width: units.gu(12)
                        text:  i18n.tr("Export")
                        color: UbuntuColors.red
                        onClicked: {
                            var exportFileName = "file://" + Fileutils.getHomePath() + root.fileSavingPath;
                            var exportFilePath = root.fileSavingPath;

                            var csvContactToExport = "na";
                            var csvMeetingToExport = "na";

                            var contactFileName;
                            var meetingFileName;

                            var todayDate = DateUtils.formatFullDateForCsvExport(new Date());

                            if(!exportContactsCheckBox.checked && !exportMeetingsCheckBox.checked){

                                operationResult.color = UbuntuColors.red
                                operationResult.text = i18n.tr("Please, select an option");

                            }else{

                                if(exportContactsCheckBox.checked) {
                                   csvContactToExport = Storage.exportPeopleTableAsCsv();
                                   contactFileName = exportFileName +"MyPeople-"+todayDate+"-contacts.csv";
                                   Fileutils.write(contactFileName, csvContactToExport)
                                }

                                if(exportMeetingsCheckBox.checked) {
                                   csvMeetingToExport = Storage.exportMeetingsTableAsCsv();
                                   meetingFileName = exportFileName +"MyPeople-"+todayDate+"-meetings.csv";
                                   Fileutils.write(meetingFileName, csvMeetingToExport);
                                }

                                operationResult.color = UbuntuColors.green
                                operationResult.text = i18n.tr("OK, saved as: ")+ "MyPeople-"+todayDate;
                                closeButton.enabled = true
                            }
                        }
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label{
                        id: operationResult
                        text: " "
                    }
                }
          }
 }
