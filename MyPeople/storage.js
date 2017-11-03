/*
    This file contains utility functions to Create the dataBase and perform some operations on it
    (Note: database is save in the folder ~phablet/.local/share/<applicationName>.<appname>/Databases)
*/

//.import "DateUtils.js" as DateUtils

Qt.include("DateUtils.js")

//----------------------------------- UTILITY FUNCTIONS --------------------------------

/* Generate unique Id for the 'id' filed (ie the PK) Attache a suffix about the table name
   SCHEDULED: use autoincrement field instead of thie trick !!
*/
function getUUID(suffix){
    return  Math.floor((1 + Math.random()) * 10000) +"-"+suffix;
}


//----------------------------------------------------------------------------


    /* return a reference to the database. if not exist crete it under the hidden folder:
       ~phablet/.local/share/<applicationName>.<appname>/Databases
    */
    function getDatabase() {
        return LocalStorage.openDatabaseSync("MyPeopleApp_db", "1.0", "StorageDatabase", 1000000);
    }


    /* create the people table */
    function initialize() {
        var db = getDatabase();
        db.transaction(
           function(tx) {
                 tx.executeSql('CREATE TABLE IF NOT EXISTS people(id INT,name TEXT, surname TEXT, job TEXT, taxCode TEXT, vatNumber TEXT, birthday TEXT, address TEXT, phone TEXT, mobilePhone TEXT, email TEXT, skype TEXT, note TEXT )');
           });
    }

    /* set the default application configuration values. The user can customize them in configuration page */
    function setDefaultConfig(){

         if(settings.isFirstUse || settings.isNewVersion){
             console.log("Setting default config Param")
             settings.rememberMeetingsEnabled = true;
         }
    }

    /* Update people Table to add 'telegram' field added in MyPeople version 1.6 and set to 'N/A' for old records */
    function addTelegramField() {

        if(settings.addTelegramField){
            var db = getDatabase();
            db.transaction(
               function(tx) {
                    tx.executeSql('ALTER TABLE people ADD telegram TEXT');
               });

            db.transaction(
               function(tx) {
                    tx.executeSql("UPDATE people SET telegram='N/A'");
               });

             settings.addTelegramField = false
        }
    }

    /* Delete a table whose name is in argument */
    function deleteTable(tableName){

        var db = getDatabase();
        db.transaction(
           function(tx) {
                tx.executeSql('DELETE FROM '+tableName);
           });
    }


    /* Insert a new person */
    function insertPeople(id,name,surname,job,taxCode,vatNumber,birthday,address,phone,mobilePhone,email,skype,note,telegram) {
        var db = getDatabase();
        var res = "";
        db.transaction(function(tx) {
            var rs = tx.executeSql('INSERT INTO people VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?);', [id, name, surname, job, taxCode, vatNumber, birthday, address, phone, mobilePhone, email, skype, note, telegram]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        }
        );
        return res;
    }


    /* search a people usign the id assinged during the phase of insertion */
    function searchPeopleById(personId) {

        var db = getDatabase();
        var foundPeople = [];
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM people WHERE id=?;',[personId]);
            for(var i =0;i < rs.rows.length;i++){
                foundPeople.push(rs.rows.item(i));
            }
        }
        );
        return foundPeople[0];
    }


    /* search a people, using the search criteria provided by the user with the search box */
    function searchPeopleByNameOrSurname(searchedText) {

        var db = getDatabase();
        var foundPeople = [];
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM people WHERE name like ? OR surname like ? ORDER BY surname DESC;',['%'+searchedText+'%','%'+searchedText+'%']);
            for(var i =0;i < rs.rows.length;i++){
                foundPeople.push(rs.rows.item(i));
            }
        }
        );
        return foundPeople;
    }


    /* retrive all the people saved in the database */
    function loadAllPeople(){

           modelListPeople.clear();
           var db = Storage.getDatabase();
           db.transaction(function(tx) {
           var rs = tx.executeSql('SELECT * FROM people');
               for(var i =0;i < rs.rows.length;i++){
                   modelListPeople.append(rs.rows.item(i));
               }
            }
          );
     }


    /* Update an existing people */
    function updatePeople(id, name, surname, job, taxCode, vatNumber, birthday, address, phone, mobilePhone, email, skype, note, telegram){

        var db = getDatabase();
        var res = "";
        db.transaction(function(tx) {
            var rs = tx.executeSql('UPDATE people SET name=?, surname=?, job=?, taxCode=?, vatNumber=?, birthday=?, address=?, phone=?, mobilePhone=?, email=?, skype=?, note=?, telegram=? WHERE id=?;', [name, surname, job, taxCode, vatNumber, birthday, address, phone, mobilePhone, email, skype, note, telegram, id]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        }
        );
        return res;
    }

    /* delete an existing person */
    function deletePeopleById(id){

        var db = getDatabase();
        var res = "";
        db.transaction(function(tx) {
            var rs = tx.executeSql('DELETE FROM people  WHERE id=?;', [id]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        }
        );

        return res;
    }


    /* delete ALL Contacts in the database, leaving the table empty.
       Return the number on entry deleted
    */
    function deleteAllPeople(){
        var db = getDatabase();
        var rs = "";
        db.transaction(function(tx) {
            rs = tx.executeSql('DELETE FROM people;');
        }
        );

        return rs.rowsAffected;
    }


//----------------------------------------- MEETING (new features added from MyPeople 1.6) ---------------------------


    /* create the Meeting table(s) only if necessary (ie. update to MyPeople 1.6)
       Note: field 'participantId' is added for a next release features, currently is not used: it will be contain the id (P value of people tabel) of the archived people invited to participate at the meeting.
       I add it now so that is not necessary execute an Later sql script next time
    */
    function createMeetingTable() {

        if(settings.createMeetingTable){

            var db = getDatabase();
            db.transaction(
               function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS meeting(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, surname TEXT, subject TEXT, place TEXT, date TEXT, note TEXT, status TEXT, participantId TEXT)');
               });

             settings.createMeetingTable = false
        }
    }

    /* delete ALL meetings in the database, leaving the table empty.
       Return the number of entry deleted
    */
    function deleteAllMeeting(){

        var db = getDatabase();
        var rs = "";
        db.transaction(function(tx) {
            rs = tx.executeSql('DELETE FROM meeting;');
        }
        );

       return rs.rowsAffected;
    }


    /* Insert a new Meeting to partecipate with the provide person name/surname.
       The inserted meeting is placed in SCHEDULED status
    */
    function insertMeeting(name, surname, subject, place, date, note){

        var db = getDatabase();

        /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) because the input one from datePicker is like: (eg: 22 September 2016)
           With numeric format is better perform a time comparison */
        var fullDate = new Date (date);

        var meetingDateFormatted = formatFullDateToString(fullDate);

        /* to indicates that yo must participate at the meeting */
        var status = "SCHEDULED";
        var participantId = "not-used";
        var res = "";
        db.transaction(function(tx) {

            var rs = tx.executeSql('INSERT INTO meeting (name,surname,subject,place,date,note,status,participantId) VALUES (?,?,?,?,?,?,?,?);', [name, surname, subject, place, meetingDateFormatted, note, status, participantId]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        }
        );
        return res;

    }

    /* Deleted the meeting with the provided id */
    function deleteMeetingById(id){

        //console.log("Deleting meeting with id: "+id)
        var db = getDatabase();

        db.transaction(function(tx) {
              var rs = tx.executeSql('DELETE FROM meeting WHERE id =?;',[id]);
           }
        );
    }

    /* Update a Meeting whose id is in argument */
    function updateMeeting(name, surname, subject, place, date, note, id, status){

        //console.log("Updating meeting with id: "+id);

        /*
           return a formatted date like: 2017-04-30 (yyyy-mm-dd) because the input one from datePicker is like: (eg: 22 September 2016)
           with numeric format is better perform a time comparison
        */
        var fullDate = new Date (date);
        var meetingDateFormatted = formatFullDateToString(fullDate);

        var db = getDatabase();
        var res = "";

        db.transaction(function(tx) {
            var rs = tx.executeSql('UPDATE meeting SET name=?, surname=?, subject=?, place=?, date=?, note=?, status=? WHERE id=?;', [name, surname, subject, place, meetingDateFormatted, note, status, id]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        }
        );
        return res;
    }


    /*
       Search the meeting(s) with the people whose name/surname is in argument in the provide time range
       and with the given status
    */
    function searchMeetingByTimeAndPerson(name, surname, dateFrom, dateTo, status) {

        var db = getDatabase();
        meetingWithPersonFoundModel.clear();  /* the ListModel to fill */

        var to = new Date (dateTo);
        var from = new Date (dateFrom);

        /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
        var fullDateFrom = formatSimpleDateToString(from);
        var fullDateTo = formatSimpleDateToString(to);

        //console.log("Searching meeting from: "+fullDateFrom +" to: "+fullDateTo+ " with: "+name+ " "+ surname+ " with status: "+status);

        var rs = "";
        db.transaction(function(tx) {
           rs = tx.executeSql("SELECT * FROM meeting WHERE name=? AND surname=? and date(date) <= date('"+fullDateTo+"') and date(date) >= date('"+fullDateFrom+"') and status='"+status+"' ORDER BY date ASC;",[name,surname]);
        }
        );

        /* fill the meeting ListModel to be shown in the result page */
        for (var i = 0; i < rs.rows.length; i++) {
             meetingWithPersonFoundModel.append( {
                                  "id": rs.rows.item(i).id,
                                  "name": rs.rows.item(i).name,
                                  "surname": rs.rows.item(i).surname,
                                  "subject": rs.rows.item(i).subject,
                                  "place": rs.rows.item(i).place,
                                  "date": rs.rows.item(i).date,
                                  "subject": rs.rows.item(i).subject,
                                  "status": rs.rows.item(i).status,
                                  "note": rs.rows.item(i).note
              });
        }

        return rs;
    }

    /*
        Get the today meetings count for the 'remember me' function. The meeting with ARCHIVED status are excluded
    */
    function getTodayMeetings(){

        var db = getDatabase();
        var today = new Date ();
        var todayDateFormatted = formatSimpleDateToString(today);
        //console.log("Today date formatted is: "+todayDateFormatted);

        var rs = "";
        db.transaction(function(tx) {
            rs = tx.executeSql("SELECT count(id) as todayMeetings FROM meeting WHERE date(date) = date('"+todayDateFormatted+"')  and status='SCHEDULED' ORDER BY date ASC;");
        }
        );

        //console.log("Found today meetings: "+rs.rows.item(0).todayMeetings);

        return rs.rows.item(0).todayMeetings;
    }

    /*
      Search the ALL the meeting(s) inside the provided time range with ANY people with the provided status
    */
    function searchMeetingByTimeRange(dateFrom, dateTo, status) {

        var db = getDatabase();
        allPeopleMeetingFoundModel.clear(); /* the ListModel to fill */

        var to = new Date (dateTo);
        var from = new Date (dateFrom);

        /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
        var fullDateFrom = formatSimpleDateToString(from);
        var fullDateTo = formatSimpleDateToString(to);

        //console.log('Searching meeting from: '+fullDateFrom +" to: "+fullDateTo+ " with status: "+status);

        var rs = "";
        db.transaction(function(tx) {
            rs = tx.executeSql("SELECT * FROM meeting WHERE date(date) <= date('"+fullDateTo+"') and date(date) >= date('"+fullDateFrom+"') and status='"+status+"' ORDER BY date ASC;");
        }
        );

        /* fill the meeting ListModel to be shown in the result page */
        for (var i = 0; i < rs.rows.length; i++) {
             allPeopleMeetingFoundModel.append( {
                                  "id": rs.rows.item(i).id,
                                  "name": rs.rows.item(i).name,
                                  "surname": rs.rows.item(i).surname,
                                  "subject": rs.rows.item(i).subject,
                                  "place": rs.rows.item(i).place,
                                  "date": rs.rows.item(i).date,
                                  "subject": rs.rows.item(i).subject,
                                  "status": rs.rows.item(i).status,
                                  "note": rs.rows.item(i).note
              });
        }

        return rs;
    }


    /*
      Set the meeting at the provided status (ie: 'ARCHIVED' or 'SCHEDULED')
    */
    function updateMeetingStatus(meetingId, status) {

        //console.log("Setting meeting with id: "+id+ " to status: "+status);

        var db = getDatabase();
        var res = "";

        db.transaction(function(tx) {
            var rs = tx.executeSql('UPDATE meeting SET status=? WHERE id=?;', [status, meetingId]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        }
        );
        return res;
    }


  /*
     Maintenance function used to delete meetings inside the provided range and with the given status.
     Return the number of Deleted rows in the meeting table.
  */
  function deleteExpenseByCategoryAndTime(dateFrom, dateTo, status){

     var db = getDatabase();
     allPeopleMeetingFoundModel.clear(); /* the ListModel to fill */

     var to = new Date (dateTo);
     var from = new Date (dateFrom);

     /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
     var fullDateFrom = formatSimpleDateToString(from);
     var fullDateTo = formatSimpleDateToString(to);

     console.log('Deleting ALL meetings from date:'+fullDateFrom + ' to date:'+fullDateTo+ ' with status: '+status);

     var rs = ""
     db.transaction(function(tx) {
           /* for each subCategory calculate the amount to remove from the 'subcategory_report_current' table */
           rs = tx.executeSql("DELETE FROM meeting where date(date) <= date('"+fullDateTo+"') and date(date) >= date('"+fullDateFrom+"') and status=?;",[status]);
         }
     );

     return rs.rowsAffected;
 }
