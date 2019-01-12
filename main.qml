import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import 'DatabaseJS.js' as DatabaseJS

ApplicationWindow {
    visible: true
    width: 400
    height: 400
    title: qsTr("Sports App")

    // DB Settings
    property string dbId: "MyDatabase"
    property string dbVersion: "1.0"
    property string dbDescription: "Database application"
    property int dbSize: 1000000
    property var db

    // constructor
    Component.onCompleted: {
        // Creates tables if not already created
//        DatabaseJS.db_dropTable();
        DatabaseJS.db_createTable();

    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: welcomeScreen
    }

    Component {
        id: welcomeScreen
        ScreenWelcome {}
    }
    Component {
        id: registerProfile1
        RegisterProfile1 {}
    }
    Component {
        id: registerProfile2
        RegisterProfile2 {}
    }
    Component {
        id: registerProfile3
        RegisterProfile3 {}
    }
    Component {
        id: mainScreen
        MainScreen {}
    }
    Component {
        id: ongoingWorkoutScreen
        OngoingWorkoutScreen {}
    }
}
