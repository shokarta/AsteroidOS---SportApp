import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import 'DatabaseJS.js' as DatabaseJS

Rectangle {
    id: parentObject
    anchors.fill: parent

    Rectangle {
        id: noteLabel
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 100

        Label {
            id: label1
            anchors.bottom: label2.top
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 15
            text: 'In order to provide accurate'
        }
        Label {
            id: label2
            anchors.bottom: label3.top
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 15
            text: 'calculations we need to'
        }
        Label {
            id: label3
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 15
            text: 'set up your profile first'
        }
    }

    Rectangle {
        anchors.top: noteLabel.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 50

        ComboBox {
            id: genderTextField
            currentIndex: 0
            editable: false
            width: 200
            anchors.horizontalCenter: parent.horizontalCenter
            model: ListModel {
                id: genderListModel
                ListElement { text: "Male" }
                ListElement { text: "Female" }
            }
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
            DatabaseJS.db_saveProfile1();
        }
    }
}
