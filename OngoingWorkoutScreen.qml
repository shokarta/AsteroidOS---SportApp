import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import 'DatabaseJS.js' as DatabaseJS

Rectangle {

    id: mainOngoingWorkout
    anchors.fill: parent
    color: "black"

    property var getSportName: DatabaseJS.sports
    property bool timerPaused: false
    property int countTimer: 0
    property int masterTimerCount: 0

    Component.onCompleted: {
        DatabaseJS.workout_getInfo().lastIdCurrentWorkout = { id: 0, sport: 0, distance: 0, time: 0, calories: 0, hydration: 0 };
        DatabaseJS.workout_getInfoFromWorkout(getCurrentWorkout['id']).lastInfoCurrentWorkout = { bpm: 0, speed: 0 };
    }

    // CALORIES
    Rectangle {
        id: mainOngoingWorkoutCalories
        anchors.top: mainOngoingWorkout.top
        anchors.left: mainOngoingWorkout.left
        anchors.right: mainOngoingWorkout.right
        anchors.leftMargin: 30
        height: mainOngoingWorkout.height / 4
        color: "transparent"

        Label {
            id: mainOngoingWorkoutCaloriesLabel
            anchors.horizontalCenter: mainOngoingWorkoutCalories.horizontalCenter
            anchors.bottom: mainOngoingWorkoutCalories.bottom
            font.pointSize: 50
            text: Math.floor(getCurrentWorkout['calories']) + ' kcal'
            color: "white"
        }
    }

    // BPM
    Rectangle {
        id: mainOngoingWorkoutBPM
        anchors.top: mainOngoingWorkoutCalories.bottom
        anchors.left: mainOngoingWorkout.left
        width: mainOngoingWorkout.width / 5 * 3
        height: mainOngoingWorkout.height / 2.67
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
        anchors.right: mainOngoingWorkout.right
        width: mainOngoingWorkout.width / 5 * 2
        height: mainOngoingWorkout.height / 2.67
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
        anchors.left: mainOngoingWorkout.left
        width: mainOngoingWorkout.width / 5 * 3
        height: mainOngoingWorkout.height / 4
        color: "transparent"

        Label {
            id: mainOngoingWorkoutTimeLabel
            anchors.verticalCenter: mainOngoingWorkoutTime.verticalCenter
            anchors.horizontalCenter: mainOngoingWorkoutTime.horizontalCenter
            font.pointSize: 40
            text: formatSecs(masterTimerCount)
            color: "white"
        }
    }
    // DISTANCE
    Rectangle {
        id: mainOngoingWorkoutDistance
        anchors.top: mainOngoingWorkoutBPM.bottom
        anchors.right: mainOngoingWorkout.right
        width: mainOngoingWorkout.width / 5 * 2
        height: mainOngoingWorkout.height / 4
        color: "transparent"

        Label {
            id: mainOngoingWorkoutDistanceLabel
            anchors.right: mainOngoingWorkoutDistance.right
            anchors.bottom: mainOngoingWorkoutDistance.bottom
            font.pointSize: 30
            text: getCurrentWorkout['distance'].toFixed(2) + 'km'
            color: "darkgreen"
        }
    }

    // STOP BUTTON
    DelayButton  {
        id: stopButton
        text: elapsedTimer.running ? "PAUSE" : "CONTINUE"
        delay: 2000
        width: mainOngoingWorkout.width
        height: 50

        anchors {
            left: mainOngoingWorkout.left
            right: mainOngoingWorkout.right
            bottom: mainOngoingWorkout.bottom
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
