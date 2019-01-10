import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import 'DatabaseJS.js' as DatabaseJS

Item {
    id: parentObject
    anchors.fill: parent

    Column {
        anchors.fill: parent

        spacing: 2

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2
            Label {
                id: registerDoneLabel
                text: 'All done!'
            }
        }
    }

    Button {
        id: saveButton
        text: 'RUN THE APP' // START
        width: parent.width
        height: 50

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        onClicked: {
            DatabaseJS.push_start();
        }
    }
}
