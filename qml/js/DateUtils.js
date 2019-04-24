
/* Various utility to manage Date with javascript */

/*
  Utility function to return date like: YYYY-MM-DD hh:mm
  Input date is like: 06 September 2017 14:33
  If missing this method add double digits to day,month,hours,minutes
*/
function formatFullDateToString(date)
{
  //console.log('Formatting date: '+date)  ;

  var dd = (date.getDate() < 10 ? '0' : '') + date.getDate();
  var MM = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1);
  var yyyy = date.getFullYear();
  var hh = (date.getHours() < 10 ? '0' : '') + date.getHours();
  var mm = (date.getMinutes() < 10 ? '0' : '') + date.getMinutes();

  return (yyyy + "-" + MM + "-" + dd+ " "+hh+ ":"+mm);
}


/* utility function to return date like: YYYY-MM-DD If missing is added a double digit on day and month  */
function formatSimpleDateToString(date)
{
  var dd = (date.getDate() < 10 ? '0' : '') + date.getDate();
  var MM = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1);
  var yyyy = date.getFullYear();

  return (yyyy + "-" + MM + "-" + dd);
}


/* Return the todayDate with UTC values set to zero */
function getTodayDate(){

        var today = new Date();
        //today.setUTCHours(0);
        //today.setUTCMinutes(0);
        today.setUTCSeconds(0);
        today.setUTCMilliseconds(0);

        return today;
}

/*
  Return true if the chosen meeting date is NOT before today. That means that user is creating an expired meeting,
 is necessary notify That
*/
function isMeetingDateValid(chosenMeetingDate, chosenMeetingHour){

    var todayDate = DateUtils.getTodayDate();

    var meetingDate = new Date(chosenMeetingDate);
    meetingDate.setHours(chosenMeetingHour.split(':')[0]);
    meetingDate.setMinutes(chosenMeetingHour.split(':')[1]);
    meetingDate.setSeconds(0);
    meetingDate.setMilliseconds(0);

    if(meetingDate <= todayDate){
       return false;
    }else{
       return true;
    }
}
