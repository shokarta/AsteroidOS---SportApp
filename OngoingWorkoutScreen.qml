import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import 'DatabaseJS.js' as DatabaseJS

Item {
    anchors.fill: parent
    property var getCurrentWorkout: DatabaseJS.workout_getInfo()
    property var getCurrentWorkoutInput: DatabaseJS.workout_getInfoFromWorkout(getCurrentWorkout['id'])
    property var getSportName: DatabaseJS.sports
    property bool timerPaused: false

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
        id: rowRPM
        anchors.top: rowTimeElapsed.bottom
        Text {
            id: textRPM
            text: 'RPM: ' + getCurrentWorkoutInput['bpm'].toFixed(2) + 'bpm' //SHOKARTA
        }
    }
    Row {
        id: rowSpeed
        anchors.top: rowRPM.bottom
        Text {
            id: textSpeed
            text: 'Current Speed: ' + getCurrentWorkoutInput['speed'].toFixed(2) + 'km/h' //SHOKARTA
        }
    }
    Row {
        id: rowTotalDistance
        anchors.top: rowSpeed.bottom
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
            bottom: stopButton.top
        }

        onClicked: {
            if(timerPaused == true) {
                pauseButton.text = 'PAUSE';
                textProgress.text = 'Progress: IN PROGRESS';
                elapsedTimer.start();
                timerPaused = false;
            }
            else {
                pauseButton.text = 'CONTINUE';
                textProgress.text = 'Progress: PAUSED';
                elapsedTimer.stop();
                timerPaused = true;
            }
        }
    }

    Button {
        id: stopButton
        text: 'STOP' // STOP
        width: parent.width
        height: 50

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        onClicked: {
            stopButton.text = 'PLEASE WAIT...';
            textProgress.text = 'Progress: STOPPED';
            elapsedTimer.stop();
            DatabaseJS.push_start(mainScreen);
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
