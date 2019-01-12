import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import 'DatabaseJS.js' as DatabaseJS

Item {
    anchors.fill: parent
    property var getCurrentWorkout: DatabaseJS.workout_getInfo()
    property var getSportName: DatabaseJS.sports

    Row {
        id: rowOngoingWorkout
        anchors.top: parent.top
        Text {
            text: 'Ongoing Workout:'
        }
    }
    Row {
        id: rowWorkoutType
        anchors.top: rowOngoingWorkout.bottom
        Text {
            id: textWorkoutType
            text: 'Workout: ' + getSportName[getCurrentWorkout['sport']].name
        }
    }
    Row {
        id: rowTimeElapsed
        anchors.top: rowWorkoutType.bottom
        Text {
            id: textTimeElapsed
            text: 'Time Elapsed: ' + getCurrentWorkout['time'] + 's'
        }
    }
    Row {
        id: rowTotalDistance
        anchors.top: rowTimeElapsed.bottom
        Text {
            id: textTotalDistance
            text: 'Total Distance: ' + getCurrentWorkout['distance'].toFixed(2) + 'km'
        }
    }
    Row {
        id: rowCaloriesBurned
        anchors.top: rowTotalDistance.bottom
        Text {
            id: textCaloriesBurned
            text: 'Calories Burned: ' + getCurrentWorkout['calories'].toFixed(2) + 'kcal'
        }
    }
    Row {
        id: rowFluidLoss
        anchors.top: rowCaloriesBurned.bottom
        Text {
            id: textFluidLoss
            text: 'Fluid Loss: ' + getCurrentWorkout['hydration'].toFixed(2) + 'l'
        }
    }
    Row {
        id: rowProgress
        anchors.top: rowFluidLoss.bottom
        Text {
            id: textProgress
            text: 'Progress: IN PROGRESS'
        }
    }

    Button {
        id: pauseButton
        text: 'PAUSE' // PAUSE
        width: parent.width
        height: 50

        anchors {
            left: parent.left
            right: parent.right
            bottom: saveButton.top
        }

        onClicked: {
            elapsedTimer.stop();
            textProgress.text = 'Progress: PAUSED';
            // swhich to PAUSE-PLAY
        }
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
            DatabaseJS.workout_stop(getCurrentWorkout['id']); // not programmed yet
            textProgress.text = 'Progress: STOPPED';
        }
    }

    Timer  {
        id: elapsedTimer
        interval: 3000
        running: true
        repeat: true
        onTriggered: DatabaseJS.workout_refresh(getCurrentWorkout['id']);
    }
}
