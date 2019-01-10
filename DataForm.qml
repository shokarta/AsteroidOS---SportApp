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

        delegate: Text {
            anchors {
                left: parent.left
                right: parent.right
            }
            font.pointSize: 20
            horizontalAlignment: Text.AlignHCenter

            text: id
        }
    }
}
