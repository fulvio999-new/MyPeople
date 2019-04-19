
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
