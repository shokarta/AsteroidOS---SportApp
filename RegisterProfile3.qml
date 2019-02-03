import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import 'DatabaseJS.js' as DatabaseJS

Item {
    id: parentObject

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
                text: 'Set your weight in kg:'
                color: 'white'
            }
        }

        Rectangle {
            anchors.top: noteLabel.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: mainWindow.height / 8
            color: 'transparent'

            TextField {
                id: weightTextField
                anchors.top: parent.top
                anchors.topMargin: mainWindow.height / 16
                anchors.horizontalCenter: parent.horizontalCenter
                width: mainWindow.width / 4
                text: profile['weight'] ? profile['weight'] : '';
            }
        }

        Button {
            id: saveButton
            text: 'PROCEED' // SAVE
            height: mainWindow.height / 8

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            onClicked: {
                DatabaseJS.db_saveProfile3();
            }
        }
    }
}
