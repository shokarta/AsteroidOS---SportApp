import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import 'DatabaseJS.js' as DatabaseJS

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 400
    height: 400
    title: qsTr("Sports App")

    // Watch setting
    property bool smSquared: false

    // DB Settings
    property string dbId: "MyDatabase"
    property string dbVersion: "1.0"
    property string dbDescription: "Database application"
    property int dbSize: 1000000
    property var db

    property var getProfile
    property var getSummaryWorkouts
    property var getCurrentWorkout: DatabaseJS.workout_getInfo()
    property var getCurrentWorkoutInput: DatabaseJS.workout_getInfoFromWorkout(getCurrentWorkout['id'])

    ListModel { id: getCurrentWorkoutInputTest }

    // constructor
    Component.onCompleted: {
        // Creates tables if not already created
        DatabaseJS.db_createTable();
        getProfile = DatabaseJS.db_getProfile();
        getSummaryWorkouts = DatabaseJS.getSummaryWorkouts();
    }

    function formatSecs(secs) {
        var h = Math.floor(secs/3600);
        var m = Math.floor((secs-(h*3600))/60);
        var s = Math.floor(secs-(h*3600)-(m*60));

        function pad(d) { return (d < 10) ? '0' + d : d; }

        if(h>0) { return (h + ':' + pad(m) + ':' + pad(s)); }
        else { return (pad(m) + ':' + pad(s)); }
    }
    function formatSecs2(secs) {

        return (secs < 10) ? '0' + secs : secs;
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: welcomeScreen
        //currentIndex: 1
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
