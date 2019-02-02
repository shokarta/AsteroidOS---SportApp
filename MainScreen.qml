import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import 'DatabaseJS.js' as DatabaseJS

Item {

    Rectangle {
        id: mainItem
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 175

        Column {
            id: column2

            anchors.top: parent.top
            anchors.left: column1.right
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.topMargin: 30
            spacing: 2

            Row {
                id: rowId
                Text {
                    font.pointSize: 16
                    text: '<b>ID:</b> ' + getProfile['id']
                }
            }
            Row {
                id: rowGender
                Text {
                    font.pointSize: 16
                    text: '<b>Gender:</b> ' + getProfile['gender']
                }
            }
            Row {
                id: rowAge
                Text {
                    font.pointSize: 16
                    text: '<b>Age:</b> ' + getProfile['age'] + ' years'
                }
            }
            Row {
                id: rowWeight
                Text {
                    font.pointSize: 16
                    text: '<b>Weight:</b> ' + getProfile['weight'] + ' kg'
                }
            }
        }
        Column {
            id: column1

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: -20
            anchors.topMargin: 30
            spacing: 2
            width: parent.width / 2

            Image {
                verticalAlignment: Image.AlignVCenter
                anchors.right: column1.right
                width: 130; height: 100
                fillMode: Image.PreserveAspectFit
                source: 'pics/' + getProfile['gender'] + '.png'
            }
        }
    }

    Rectangle {
        id: workoutsView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: mainItem.bottom
        anchors.bottom: startButton.top

        Row {
            id: rowWorkoutsAmount
            width: workoutsView.width
            spacing: 5

            Column {
                width: rowWorkoutsAmount.width / 2
                Text {
                    anchors.right: parent.right
                    font.pointSize: 12
                    text: '<b>Total Workouts:</b>'
                }
            }
            Column {
                width: rowWorkoutsAmount.width / 2
                Text {
                    font.pointSize: 12
                    text: getSummaryWorkouts['amountWorkouts']
                }
            }
        }
        Row {
            id: rowWorkoutsTimespent
            width: workoutsView.width
            spacing: 5
            anchors.top: rowWorkoutsAmount.bottom

            Column {
                width: rowWorkoutsAmount.width / 2
                Text {
                    anchors.right: parent.right
                    font.pointSize: 12
                    text: '<b>Time Spent:</b>'
                }
            }
            Column {
                width: rowWorkoutsAmount.width / 2
                Text {
                    font.pointSize: 12
                    text: formatSecs(getSummaryWorkouts['amountTimespent'])
                }
            }
        }
        Row {
            id: rowWorkoutsDistance
            width: workoutsView.width
            spacing: 5
            anchors.top: rowWorkoutsTimespent.bottom

            Column {
                width: rowWorkoutsAmount.width / 2
                Text {
                    anchors.right: parent.right
                    font.pointSize: 12
                    text: '<b>Total Distance:</b>'
                }
            }
            Column {
                width: rowWorkoutsAmount.width / 2
                Text {
                    font.pointSize: 12
                    text: getSummaryWorkouts['amountDistance'].toFixed(2) + ' km'
                }
            }
        }
        Row {
            id: rowWorkoutsCalories
            width: workoutsView.width
            spacing: 5
            anchors.top: rowWorkoutsDistance.bottom

            Column {
                width: rowWorkoutsAmount.width / 2
                Text {
                    anchors.right: parent.right
                    font.pointSize: 12
                    text: '<b>Calories Burned:</b>'
                }
            }
            Column {
                width: rowWorkoutsAmount.width / 2
                Text {
                    font.pointSize: 12
                    text: getSummaryWorkouts['amountCalories'].toFixed(2) + ' kcal'
                }
            }
        }
        Row {
            id: rowWorkoutsFluid
            width: workoutsView.width
            spacing: 5
            anchors.top: rowWorkoutsCalories.bottom

            Column {
                width: rowWorkoutsAmount.width / 2
                Text {
                    anchors.right: parent.right
                    font.pointSize: 12
                    text: '<b>Fluid Loss:</b>'
                }
            }
            Column {
                width: rowWorkoutsAmount.width / 2
                Text {
                    font.pointSize: 12
                    text: getSummaryWorkouts['amountHydration'].toFixed(2) + ' l'
                }
            }
        }
    }

    Button {
        id: startButton
        text: 'START THE WORKOUT'
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 50

        onClicked: {
            DatabaseJS.workout_newstart();
        }
    }
}
