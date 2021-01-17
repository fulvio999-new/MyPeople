import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

import U1db 1.0 as U1db

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

/* note: alias name must have first letter in upperCase */
import "../../js/utility.js" as Utility
import "../../js/storage.js" as Storage

/*
  Form to search meetings **ONLY WITH** the currenlty selected person in the people list.
  User must provide a time range for the search operation
*/
Page{
    id:searchMeetingWithPersonPage

    anchors.fill: parent

    /* Values passed as input properties when the AdaptiveLayout add the details page (See: PeopleListDelegate.qml)
       Are the details vaules of the selected person to fill the TextField (See delegate object)
    */
    property string id;  /* PK field not shown */
    property string personName;
    property string personSurname;
    /* the values chosen in the search meeting form */
    property string dateFrom;
    property string dateTo;
    property string meetingStatus;
    property string isFromGlobalMeetingSearch;

    header: PageHeader {
        id: headersearchAnyMeetingPage
        title: i18n.tr("Meeting with") + ": <b>"+searchMeetingWithPersonPage.personName + " "+searchMeetingWithPersonPage.personSurname+"<\b>"
    }

     UbuntuListView {
         id: meetingSearchResultList
         anchors.topMargin: units.gu(40)
         anchors.fill: parent
         focus: true
         /* necessary otherwise the list scroll under the header */
         clip: true
         model: meetingWithPersonFoundModel
         boundsBehavior: Flickable.StopAtBounds
         highlight:
             Component {
             id: highlightMeetingComponent

             Rectangle {
                 width: 180; height: 44
                 color: "blue";
                 radius: 2
                 /* move the Rectangle on the currently selected List item with the keyboard */
                 y: meetingSearchResultList.currentItem.y

                 /* show an animation on change ListItem selection */
                 Behavior on y {
                     SpringAnimation {
                         spring: 5
                         damping: 0.1
                     }
                 }
             }
         }

         delegate: MeetingWithPersonFoundDelegate{}
     }


     Column{
          id: searchMeetingWithPeopleColum
          anchors.fill: parent
          spacing: units.gu(1.5)

         /* transparent placeholder: required to place the content under the header */
         Rectangle {
             /* to get the background color of the curreunt theme. Necessary if default theme is not used */
             color: theme.palette.normal.background
             width: parent.width
             height: units.gu(6)
         }

         /* label to show search result */
         Row{
             id: meetingFoundTitle
             anchors.horizontalCenter: parent.horizontalCenter
             Label{
                 id: meetingFoundLabel
                 text : " "
             }
         }

         Row{
             id: searchFromRow
             spacing: units.gu(1)
             anchors.horizontalCenter: parent.horizontalCenter

             /*
                A PopOver containing a DatePicker, is necessary due to a "bug" on setting minimum date
                with a simple DatePicker Component
            */
            Component {
                 id: popoverDateFromPickerComponent
                 Popover {
                     id: popoverDateFromPicker

                     DatePicker {
                         id: timeFromPicker
                         mode: "Days|Months|Years"
                         minimum: {
                             var time = new Date()
                             time.setFullYear('2000')
                             return time
                         }
                         /* when Datepicker is closed, is updated the date shown in the button */
                         Component.onDestruction: {
                             meetingDateFromButton.text = Qt.formatDateTime(timeFromPicker.date, "dd MMMM yyyy")
                         }
                     }
                 }
             }

             /* open the popOver component with a DatePicker */
             Button {
                 id: meetingDateFromButton
                 width: units.gu(18)
                 text: i18n.tr("From")+"..."//Qt.formatDateTime(new Date(), "dd MMMM yyyy")
                 onClicked: {
                     PopupUtils.open(popoverDateFromPickerComponent, meetingDateFromButton)
                 }
             }
      }

       Row{
            id: searchToDateRow
            spacing: units.gu(1)
            anchors.horizontalCenter: parent.horizontalCenter

             /* A PopOver containing a DatePicker is necessary due to a "bug" on setting minimum date
                with a simple DatePicker Component
             */
             Component {
                 id: popoverDateToPickerComponent
                 Popover {
                     id: popoverDateToPicker
                     DatePicker {
                         id: timeToPicker
                         mode: "Days|Months|Years"
                         minimum: {
                             var time = new Date()
                             time.setFullYear(time.getFullYear())
                             return time
                         }
                         /* when Datepicker is closed, is updated the date shown in the button */
                         Component.onDestruction: {
                             meetingDateToButton.text = Qt.formatDateTime(timeToPicker.date, "dd MMMM yyyy")
                         }
                     }
                 }
             }

             /* open the popOver component with a DatePicker */
             Button {
                 id: meetingDateToButton
                 width: units.gu(18)
                 text: i18n.tr("To")+"..."//Qt.formatDateTime(new Date(), "dd MMMM yyyy")
                 onClicked: {
                     PopupUtils.open(popoverDateToPickerComponent, meetingDateToButton)
                 }
             }
         }

         Row{
             id: filterStatusRow
             spacing: units.gu(1)
             anchors.horizontalCenter: parent.horizontalCenter

             Component {
                 id: meetingTypeSelectorDelegate
                 OptionSelectorDelegate { text: name; subText: description; }
             }

             /* The meeting status shown in the combo box */
             ListModel {
                 id: meetingTypeModel
             }

             /* fill listmodel using this method because allow you to use i18n */
             Component.onCompleted: {
                 meetingTypeModel.append( { name: "<b>"+i18n.tr("Scheduled")+"</b>", description: i18n.tr("meetings to participate"), value:1 } );
                 meetingTypeModel.append( { name: "<b>"+i18n.tr("Archived")+"</b>", description: i18n.tr("participated meetings"), value:2 } );
             }

             Label {
                 id: meetingStatusItemSelectorLabel
                 anchors.verticalCenter: meetingStatusContainer.verticalCenter
                 text: i18n.tr("Status")+":"
             }

             Rectangle{
                 id:meetingStatusContainer

                 width: searchMeetingWithPeopleColum.width - meetingStatusItemSelectorLabel.width - units.gu(10)
                 height:units.gu(10)
                 /* to get the background color of the curreunt theme. Necessary if default theme is not used */
                 color: theme.palette.normal.background

                 ListItem.ItemSelector {
                     id: meetingTypeItemSelector
                     delegate: meetingTypeSelectorDelegate
                     model: meetingTypeModel
                     containerHeight: itemHeight * 2
                     expanded: true

                     /* ItemSelectionChange event is not built-in with ItemSelector component: use a workaround */
                     onDelegateClicked:{
                        meetingFoundLabel.text = " " //clean result label
                        meetingWithPersonFoundModel.clear();
                     }
                 }
             }
          }


          Row{
              anchors.horizontalCenter: parent.horizontalCenter

              Button {
                 id: searchButton
                 text: i18n.tr("Search")
                 width:units.gu(18)
                 color: UbuntuColors.orange
                 onClicked: {

                     var meetingStatus = "SCHEDULED";

                     if (meetingTypeModel.get(meetingTypeItemSelector.selectedIndex).value === 2) {
                         meetingStatus = "ARCHIVED"
                     }

                     Storage.searchMeetingByTimeAndPerson(searchMeetingWithPersonPage.personName,searchMeetingWithPersonPage.personSurname,meetingDateFromButton.text,meetingDateToButton.text,meetingStatus);

                     searchMeetingWithPersonPage.dateFrom = meetingDateFromButton.text;
                     searchMeetingWithPersonPage.dateTo = meetingDateToButton.text;
                     searchMeetingWithPersonPage.meetingStatus = meetingStatus;

                     meetingFoundLabel.text = "<b>"+i18n.tr("Found")+": </b>"+ meetingSearchResultList.count +"<b> "+i18n.tr("meeting(s) (in chronological order)")+"</b>"

                 }
             }
          }
     }



     /* To show a scrollbar on the side to scroll meeting search result list */
     Scrollbar {
        flickableItem: meetingSearchResultList
        align: Qt.AlignTrailing
     }
}
