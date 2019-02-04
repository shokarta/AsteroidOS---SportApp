import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import 'DatabaseJS.js' as DatabaseJS

Item {
    id: parentObject

    function getDateFromBD(what) {
        if(profile['age']===0) { return ""; }
        else {
            if      (what==='day')      { return profile['age'].substr(8,2); }
            else if (what==='month')    { return profile['age'].substr(5,2); }
            else if (what==='year')     { return profile['age'].substr(0,4); }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: 'black'

        Rectangle {
            id: noteLabel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: mainWindow.height / 8
            color: 'transparent'

            Label {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: Math.min(mainWindow.height, mainWindow.width) / 20
                color: 'white'
                text: qsTrId("id-noteLabel") + ':' // Set your birthdate
            }
        }

        Rectangle {
            anchors.top: noteLabel.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: saveButton.top
            color: 'transparent'

            TextField {
                id: ageTextFieldDay
                anchors.top: parent.top
                anchors.topMargin: mainWindow.height / 16
                anchors.left: parent.left
                anchors.leftMargin: parent.width/2 - (ageTextFieldDay.width+dateDot.width+ageTextFieldMonth.width)/2
                width: mainWindow.width / 4
                focus: true
                text: getDateFromBD('day')
            }
            Label {
                id: dateDot
                anchors.left: ageTextFieldDay.right
                anchors.bottom: ageTextFieldDay.bottom
                font.pointSize: Math.min(mainWindow.height, mainWindow.width) / 20
                text: '.'
                color: 'darkgrey'
            }

            TextField {
                id: ageTextFieldMonth
                anchors.left: dateDot.right
                anchors.top: ageTextFieldDay.top
                width: mainWindow.width / 4
                text: getDateFromBD('month')
            }
            TextField {
                id: ageTextFieldYear
                anchors.top: ageTextFieldDay.bottom
                anchors.topMargin: mainWindow.height / 40
                anchors.horizontalCenter: parent.horizontalCenter
                width: mainWindow.width / 2
                text: getDateFromBD('year')
            }
        }

        Button {
            id: saveButton
            text: qsTrId("id-saveButton") // PROCEED
            height: mainWindow.height / 8

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            onClicked: {
                DatabaseJS.db_saveProfile2();
            }
        }
    }
}
