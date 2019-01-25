import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import 'DatabaseJS.js' as DatabaseJS

Item {
    id: parentObject

    Rectangle {
        id: noteLabel
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50

        Label {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 15
            text: 'Please set your current weight in kg:'
        }
    }

    Rectangle {
        anchors.top: noteLabel.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 50

        TextField {
            id: weightTextField
            anchors.horizontalCenter: parent.horizontalCenter
            width: 100
        }
    }

    Button {
        id: saveButton
        text: 'PROCEED' // SAVE
        width: parent.width
        height: 50

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
