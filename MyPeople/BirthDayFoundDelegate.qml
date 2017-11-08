import QtQuick 2.4
import Ubuntu.Components 1.3


//Component {

//   id: todaybirthDayComponent

//    todayBirthdayModel.append( {
//                         "id": rs.rows.item(i).id,
//                         "name": rs.rows.item(i).name,
//                         "surname": rs.rows.item(i).surname,
//                         "phone": rs.rows.item(i).phone,
//                         "email": rs.rows.item(i).email,
//     });
Item {
 id: todaybirthDayComponent
    Column {
        id:personInfoColumn
//        width: parent.width
//        height: parent.height
        spacing: 1

         Row {
              width: parent.width
               height: units.gu(3)
               spacing: units.gu(3)

        Label {
            text: name
            font.bold: true;
            font.pointSize: units.gu(1.3)
        }

        Label {
            text:surname
            font.bold: true;
            font.pointSize: units.gu(1.3)
        }

        Label {
            text: "phone: "+phone
            fontSize: "small"
        }

        Label {
            text: "mail: "+email
            fontSize: "small"
        }

         }
    }


   }

//}
