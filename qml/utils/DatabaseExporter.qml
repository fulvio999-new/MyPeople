import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import Fileutils 1.0
import QtQuick.LocalStorage 2.0

import "../js/storage.js" as Storage

/*
   Dialog to export People or Mettings to a CSV file. Destination folder depends on the device.
   On PC desktop export path is: /<home-folder>/.clickable/home/.local/share/<applicationName>
*/
Dialog {
        id: dialogue
        title: i18n.tr("Export to a CSV file")
        text: i18n.tr("(CSV: comma separated values)")

        Component {
            id: entityTypeSelectorDelegate
            OptionSelectorDelegate { text: name}
        }

        /* Contains the two type of entity to be exported: People and Meetings */
        ListModel {
            id: exportEntityTypeModel
        }

        /* fill Listmodel using this method because allow you to use i18n */
        Component.onCompleted: {
            exportEntityTypeModel.append( { name: "<b>"+i18n.tr("People")+"</b>" , value:1 } );
            exportEntityTypeModel.append( { name: "<b>"+i18n.tr("Meetings")+"</b>", value:2 } );

            fileNameField.forceActiveFocus()
        }

        ListItem.ItemSelector {
            id: entityTypeItemSelector
            delegate: entityTypeSelectorDelegate
            model: exportEntityTypeModel
            containerHeight: itemHeight * 3
            expanded: true
        }

        TextField {
            id: fileNameField
            text: ""
            placeholderText: i18n.tr("File name")
            inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
        }

        Button {
            id:exportButton
            text: i18n.tr("Export")
            color: UbuntuColors.green
            onClicked: {
                var exportFileName = "file://" + Fileutils.getHomePath() + root.fileSavingPath + fileNameField.text+".csv";
                var exportFilePath = root.fileSavingPath;
                var csvContentToExport;

                if (exportEntityTypeModel.get(entityTypeItemSelector.selectedIndex).value === 1) {
                    //console.log("Exporting People");
                    csvContentToExport = Storage.exportPeopleTableAsCsv();
                 }else{
                    //console.log("Exporting Meetings");
                    csvContentToExport = Storage.exportMeetingsTableAsCsv();
                 }

                 //console.log("Destination CSV File: "+exportFileName);
                 //console.log("CSV content file: "+csvContentToExport);

                 if(Fileutils.exists(exportFileName)){
                    importOperationResult.color = UbuntuColors.red
                    importOperationResult.text = i18n.tr("File already exist. Change the file name");
                    pathToFileLabel.text = " "

                 } else if(!Fileutils.write(exportFileName, csvContentToExport)) {
                    importOperationResult.text = i18n.tr("Could not write file");

                 } else {
                    importOperationResult.text = i18n.tr("SUCCESS, file saved under the folder")+":"
                    importOperationResult.color = UbuntuColors.green
                    pathToFileLabel.text = exportFilePath
                 }
            }
        }

        Button {
            id: closeButton
            text: i18n.tr("Close")
            onClicked: {
              PopupUtils.close(dialogue)
            }
        }

        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            Label{              
               id: importOperationResult
               textSize:Label.Medium
               text: " " /* placeholder for layout */
            }
        }

        Row{
            Label{
                id: pathToFileLabel
                text: " " /* placeholder for layout */
            }
        }
 }
