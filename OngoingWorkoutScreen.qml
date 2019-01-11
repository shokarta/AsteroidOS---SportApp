import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import 'DatabaseJS.js' as DatabaseJS

Item {
    anchors.fill: parent
    property var getProfile: DatabaseJS.workout_getInfo()

    Row {
        Text: 'Ongoing Workout:'
        Text.bold: true
    }
    Row {
        Text: 'Workout: ' + workout_getInfo['sport']
    }
    Row {
        Text: 'Time Elapsed: ' + workout_getInfo['time'] + 's'
    }
    Row {
        Text: 'Total Distance: ' + workout_getInfo['distance'] + 'km'
    }
    Row {
        Text: 'Calories Burned: ' + workout_getInfo['calories'] + 'kcal'
    }
    Row {
        Text: 'Fluid Loss: ' + workout_getInfo['hydration'] + 'l'
    }

    Button {
        id: saveButton
        text: 'STOP' // STOP
        width: parent.width
        height: 50

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        onClicked: {
            DatabaseJS.workout_stop(workout_getInfo['id_workout']);
        }
    }

    Timer  {
        id: elapsedTimer
        interval: 3000
        running: true
        repeat: true
        onTriggered: DatabaseJS.workout_refresh(workout_getInfo['id_workout']);
    }
}
