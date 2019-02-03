import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import 'DatabaseJS.js' as DatabaseJS

Item {

    Component.onCompleted: {
        DatabaseJS.db_createTable();
        DatabaseJS.workout_getInfo();
    }
}
