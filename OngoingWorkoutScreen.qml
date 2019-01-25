import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import 'DatabaseJS.js' as DatabaseJS

Item {

    property var getSportName: DatabaseJS.sports
    property bool timerPaused: false
    property int countTimer: 0
    property int masterTimerCount: 3570

    Component.onCompleted: {
        DatabaseJS.workout_getInfo().lastIdCurrentWorkout = { id: 0, sport: 0, distance: 0, time: 0, calories: 0, hydration: 0 };
        DatabaseJS.workout_getInfoFromWorkout(getCurrentWorkout['id']).lastInfoCurrentWorkout = { bpm: 0, speed: 0 };
    }

    Rectangle {
        id: mainOngoingWorkout
        anchors.fill: parent
        color: "black"

        Image {
            verticalAlignment: Image.AlignVCenter
            anchors.fill: parent
            width: parent.width
            height: parent.height
            source: 'pics/' + (smSquared ? 'squared' : 'circled') + '.png'
        }

        // CALORIES
        Rectangle {
            id: mainOngoingWorkoutCalories
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height / 4
            color: "transparent"

            Label {
                id: mainOngoingWorkoutCaloriesLabel
                anchors.horizontalCenter: mainOngoingWorkoutCalories.horizontalCenter
                anchors.bottom: mainOngoingWorkoutCalories.bottom
                font.pointSize: 40
                text: Math.floor(getCurrentWorkout['calories']) + ' kcal'
                color: "white"
            }
        }

        // BPM
        Rectangle {
            id: mainOngoingWorkoutBPM
            anchors.top: mainOngoingWorkoutCalories.bottom
            anchors.left: parent.left
            width: parent.width / 5 * 3
            height: parent.height / 2.67
            color: "transparent"

            Label {
                id: mainOngoingWorkoutBPMLabel
                anchors.right: mainOngoingWorkoutBPM.right
                anchors.verticalCenter: mainOngoingWorkoutBPM.verticalCenter
                font.pointSize: 90
                text: getCurrentWorkoutInput['bpm']
                color: "green"
            }
        }
        Rectangle {
            id: mainOngoingWorkoutBPMIcon
            anchors.top: mainOngoingWorkoutCalories.bottom
            anchors.right: parent.right
            width: parent.width / 5 * 2
            height: parent.height / 2.67
            color: "transparent"

            AnimatedImage {
                anchors.verticalCenter: mainOngoingWorkoutBPMIcon.verticalCenter
                anchors.horizontalCenter: mainOngoingWorkoutBPMIcon.horizontalCenter
                height: mainOngoingWorkoutBPMIcon.height / 5 * 3
                fillMode: Image.PreserveAspectFit
                source: 'pics/heartrate.gif'
            }
        }

        // TIME ELAPSED
        Rectangle {
            id: mainOngoingWorkoutTime
            anchors.top: mainOngoingWorkoutBPM.bottom
            anchors.left: parent.left
            width: (parent.width / 5 * 3) - 20
            height: parent.height / 4
            color: "transparent"

            Label {
                id: mainOngoingWorkoutTimeLabel
                anchors.top: mainOngoingWorkoutTime.top
                anchors.right: mainOngoingWorkoutTime.right
                anchors.rightMargin: 15
                font.pointSize: 35
                text: formatSecs(masterTimerCount)
                color: "white"
            }
        }
        // DISTANCE
        Rectangle {
            id: mainOngoingWorkoutDistance
            anchors.top: mainOngoingWorkoutBPM.bottom
            anchors.right: parent.right
            width: (parent.width / 5 * 2) + 20
            height: parent.height / 4
            color: "transparent"

            Label {
                id: mainOngoingWorkoutDistanceLabel
                anchors.top: mainOngoingWorkoutDistance.top
                anchors.left: mainOngoingWorkoutDistance.left
                font.pointSize: 30
                text: getCurrentWorkout['distance'].toFixed(2)
                color: "darkgreen"
            }
            Label {
                id: mainOngoingWorkoutDistanceUnitLabel
                anchors.bottom: mainOngoingWorkoutDistanceLabel.bottom
                anchors.left: mainOngoingWorkoutDistanceLabel.right
                anchors.bottomMargin: 2
                font.pointSize: 20
                text: 'km'
                color: "white"
            }
        }

        // STOP BUTTON
        DelayButton  {
            id: stopButton
            text: elapsedTimer.running ? "PAUSE" : "CONTINUE"
            delay: 2000
            width: parent.width
            height: 70

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            background:
                Rectangle {
                id: mainBackground
                anchors.centerIn: parent
                border.width: 3
                border.color: "darkgreen"
                radius: 15
                width: parent.height
                height: parent.width
                rotation: 270
                gradient: Gradient {
                    GradientStop { position: stopButton.progress-0.1; color: "green" }
                    GradientStop { position: stopButton.progress; color: "lightgreen" }
                }
            }

            signal myPressAndHold()

            onPressed: {
                elapsedTimer.running ? masterTimer.stop() : masterTimer.start();
                elapsedTimer.running ? elapsedTimer.stop() : elapsedTimer.start();
                pressAndHoldTimer.start();
            }
            onReleased: {
                pressAndHoldTimer.stop();
            }
            onMyPressAndHold: {
                elapsedTimer.stop();
                masterTimer.stop();
                DatabaseJS.push_start(mainScreen);
            }

            Timer {
                id: pressAndHoldTimer
                interval: 2000
                running: false
                repeat: false
                onTriggered: {
                    parent.myPressAndHold();
                }
            }
        }

        Timer  {
            id: elapsedTimer
            interval: 3000
            running: true
            repeat: true
            onTriggered: {
                countTimer = countTimer + (elapsedTimer.interval/1000);
                DatabaseJS.workout_refresh(getCurrentWorkout['id'], countTimer);
                countTimer = 0;
            }
        }
        Timer  {
            id: masterTimer
            interval: 1000
            running: true
            repeat: true
            onTriggered: masterTimerCount += 1
        }
    }
}
