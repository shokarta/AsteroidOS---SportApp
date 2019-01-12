import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import 'DatabaseJS.js' as DatabaseJS

Item {
    // DB Settings
    property string dbId: "MyDatabase"
    property string dbVersion: "1.0"
    property string dbDescription: "Database application"
    property int dbSize: 1000000
    property var db

    Component.onCompleted: {
        DatabaseJS.db_checkProfile();
    }
}
