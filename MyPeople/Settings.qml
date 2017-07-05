import QtQuick 2.0
import Qt.labs.settings 1.0

Settings {

    //if 'true' means that is the first time that the user open this MyPeople version: ask to import old contacts
    //from the old Database
    property bool isFirstUse:true;

}
