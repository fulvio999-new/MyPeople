import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

import "storage.js" as Storage

//--------------- For TABLET Page with application settings and maintenance utility ---------------


Column{
    id: appConfigurationTablet

    anchors.fill: parent
    spacing: units.gu(3.5)
    anchors.leftMargin: units.gu(2)

    /* transparent placeholder */
    Rectangle {
        color: "transparent"
        width: parent.width
        height: units.gu(6)
    }

    Component {
        id: operationResultDialogue
        OperationResult{}
    }


    /* Dialog to Ask a confirmation for a delete operation for meetings */
    Component{

          id: confirmDeleteDialogueComponent
          Dialog {
              id: confirmDeleteDialogue
              title: i18n.tr("Confirmation")
              modal:true
              text:"Remove meetings in the range (no restore) ?"

              Label{
                  id: deleteSuccessLabel
                  text: ""
                  color: UbuntuColors.green
              }

              Button {
                 text: i18n.tr("Cancel")
                 onClicked: PopupUtils.close(confirmDeleteDialogue)
              }

              Button {
                  id: executeDeleteButton
                  text: i18n.tr("Execute")
                  onClicked: {

                      var meetingStatus = "SCHEDULED";

                      if (meetingTypeModel.get(meetingTypeItemSelector.selectedIndex).name === "<b>Archived</b>") {
                         meetingStatus = "ARCHIVED"
                      }

                      var deletedMeetings = Storage.deleteExpenseByCategoryAndTime(dateFromButton.text,dateToButton.text,meetingStatus);

                      deleteSuccessLabel.text = i18n.tr("Done, deleted")+": "+deletedMeetings+" meeting(s)"
                      executeDeleteButton.enabled = false;

                      /* update today meetings count */
                      Storage.getTodayMeetings();
                  }
              }
          }
      }


      Row{
          id: maintenanceRowHeader
          x: appConfigurationTablet.width/3
          Label{
              text: "<b>"+i18n.tr("MAINTENANCE: delete old meetings")+"</b>"
          }
      }


      Row{
              id: dateRow
              spacing: units.gu(1)

              //------------------ Date from ------------------
              Label {
                  id: fromDateLabel
                  anchors.verticalCenter: dateFromButton.verticalCenter
                  text: i18n.tr("From:")
              }

              /* Create a PopOver containing a DatePicker, necessary use a PopOver a container due to a bug on setting minimum date
                 with a simple DatePicker Component
              */
              Component {
                  id: popoverDateFromPickerComponent
                  Popover {
                      id: popoverDateFromPicker

                      DatePicker {
                          id: fromTimePicker
                          mode: "Days|Months|Years"
                          minimum: {
                              var time = new Date()
                              time.setFullYear('2000')
                              return time
                          }
                          /* when Datepicker is closed, is updated the date shown in the button */
                          Component.onDestruction: {
                              dateFromButton.text = Qt.formatDateTime(fromTimePicker.date, "dd MMMM yyyy")
                          }
                      }
                  }
              }

              /* open the popover component with DatePicker */
              Button {
                  id: dateFromButton
                  text: Qt.formatDateTime(new Date(), "dd MMMM yyyy")
                  width: units.gu(18)
                  onClicked: {
                     PopupUtils.open(popoverDateFromPickerComponent, dateFromButton)
                  }
              }

              //------------------ Date to ------------------
              Label {
                  id: toDateLabel
                  anchors.verticalCenter: dateToButton.verticalCenter
                  text: i18n.tr("To:")
              }

              /* Create a PopOver containing a DatePicker, necessary use a PopOver a container due to a bug on setting minimum date
                 with a simple DatePicker Component
              */
              Component {
                  id: popoverDateToPickerComponent
                  Popover {
                      id: popoverDateToPicker

                      DatePicker {
                          id: toTimePicker
                          mode: "Days|Months|Years"

                          /* when Datepicker is closed, is updated the date shown in the button */
                          Component.onDestruction: {
                              dateToButton.text = Qt.formatDateTime(toTimePicker.date, "dd MMMM yyyy")
                          }
                      }
                  }
              }

              /* open the popOver component with DatePicker */
              Button {
                  id: dateToButton
                  text: Qt.formatDateTime(new Date(), "dd MMMM yyyy")
                  width: units.gu(18)
                  onClicked: {
                     PopupUtils.open(popoverDateToPickerComponent, dateToButton)
                  }
              }

              //----------- meeting status selector --------------
              Component {
                      id: meetingTypeSelectorDelegate
                      OptionSelectorDelegate { text: name; subText: description; }
              }

              /* The meeting status shown in the combo box */
              ListModel {
                      id: meetingTypeModel
                      ListElement { name: "<b>Scheduled</b>"; description: "meetings to participate"; }
                      ListElement { name: "<b>Archived</b>"; description: "participated old meetings"; }
              }

              Label {
                  id: meetingStatusItemSelectorLabel
                  anchors.verticalCenter: meetingTypeItemSelector.Center
                  text: i18n.tr("Meeting status:")
              }

              Rectangle{
                  width:units.gu(27)
                  height:units.gu(7)

                  ListItem.ItemSelector {
                      id: meetingTypeItemSelector
                      delegate: meetingTypeSelectorDelegate
                      model: meetingTypeModel
                      containerHeight: itemHeight * 3
                  }
              }

              Button {
                  id: confirmDeleteButton
                  text:  i18n.tr("Delete")
                  iconName: "delete"
                  width: units.gu(16)
                  color: UbuntuColors.orange
                  onClicked: {
                     PopupUtils.open(confirmDeleteDialogueComponent, confirmDeleteButton)
                  }
              }
          }
}

