import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import 'DatabaseJS.js' as DatabaseJS

Item {
    id: mainItem
    anchors.fill: parent

    property var record

    Component.onCompleted: {
        DatabaseJS.db_getProfile();
    }

    record: DatabaseJS.db_getProfile()

}
