/*
    Utility functions used to validate user input
*/

//utility functions to decide what value display in case of missing field value from DB
function getValueTodisplay(val) {

   if (val === undefined)
      return ""
   else
      return val;
}

//check for mandatory fields and invalid characters
function checkinputText(fieldTxtValue)
{
    if (fieldTxtValue.length <= 0 || hasSpecialChar(fieldTxtValue))
       return false
    else
       return true;
}


// If regex matches, then string contains (at least) one special char.
function hasSpecialChar(fieldTxtValue) {
    return /[<>.?%#,;]|&#/.test(fieldTxtValue) ? true : false;
}


/* show new featurs for this MyPeople version */
function showNewFeatures(){
     if(settings.isFirstUse || settings.isNewVersion){
        PopupUtils.open(showNewFeaturesDialogue)
     }
}


/* Depending on the Page width of the Page (ie: the Device type) decide the Height of the scrollable */
function getContentHeight(){
    if(root.width > units.gu(80))
        return addPersonPage.height + addPersonPage.height/2 + units.gu(20)
    else
        return addPersonPage.height + addPersonPage.height/2 + units.gu(10) //phone
}

/* to calculate the amount to scrollable area height based on page in argument */
function getPageHeight(pageHeight){

    if(root.width > units.gu(80))
        return pageHeight.height + units.gu(20)
    else
        return pageHeight.height + units.gu(30) //phone
}

/* Depending on the Page widht of the Page (ie: the Device type) decide the Height of the scrollable */
function getHelpPageWidth(){
    if(root.width > units.gu(80))
        return peopleListPage.width/2 + units.gu(30) //tablet
    else
        return peopleListPage.width  //phone
}


/* Utility function to format the javascript date to have double digits for day and month (default is one digit in js)
       Example return date like: YYYY-MM-DD
       eg: 2017-04-28
*/
function formatDateToString(date)
{
    var dd = (date.getDate() < 10 ? '0' : '') + date.getDate();
    var MM = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1);
    var yyyy = date.getFullYear();

    return (yyyy + "-" + MM + "-" + dd);
}
