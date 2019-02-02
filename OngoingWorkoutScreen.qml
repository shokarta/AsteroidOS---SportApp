import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import 'DatabaseJS.js' as DatabaseJS

Item {

    property var getSportName: DatabaseJS.sports
    property bool timerPaused: false
    property int countTimer: 0
    property int masterTimerCount: 0

        //DatabaseJS.workout_getInfo().lastIdCurrentWorkout = { id: 0, sport: 0, distance: 0, time: 0, calories: 0, hydration: 0 };
        //DatabaseJS.workout_getInfoFromWorkout(getCurrentWorkout['id']).lastInfoCurrentWorkout = { bpm: 0, speed: 0 };

    Rectangle {
        id: mainOngoingWorkout
        anchors.fill: parent
        color: "transparent"

        Image {
            verticalAlignment: Image.AlignVCenter
            anchors.fill: parent
            width: parent.width
            height: parent.height
            source: 'pics/background_ongoing.png'
        }

        // BPM
        Rectangle {
            id: mainOngoingWorkoutBPM
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: mainOngoingWorkout.height / 3.33
            color: "transparent"

            Label {
                id: mainOngoingWorkoutBPMLabel
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: mainWindow.height / 7.27
                text: getCurrentWorkoutInput['bpm'] < 1 ? "N/A" : getCurrentWorkoutInput['bpm'];
                //color: DatabaseJS.getHZcolor(getCurrentWorkoutInput['bpm'])
                color: DatabaseJS.getHZcolor(mainOngoingWorkoutBPMLabel.text)
            }
        }

        // SPEED - DISTANCE
        Rectangle {
            id: mainOngoingWorkoutSpeedDistance
            anchors.top: mainOngoingWorkoutBPM.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: mainOngoingWorkout.height / 3.3
            color: "transparent"

            // SPEED
            Rectangle {
                id: mainOngoingWorkoutSpeed
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                width: mainOngoingWorkout.width / 1.74
                color: "transparent"

                Label {
                    id: mainOngoingWorkoutSpeedLabel
                    anchors.top: parent.top
                    anchors.topMargin: mainOngoingWorkoutSpeed.height/2 - (mainOngoingWorkoutSpeedLabel.height+mainOngoingWorkoutSpeedUnit.height)/2
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: mainOngoingWorkout.height / 8.89
                    text: Math.floor(getCurrentWorkoutInput['speed']) + ':' + formatSecs2(Math.floor((getCurrentWorkoutInput['speed'] - Math.floor(getCurrentWorkoutInput['speed'])).toFixed(2)*60))
                    color: "white"
                }
                Label {
                    id: mainOngoingWorkoutSpeedUnit
                    anchors.horizontalCenter: mainOngoingWorkoutSpeedLabel.horizontalCenter
                    anchors.top: mainOngoingWorkoutSpeedLabel.bottom
                    font.pointSize: mainOngoingWorkout.height / 40
                    text: 'min/km'
                    color: "white"
                }
            }

            // DISTANCE
            Rectangle {
                id: mainOngoingWorkoutDistance
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                width: parent.width - mainOngoingWorkoutSpeed.width
                color: "transparent"

                Label {
                    id: mainOngoingWorkoutDistanceLabel
                    anchors.top: parent.top
                    anchors.topMargin: parent.height/2 - (mainOngoingWorkoutDistanceLabel.height+mainOngoingWorkoutDistanceLabelUnit.height)/2
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width/2 - (mainOngoingWorkoutDistanceLabel.width+mainOngoingWorkoutDistanceLabel2.width)/2
                    font.pointSize: mainOngoingWorkout.height / 8.89
                    text: Math.floor(getCurrentWorkout['distance'])
                    color: "white"
                }
                Label {
                    id: mainOngoingWorkoutDistanceLabel2
                    anchors.left: mainOngoingWorkoutDistanceLabel.right
                    anchors.bottom: mainOngoingWorkoutDistanceLabel.bottom
                    anchors.bottomMargin: mainOngoingWorkout.height / 150
                    font.pointSize: mainOngoingWorkout.height / 13.33
                    text: '.' + Math.round((getCurrentWorkout['distance'] - Math.floor(getCurrentWorkout['distance']))*10)
                    color: "white"
                }
                Label {
                    id: mainOngoingWorkoutDistanceLabelUnit
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: mainOngoingWorkoutDistanceLabel.bottom
                    font.pointSize: mainOngoingWorkout.height / 40
                    text: 'km'
                    color: "white"
                }
            }
        }

        // TIME ELAPSED
        Rectangle {
            id: mainOngoingWorkoutTime
            anchors.top: mainOngoingWorkoutSpeedDistance.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: stopButton.top
            color: "transparent"

            Label {
                id: mainOngoingWorkoutTimeLabelHours
                anchors.right: mainOngoingWorkoutTimeLabelMinutes.left
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: mainOngoingWorkout.height / 13.33
                text: formatSecs2(Math.floor(masterTimerCount/3600)) + ':'
                color: "white"
            }
            Label {
                id: mainOngoingWorkoutTimeLabelMinutes
                anchors.centerIn: parent
                font.pointSize: mainOngoingWorkout.height / 8
                text: formatSecs2(Math.floor((masterTimerCount-(Math.floor(masterTimerCount/3600)*3600))/60))
                color: "white"
            }
            Label {
                id: mainOngoingWorkoutTimeLabelSeconds
                anchors.left: mainOngoingWorkoutTimeLabelMinutes.right
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: mainOngoingWorkout.height / 13.33
                text: ':' + formatSecs2(Math.floor(masterTimerCount-(Math.floor(masterTimerCount/3600)*3600)-(Math.floor((masterTimerCount-(Math.floor(masterTimerCount/3600)*3600))/60)*60)))
                color: "white"
            }
        }


        // STOP BUTTON
        DelayButton  {
            id: stopButton
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: mainOngoingWorkout.height / 5.715
            delay: 2000

            Label {
                id: stopButtonLabel
                anchors.centerIn: parent
                font.pointSize: mainOngoingWorkout.height / 26.67
                color: "black"
                text: elapsedTimer.running ? "PAUSE" : "CONTINUE"
            }

            background:
                Rectangle {
                id: mainBackground
                anchors.centerIn: parent
                border.width: mainOngoingWorkout.width / 133.33
                border.color: "darkgreen"
                radius: mainOngoingWorkout.width / 26.67
                width: parent.height
                height: parent.width
                rotation: 270
                gradient: Gradient {
                    GradientStop { position: stopButton.progress-(mainOngoingWorkout.width / 2666.67); color: "green" }
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
