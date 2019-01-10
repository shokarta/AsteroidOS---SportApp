import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import 'DatabaseJS.js' as DatabaseJS

Item {
    id: parentObject

    Column {

        anchors.fill: parent
        spacing: 2

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2
            Label {
                id: genderLabel
                text: 'In order to provide accurate calculations we need to set up your profile first'
            }
        }


        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            ComboBox {
                id: genderTextField
                currentIndex: 0
                editable: false
                width: parent.width
                model: ListModel {
                    id: genderListModel
                    ListElement { text: "Male" }
                    ListElement { text: "Female" }
                }
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
