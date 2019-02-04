import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import 'DatabaseJS.js' as DatabaseJS

Item {
    id: parentObject

    Component.onCompleted: {
        if (updateProfile==true) { parentObject.anchors.fill = parent; }
        if(profile['gender']) {
            genderChosen = profile['gender'];
            if(genderChosen==='Male') { genderMale.source = 'pics/Male_clicked.png'; }
            else if (genderChosen==='Female') { genderFemale.source = 'pics/Female_clicked.png'; }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"

        Rectangle {
            id: noteLabel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: mainWindow.height / 8
            color: "transparent"

            Label {
                id: label1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                font.pointSize: Math.min(mainWindow.height, mainWindow.width) / 20
                text: qsTrId("id-label1") + ':' // Choose your gender
                color: "white"
            }
        }

        Rectangle {
            anchors.top: noteLabel.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 50
            color: "transparent"

            Image {
                id: genderMale
                anchors.top: parent.top
                anchors.topMargin: parent.height/2 - genderMale.height/2
                anchors.left: parent.left
                anchors.leftMargin: parent.width/4 - genderMale.width/2
                fillMode: Image.PreserveAspectFit
                height: Math.min(mainWindow.height, mainWindow.width) / 1.42
                source: if(genderChosen==="Male") { genderMale.source = 'pics/Male_clicked.png'; genderChosen='Male'; } else { genderMale.source = 'pics/Male_unclicked.png'; }
            }
            MouseArea {
                anchors.fill: genderMale
                onClicked: {
                    genderMale.source = 'pics/Male_clicked.png';
                    genderFemale.source = 'pics/Female_unclicked.png';
                    genderChosen = 'Male';
                    DatabaseJS.db_saveProfile1(genderChosen);
                }
            }

            Image {
                id: genderFemale
                anchors.top: parent.top
                anchors.topMargin: parent.height/2 - genderFemale.height/2
                anchors.right: parent.right
                anchors.rightMargin: parent.width/4 - genderFemale.width/2
                fillMode: Image.PreserveAspectFit
                height: Math.min(mainWindow.height, mainWindow.width) / 1.42
                source: if(genderChosen==='Female') { genderFemale.source = 'pics/Female_clicked.png'; genderChosen='Female'; } else { genderFemale.source = 'pics/Female_unclicked.png'; }
            }
            MouseArea {
                anchors.fill: genderFemale
                onClicked: {
                    genderMale.source = 'pics/Male_unclicked.png';
                    genderFemale.source = 'pics/Female_clicked.png';
                    genderChosen = 'Female';
                    DatabaseJS.db_saveProfile1(genderChosen);
                }
            }
        }
    }
}
