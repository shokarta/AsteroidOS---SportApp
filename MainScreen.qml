import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import 'DatabaseJS.js' as DatabaseJS

Item {
    anchors.fill: parent

    Component.onCompleted: {
        DatabaseJS.db_getProfile();
    }

    ListView {
        id: personalListView
        spacing: 2

        anchors.fill: parent

        model: ListModel {}

        Column {
            anchors.fill: parent
            spacing: 2
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

                    text: id
                }
            }
            Row {
                id: rowGender
                anchors.top: rowId.bottom
                Text {
                    horizontalAlignment: Text.AlignHCenter

                    text: 'gender'
                }
            }
            Row {
                id: rowAge
                anchors.top: rowGender.bottom
                Text {
                    horizontalAlignment: Text.AlignHCenter

                    text: 'age'
                }
            }
            Row {
                id: rowWeight
                anchors.top: rowAge.bottom
                Text {
                    horizontalAlignment: Text.AlignHCenter

                    text: 'weight'
                }
            }
        }

    }
}
