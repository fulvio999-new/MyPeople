import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

/* to replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import "./storage.js" as Storage


/* Show a Dialog where the user can choose to import contacts for databases of oldest Mypeople versions (1.0 and 1.1)
   for newest version is not necessary import data
*/
Dialog {

    id: fileBrowserDialog
    text: "<b>"+ i18n.tr("To import data from old versions 1.0 and 1.1 visit")+":</b>"
    property int importedContact : 0;
    property color linkColor: "blue"
    property string website : "http://iutility.blogspot.it/2016/11/MyPeople.html"

    function colorLinks(text) {
       return text.replace(/<a(.*?)>(.*?)</g, "<a $1><font color=\"" + linkColor + "\">$2</font><")
    }

    Component.onCompleted: {

        if(allPeopleQuery1_0.documents.length === 0 && allPeopleQuery1_1.documents.length === 0)
        {
            importButton.enabled = false
            importOperationResult.text =  i18n.tr("No contacts found (First installation ?)")
            importOperationResult.color = UbuntuColors.green
        } else{
             importButton.enabled = true
             importOperationResult.text = ""

            if(settings.importAlreadyDone){
              importOperationResult.text = "<b>"+ i18n.tr("Note")+":</b>"+ i18n.tr("an import was already done")+". <br/>"+ i18n.tr("If redone you can have duplicated")
            }
        }
    }

    Rectangle {
        width: units.gu(120)
        height: units.gu(15)

        Item{
            Column{
                spacing: units.gu(1)

                Row{
                     Label {
                       text: colorLinks(i18n.tr("<a href=\"%1\">http://iutility.blogspot.it/2016/11/MyPeople.html</a>").arg(website))
                       width: fileBrowserDialog.width
                       textSize:Label.Small
                       onLinkActivated: Qt.openUrlExternally(link)
                    }
                }

                Row{
                    anchors {
                        bottomMargin: units.gu(3)
                        horizontalCenter: parent.center
                    }

                    Text {
                        text:  i18n.tr("Found")+" " + allPeopleQuery1_0.documents.length + " "+ i18n.tr("Contact(s) from")+ "MyPeople 1.0"
                    }
                }
                Row{
                    Text {
                        text:  i18n.tr("Found")+" " + allPeopleQuery1_1.documents.length + " "+ i18n.tr("Contact(s) from")+ "MyPeople 1.1"
                    }
                }
                Row{
                    spacing: units.gu(1)

                    /* placeholder */
                    Rectangle {
                        color: "transparent"
                        width: units.gu(4)
                        height: units.gu(3)
                    }

                    Button {
                        id: closeButton
                        text:  i18n.tr("Close")
                        //color: UbuntuColors.orange
                        onClicked: PopupUtils.close(fileBrowserDialog)
                    }

                    Button {
                        id: importButton
                        text:  i18n.tr("Import")
                        onClicked: {

                            closeButton.enabled = false
                            loadingPageActivity.running = true

                            /* Import from MyPeople 1.0 */
                            for(var i = 0; i < allPeopleQuery1_0.documents.length; ++i)
                            {
                                //console.log("MyPeople 1.0 contact to import: "+JSON.stringify( allPeopleQuery1_0.results[i]) );

                                Storage.insertPeople(Storage.getUUID('people'),
                                                     allPeopleQuery1_0.results[i].name,
                                                     allPeopleQuery1_0.results[i].surname,
                                                     allPeopleQuery1_0.results[i].job,
                                                     allPeopleQuery1_0.results[i].taxCode,
                                                     allPeopleQuery1_0.results[i].vatNumber,
                                                     allPeopleQuery1_0.results[i].birthday,
                                                     allPeopleQuery1_0.results[i].address,
                                                     allPeopleQuery1_0.results[i].phone,
                                                     allPeopleQuery1_0.results[i].mobilePhone,
                                                     allPeopleQuery1_0.results[i].email,
                                                     "na",   /* NEW: skype field added in MyPeople 1.2 */
                                                     allPeopleQuery1_0.results[i].note);
                                importedContact++;
                            }

                            /* Import from MyPeople 1.1 */
                            for(var j = 0; j < allPeopleQuery1_1.documents.length; ++j)
                            {
                                //console.log("MyPeople 1.1 contact to import: "+JSON.stringify( allPeopleQuery1_1.results[j]) );

                                Storage.insertPeople(Storage.getUUID('people'),
                                                     allPeopleQuery1_1.results[j].name,
                                                     allPeopleQuery1_1.results[j].surname,
                                                     allPeopleQuery1_1.results[j].job,
                                                     allPeopleQuery1_1.results[j].taxCode,
                                                     allPeopleQuery1_1.results[j].vatNumber,
                                                     allPeopleQuery1_1.results[j].birthday,
                                                     allPeopleQuery1_1.results[j].address,
                                                     allPeopleQuery1_1.results[j].phone,
                                                     allPeopleQuery1_1.results[j].mobilePhone,
                                                     allPeopleQuery1_1.results[j].email,
                                                     "na",   /* NEW: skype field added in MyPeople 1.2 */
                                                     allPeopleQuery1_1.results[j].note);
                                importedContact++;
                            }

                            //console.log("Imported: "+importedContact+ " Contact");

                            importOperationResult.text = i18n.tr("OK, succesfully imported")+": "+importedContact +" "+ i18n.tr("contacts")
                            closeButton.enabled = true
                            importButton.enabled = false

                            /* to notify at the user that an import was already done, redoing it can dupplicate contacts */
                            settings.importAlreadyDone = true

                            Storage.loadAllPeople(); //refresh

                            loadingPageActivity.running = false
                        }
                    }
                }

                Row{
                    Label{
                        id: importOperationResult
                    }
                }
            }
        }
    }
}
