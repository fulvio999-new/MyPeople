/*
Utility to manage calculate some measurement given current  screen orientation and current page Height
*/
function getScrollHeight(isHorizontalScreen, currentPageHeight){

    if(isHorizontalScreen){
        return currentPageHeight * 2 + units.gu(45);
    }else{
        return currentPageHeight * 2 + units.gu(20);
    }
}

/* As the 'getScrollHeight' function but with custom values for New Meeting creation pages */
function getScrollHeightForNewMeetingPage(isHorizontalScreen, currentPageHeight){

    if(isHorizontalScreen){
        return currentPageHeight * 2 + units.gu(25);
    }else{
        return currentPageHeight * 2 + units.gu(20);
    }
}


/* As the 'getScrollHeight' function but with custom values for EditMeeting pages */
function getScrollHeightForEditMeetingPage(isHorizontalScreen, currentPageHeight){

    if(isHorizontalScreen){
        return currentPageHeight * 2 + units.gu(10);
    }else{
        return currentPageHeight * 2 + units.gu(20);
    }
}
