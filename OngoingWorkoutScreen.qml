import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import 'DatabaseJS.js' as DatabaseJS


Rectangle {
    anchors.fill: parent

    property var getCurrentWorkout: DatabaseJS.workout_getInfo()
    property var getCurrentWorkoutInput: DatabaseJS.workout_getInfoFromWorkout(getCurrentWorkout['id'])
    property var getSportName: DatabaseJS.sports
    property bool timerPaused: false

    Rectangle {
        id: testRect
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50

        Label {
            id: rowWorkoutLabel
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 15
            text: '<b>Ongoing Workout:</b>'
        }
    }

    Rectangle {
        id: mainWorkoutScreen
        anchors.top: testRect.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Row {
            id: rowWorkoutType
            anchors.top: mainWorkoutScreen.top
            width: mainWorkoutScreen.width
            spacing: 5

            Column {
                width: rowWorkoutType.width / 2
                Text {
                    anchors.right: parent.right
                    font.pointSize: 12
                    text: '<b>Workout:</b>'
                }
            }
            Column {
                width: rowWorkoutType.width / 2
                Text {
                    font.pointSize: 12
                    text: getSportName[getCurrentWorkout['sport']].name
                }
            }
        }
        Row {
            id: rowTimeElapsed
            anchors.top: rowWorkoutType.bottom
            width: mainWorkoutScreen.width
            spacing: 5

            Column {
                width: rowTimeElapsed.width / 2
                Text {
                    anchors.right: parent.right
                    font.pointSize: 12
                    text: '<b>Time Elapsed:</b>'
                }
            }
            Column {
                width: rowTimeElapsed.width / 2
                Text {
                    font.pointSize: 12
                    text: getCurrentWorkout['time'] + ' s'
                }
            }
        }
        Row {
            id: rowBPM
            anchors.top: rowTimeElapsed.bottom
            width: mainWorkoutScreen.width
            spacing: 5

            Column {
                width: rowBPM.width / 2
                Text {
                    anchors.right: parent.right
                    font.pointSize: 12
                    text: '<b>BPM:</b>'
                }
            }
            Column {
                width: rowBPM.width / 2
                Text {
                    font.pointSize: 12
                    text: getCurrentWorkoutInput['bpm'].toFixed(2) + ' bpm' //SHOKARTA
                }
            }
        }
        Row {
            id: rowSpeed
            anchors.top: rowBPM.bottom
            width: mainWorkoutScreen.width
            spacing: 5

            Column {
                width: rowSpeed.width / 2
                Text {
                    anchors.right: parent.right
                    font.pointSize: 12
                    text: '<b>Current Speed:</b>'
                }
            }
            Column {
                width: rowSpeed.width / 2
                Text {
                    font.pointSize: 12
                    text: getCurrentWorkoutInput['speed'].toFixed(2) + ' km/h'
                }
            }
        }
        Row {
            id: rowTotalDistance
            anchors.top: rowSpeed.bottom
            width: mainWorkoutScreen.width
            spacing: 5

            Column {
                width: rowTotalDistance.width / 2
                Text {
                    anchors.right: parent.right
                    font.pointSize: 12
                    text: '<b>Total Distance:</b>'
                }
            }
            Column {
                width: rowTotalDistance.width / 2
                Text {
                    font.pointSize: 12
                    text: getCurrentWorkout['distance'].toFixed(2) + ' km'
                }
            }
        }
        Row {
            id: rowCaloriesBurned
            anchors.top: rowTotalDistance.bottom
            width: mainWorkoutScreen.width
            spacing: 5

            Column {
                width: rowCaloriesBurned.width / 2
                Text {
                    anchors.right: parent.right
                    font.pointSize: 12
                    text: '<b>Calories Burned:</b>'
                }
            }
            Column {
                width: rowCaloriesBurned.width / 2
                Text {
                    font.pointSize: 12
                    text: getCurrentWorkout['calories'].toFixed(2) + ' kcal'
                }
            }
        }
        Row {
            id: rowFluidLoss
            anchors.top: rowCaloriesBurned.bottom
            width: mainWorkoutScreen.width
            spacing: 5

            Column {
                width: rowFluidLoss.width / 2
                Text {
                    anchors.right: parent.right
                    font.pointSize: 12
                    text: '<b>Fluid Loss:</b>'
                }
            }
            Column {
                width: rowFluidLoss.width / 2
                Text {
                    font.pointSize: 12
                    text: getCurrentWorkout['hydration'].toFixed(2) + ' l'
                }
            }
        }
        Row {
            id: rowProgress
            anchors.top: rowFluidLoss.bottom
            width: mainWorkoutScreen.width
            spacing: 5

            Column {
                width: rowProgress.width / 2
                Text {
                    anchors.right: parent.right
                    font.pointSize: 12
                    text: '<b>Progress:</b>'
                }
            }
            Column {
                width: rowProgress.width / 2
                Text {
                    id: textProgress
                    font.pointSize: 12
                    text: 'IN PROGRESS'
                }
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
                    textProgress.text = 'IN PROGRESS';
                    elapsedTimer.start();
                    timerPaused = false;
                }
                else {
                    pauseButton.text = 'CONTINUE';
                    textProgress.text = 'PAUSED';
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
                textProgress.text = 'STOPPED';
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
}
