import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import 'DatabaseJS.js' as DatabaseJS

Item {
    id: mainItem
    anchors.fill: parent

    property var getProfile: DatabaseJS.db_getProfile()

    Column {
        anchors.fill: parent
        spacing: 2

        Image {
            width: 130; height: 100
            fillMode: Image.PreserveAspectFit
            source: 'pics/' + getProfile['gender'] + '.png'
        }
        // sloucit 4 radky, zobrazit avatar gender
    }
    Column {
        anchors.fill: parent
        spacing: 2

        Row {
            id: rowId
            anchors.top: parent.top

            Text {
                horizontalAlignment: Text.AlignHCenter
                text: getProfile['id']
            }
        }
        Row {
            id: rowGender
            anchors.top: rowId.bottom
            Text {
                horizontalAlignment: Text.AlignHCenter
                text: getProfile['gender']
            }
        }
        Row {
            id: rowAge
            anchors.top: rowGender.bottom
            Text {
                horizontalAlignment: Text.AlignHCenter
                text: getProfile['age']
            }
        }
        Row {
            id: rowWeight
            anchors.top: rowAge.bottom
            Text {
                horizontalAlignment: Text.AlignHCenter
                text: getProfile['weight']
            }
        }
    }

    Button {
        id: saveButton
        text: 'START THE WORKOUT' //
        width: parent.width
        height: 50

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        onClicked: {
            DatabaseJS.workout_newstart();
        }
    }
}
