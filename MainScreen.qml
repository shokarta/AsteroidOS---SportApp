import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import 'DatabaseJS.js' as DatabaseJS

Item {
property bool updateProfile: true
    SwipeView {
        id: view

        currentIndex: 1
        anchors.fill: parent
        orientation: Qt.Vertical

        Item {
            property bool updateProfile: true
            RegisterProfile1 {}
        }

        Item {

            Component.onCompleted: {
                DatabaseJS.db_getProfile();
                DatabaseJS.getSummaryWorkouts();
            }

            Rectangle {
                anchors.fill: parent
                color: 'black'

                Rectangle {
                    id: mainItem
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 175
                    color: 'transparent'

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
                                text: '<b>ID:</b> ' + profile['id']
                                color: 'white'
                            }
                        }
                        Row {
                            id: rowGender
                            Text {
                                font.pointSize: 16
                                text: '<b>Gender:</b> ' + profile['gender']
                                color: 'white'
                            }
                        }
                        Row {
                            id: rowAge
                            Text {
                                font.pointSize: 16
                                text: '<b>Age:</b> ' + getAge(profile['age']) + ' years'
                                color: 'white'
                            }
                        }
                        Row {
                            id: rowWeight
                            Text {
                                font.pointSize: 16
                                text: '<b>Weight:</b> ' + profile['weight'] + ' kg'
                                color: 'white'
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
                            source: 'pics/' + genderChosen + '.png'
                        }
                    }
                }

                Rectangle {
                    id: workoutsView
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: mainItem.bottom
                    anchors.bottom: startButton.top
                    color: 'transparent'

                    Row {
                        id: rowWorkoutsAmount
                        width: workoutsView.width
                        spacing: 5

                        Column {
                            width: rowWorkoutsAmount.width / 2
                            Text {
                                anchors.right: parent.right
                                font.pointSize: 15
                                text: '<b>Total Workouts:</b>'
                                color: 'white'
                            }
                        }
                        Column {
                            width: rowWorkoutsAmount.width / 2
                            Text {
                                font.pointSize: 15
                                text: summaryWorkouts['amountWorkouts']
                                color: 'white'
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
                                font.pointSize: 15
                                text: '<b>Time Spent:</b>'
                                color: 'white'
                            }
                        }
                        Column {
                            width: rowWorkoutsAmount.width / 2
                            Text {
                                font.pointSize: 15
                                text: formatSecs(summaryWorkouts['amountTimespent'])
                                color: 'white'
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
                                font.pointSize: 15
                                text: '<b>Total Distance:</b>'
                                color: 'white'
                            }
                        }
                        Column {
                            width: rowWorkoutsAmount.width / 2
                            Text {
                                font.pointSize: 15
                                text: summaryWorkouts['amountDistance'].toFixed(2) + ' km'
                                color: 'white'
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
                                font.pointSize: 15
                                text: '<b>Calories Burned:</b>'
                                color: 'white'
                            }
                        }
                        Column {
                            width: rowWorkoutsAmount.width / 2
                            Text {
                                font.pointSize: 15
                                text: summaryWorkouts['amountCalories'].toFixed(2) + ' kcal'
                                color: 'white'
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
                                font.pointSize: 15
                                text: '<b>Fluid Loss:</b>'
                                color: 'white'
                            }
                        }
                        Column {
                            width: rowWorkoutsAmount.width / 2
                            Text {
                                font.pointSize: 15
                                text: summaryWorkouts['amountHydration'].toFixed(2) + ' l'
                                color: 'white'
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
        }

        Item {
            Rectangle {
                anchors.fill: parent
                color: 'black'

                Label {
                    id: lastWorkoutLabel
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 50
                    font.pointSize: Math.min(mainWindow.height, mainWindow.width) / 20
                    text: 'Last Workout:'
                    color: "white"
                }

                Rectangle {
                    id: lastWorkoutsView
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: lastWorkoutLabel.bottom
                    anchors.bottom: deleteLastButton.top
                    color: 'transparent'

                    Row {
                        id: rowLastWorkoutAmount
                        width: lastWorkoutsView.width
                        spacing: 5

                        Column {
                            width: parent.width / 2
                            Text {
                                anchors.right: parent.right
                                font.pointSize: 15
                                text: '<b>ID Workout:</b>'
                                color: 'white'
                            }
                        }
                        Column {
                            width: parent.width / 2
                            Text {
                                font.pointSize: 15
                                text: lastIdCurrentWorkout['id']
                                color: 'white'
                            }
                        }
                    }
                    Row {
                        id: rowLastWorkoutDate
                        width: lastWorkoutsView.width
                        spacing: 5
                        anchors.top: rowLastWorkoutAmount.bottom

                        Column {
                            width: parent.width / 2
                            Text {
                                anchors.right: parent.right
                                font.pointSize: 15
                                text: '<b>Date:</b>'
                                color: 'white'
                            }
                        }
                        Column {
                            width: parent.width / 2
                            Text {
                                font.pointSize: 15
                                text: getDateFromTimestamp(lastIdCurrentWorkout['date'])
                                color: 'white'
                            }
                        }
                    }
                    Row {
                        id: rowLastWorkoutType
                        width: parent.width
                        spacing: 5
                        anchors.top: rowLastWorkoutDate.bottom

                        Column {
                            width: parent.width / 2
                            Text {
                                anchors.right: parent.right
                                font.pointSize: 15
                                text: '<b>Sport Type:</b>'
                                color: 'white'
                            }
                        }
                        Column {
                            width: parent.width / 2
                            Text {
                                font.pointSize: 15
                                text: DatabaseJS.sports[lastIdCurrentWorkout['sport']].name
                                color: 'white'
                            }
                        }
                    }
                    Row {
                        id: rowLastWorkoutTimespent
                        width: parent.width
                        spacing: 5
                        anchors.top: rowLastWorkoutType.bottom

                        Column {
                            width: parent.width / 2
                            Text {
                                anchors.right: parent.right
                                font.pointSize: 15
                                text: '<b>Time Spent:</b>'
                                color: 'white'
                            }
                        }
                        Column {
                            width: parent.width / 2
                            Text {
                                font.pointSize: 15
                                text: formatSecs(lastIdCurrentWorkout['time'])
                                color: 'white'
                            }
                        }
                    }
                    Row {
                        id: rowLastWorkoutDistance
                        width: parent.width
                        spacing: 5
                        anchors.top: rowLastWorkoutTimespent.bottom

                        Column {
                            width: parent.width / 2
                            Text {
                                anchors.right: parent.right
                                font.pointSize: 15
                                text: '<b>Total Distance:</b>'
                                color: 'white'
                            }
                        }
                        Column {
                            width: parent.width / 2
                            Text {
                                font.pointSize: 15
                                text: lastIdCurrentWorkout['distance'].toFixed(2) + ' km'
                                color: 'white'
                            }
                        }
                    }
                    Row {
                        id: rowLastWorkoutAvgSpeed
                        width: parent.width
                        spacing: 5
                        anchors.top: rowLastWorkoutDistance.bottom

                        Column {
                            width: parent.width / 2
                            Text {
                                anchors.right: parent.right
                                font.pointSize: 15
                                text: '<b>Average Speed:</b>'
                                color: 'white'
                            }
                        }
                        Column {
                            width: parent.width / 2
                            Text {
                                font.pointSize: 15
                                text: lastIdCurrentWorkout['avgspeed'].toFixed(1) + ' km/h'
                                color: 'white'
                            }
                        }
                    }
                    Row {
                        id: rowLastWorkoutCalories
                        width: parent.width
                        spacing: 5
                        anchors.top: rowLastWorkoutAvgSpeed.bottom

                        Column {
                            width: parent.width / 2
                            Text {
                                anchors.right: parent.right
                                font.pointSize: 15
                                text: '<b>Calories Burned:</b>'
                                color: 'white'
                            }
                        }
                        Column {
                            width: parent.width / 2
                            Text {
                                font.pointSize: 15
                                text: lastIdCurrentWorkout['calories'].toFixed(2) + ' kcal'
                                color: 'white'
                            }
                        }
                    }
                    Row {
                        id: rowLastWorkoutFluid
                        width: parent.width
                        spacing: 5
                        anchors.top: rowLastWorkoutCalories.bottom

                        Column {
                            width: parent.width / 2
                            Text {
                                anchors.right: parent.right
                                font.pointSize: 15
                                text: '<b>Fluid Loss:</b>'
                                color: 'white'
                            }
                        }
                        Column {
                            width: parent.width / 2
                            Text {
                                font.pointSize: 15
                                text: lastIdCurrentWorkout['hydration'].toFixed(2) + ' l'
                                color: 'white'
                            }
                        }
                    }
                }

                DelayButton  {
                    id: deleteLastButton
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: parent.height / 5.715
                    delay: 2000

                    Label {
                        id: deleteButtonLabel
                        anchors.centerIn: parent
                        font.pointSize: mainWindow.height / 26.67
                        color: "black"
                        text: "DELETE WORKOUT"
                    }

                    background:
                        Rectangle {
                        id: mainBackground
                        anchors.centerIn: parent
                        border.width: mainWindow.width / 133.33
                        border.color: "darkgreen"
                        radius: mainWindow.width / 26.67
                        width: parent.height
                        height: parent.width
                        rotation: 270
                        gradient: Gradient {
                            GradientStop { position: deleteLastButton.progress-(mainWindow.width / 2666.67); color: "green" }
                            GradientStop { position: deleteLastButton.progress; color: "lightgreen" }
                        }
                    }

                    onActivated: {
                        DatabaseJS.workout_delete(lastIdCurrentWorkout['id']);
                    }
                }
            }
        }
    }
}
