TEMPLATE = aux
TARGET = MyPeople

RESOURCES += MyPeople.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  MyPeople.apparmor \
               MyPeople.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)               

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               MyPeople.desktop

#specify where the qml/js files are installed to
qml_files.path = /MyPeople
qml_files.files += $${QML_FILES}

#specify where the config files are installed to
config_files.path = /MyPeople
config_files.files += $${CONF_FILES}

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /MyPeople
desktop_file.files = $$OUT_PWD/MyPeople.desktop
desktop_file.CONFIG += no_check_exist

INSTALLS+=config_files qml_files desktop_file

DISTFILES += \
    AddPerson.qml \
    DbListview.qml \
    DbSaver.qml \
    ExampleSearch.qml \
    utility.js \
    PeopleListDelegate.qml \
    uicomponents/PersonDetailsPage.qml \
    uicomponents/HighlightComponent.qml \
    uicomponents/InsertPersonForm.qml \
    uicomponents/DetailsPersonForm.qml \
    Settings.qml \
    ProductNewFeatures.qml \
    DatabaseImporter.qml \
    DataBaseEraser.qml \
    OperationResult.qml \
    ItemNotFound.qml \
    AboutProduct.qml \
    ConfirmDelete.qml \
    ConfirmInsert.qml \
    InsertPersonFormPhone.qml \
    DetailsPersonTablet.qml \
    DetailsPersonPhone.qml \
    ConfirmUpdate.qml \
    NewMeetingTablet.qml \
    NewMeetingPhone.qml \
    SearchMeetingWithPersonTablet.qml \
    SearchMeetingWithPersonPhone.qml \
    ConfirmSaveMeeting.qml \
    EditMeetingTablet.qml \
    EditMeetingPhone.qml \
    ConfirmUpdateMeeting.qml \
    AllPeopleMeetingFoundDelegate.qml \
    AppConfigurationPhone.qml \
    AppConfigurationTablet.qml \
    TodayMeetingsAlert.qml \
    DateUtils.js \
    birthday.png

