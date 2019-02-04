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
                                text: '<b>' + qsTrId("id-rowId") + ':</b> ' + profile['id'] // ID
                                color: 'white'
                            }
                        }
                        Row {
                            id: rowGender
                            Text {
                                font.pointSize: 16
                                text: '<b>' + qsTrId("id-rowGender") + ':</b> ' + profile['gender'] // Gender
                                color: 'white'
                            }
                        }
                        Row {
                            id: rowAge
                            Text {
                                font.pointSize: 16
                                text: '<b>' + qsTrId("id-rowAge") + ':</b> ' + getAge(profile['age']) + ' ' + qsTrId("id-rowAgeUnits") // Age - Years
                                color: 'white'
                            }
                        }
                        Row {
                            id: rowWeight
                            Text {
                                font.pointSize: 16
                                text: '<b>' + qsTrId("id-rowWeight") + ':</b> ' + profile['weight'] + ' kg' // Weight
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
                                text: '<b>' + qsTrId("id-rowWorkoutsAmount") + ':</b>' // Total Workouts
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
                                text: '<b>' + qsTrId("id-rowWorkoutsTimespent") + ':</b>' // Time Spent
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
                                text: '<b>' + qsTrId("id-rowWorkoutsDistance") + ':</b>' // Total Distance
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
                                text: '<b>' + qsTrId("id-rowWorkoutsCalories") + ':</b>' // Calories Burned
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
                                text: '<b>' + qsTrId("id-rowWorkoutsFluid") + ':</b>' // Fluid Loss
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
                    text: qsTrId("id-startButton") // NEW WORKOUT
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
                    text: qsTrId("id-lastWorkoutLabel") + ':' // Last Workout
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
                                text: '<b>' + qsTrId("id-rowLastWorkoutAmount") + ':</b>' // ID Workout
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
                                text: '<b>' + qsTrId("id-rowLastWorkoutDate") + ':</b>' // Date
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
                                text: '<b>' + qsTrId("id-rowLastWorkoutType") + ':</b>' // Sport Type
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
                                text: '<b>' + qsTrId("id-rowLastWorkoutTimespent") + ':</b>' // Time Spent
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
                                text: '<b>' + qsTrId("id-rowLastWorkoutDistance") + ':</b>' // Total Distance
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
                                text: '<b>' + qsTrId("id-rowLastWorkoutAvgSpeed") + ':</b>' // Average Speed
                                color: 'white'
                            }
                        }
                        Column {
                            width: parent.width / 2
                            Text {
                                font.pointSize: 15
                                text: lastIdCurrentWorkout['avgspeed'] ? lastIdCurrentWorkout['avgspeed'].toFixed(1) + ' km/h' : '0.0'
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
                                text: '<b>' + qsTrId("id-rowLastWorkoutCalories") + ':</b>' // Calories Burned
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
                                text: '<b>' + qsTrId("id-rowLastWorkoutFluid") + ':</b>' // Fluid Loss
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
                        text: qsTrId("id-deleteLastButton") // DELETE WORKOUT
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
