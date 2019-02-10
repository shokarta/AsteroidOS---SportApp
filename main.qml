import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import 'DatabaseJS.js' as DatabaseJS

ApplicationWindow {
//Application {
    id: mainWindow
    visible: true
    width: 400
    height: 400
//    title: qsTrId("sport-spp") // Sports App

    property var currentWorkout
    property var mapWorkout
    property var profile
    property var lastIdCurrentWorkout: DatabaseJS.workout_getInfo()
    property var summaryWorkouts
    property var workout_id
    property var lastWorkoutSummary
    property var gpsPosition
    property var gps_lat
    property var gps_long

    property var genderChosen: profile['gender']
    property bool updateProfile

    // Watch setting
    property bool smSquared: false

    // DB Settings
    property string dbId: "MyDatabase"
    property string dbVersion: "1.0"
    property string dbDescription: "Database application"
    property int dbSize: 1000000
    property var db

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
    function getAge(dateString) {
        var today = new Date();
        var birthDate = new Date(dateString);
        var age = today.getFullYear() - birthDate.getFullYear();
        var m = today.getMonth() - birthDate.getMonth();
        if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
            age--;
        }
        return age;
    }
    function getDateFromTimestamp(time) {
        if (time > 0) {
            var date = new Date(time*1000);// hours part from the timestamp
            var day;
            return date.getDate() + '.' + date.getMonth()+1 + '.' + date.getFullYear();
        }
        else { return qsTrId("id-none"); } // None
    }
    function genderTranslate(gender) {
             if (gender==='Male')   { return qsTrId("id-rowGender-male"); }
        else if (gender==='Female') { return qsTrId("id-rowGender-female"); }
        else                        { return qsTrId("id-rowGender-none"); }
    }
    function sportTranslate(sport) {
             if (sport==='None')   { return qsTrId("id-sporttype-none"); }
        else if (sport==='Running') { return qsTrId("id-sporttype-running"); }
        else if (sport==='Walking') { return qsTrId("id-sporttype-walking"); }
        else if (sport==='Swimming') { return qsTrId("id-sporttype-swimming"); }
    }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: true
        preferredPositioningMethods: PositionSource.SatellitePositioningMethods

         onPositionChanged: {
            gpsPosition = positionSource.position.coordinate;
            gps_lat = gpsPosition.latitude;
            gps_long = gpsPosition.longitude;
        }
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
