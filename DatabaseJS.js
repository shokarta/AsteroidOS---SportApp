// SPORTS
var sports = [];
sports[0] = { name: "None",  factor: 0 };
sports[1] = { name: "Running",  factor: 1 };
sports[2] = { name: "Walking",  factor: 2 };
sports[3] = { name: "Swimming", factor: 3 };

// RECOUNTING by GENDER
var genderRecount = [];
genderRecount['Male'] = {   calories_factor: 55.0969, age_factor: 0.2017, weight_factor: 0.09036, heartrate_factor: 0.6309 };
genderRecount['Female'] = { calories_factor: 20.4022, age_factor: 0.0074, weight_factor: 0.05741, heartrate_factor: 0.4472 };

// HEART RATE ZONES DETERMINE
function getHZcolor(bpm_input) {
    var maxHR;
    if (profile.gender === "Male") {  maxHR = 214 - getAge(profile.age) * 0.8; }
    else { maxHR = maxHR = 209 - getAge(profile.age) * 0.8; }

    var HZcolor;
    // N/A
    if (bpm_input < 1) { HZcolor = "white"; }

    // SPEED
    else if (bpm_input >= maxHR*0.9) { HZcolor = "#ff0000"; }

    // ECONOMY
    else if ((bpm_input < maxHR*0.9) && (bpm_input >= maxHR*0.8)) { HZcolor = "#ffc000"; }

    // STAMINA
    else if ((bpm_input < maxHR*0.8) && (bpm_input >= maxHR*0.7)) { HZcolor = "#38b938"; }

    // ENDURANCE
    else if ((bpm_input < maxHR*0.7) && (bpm_input >= maxHR*0.6)) { HZcolor = "#00b0f0"; }

    // RECOVERY
    else if (bpm_input < maxHR*0.6) { HZcolor = "#a6a6a6"; }

    return HZcolor;
}


function db_createTable() {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    // create table for profile if doesnt exists yet
    db.transaction(function(tx) { tx.executeSql('CREATE TABLE IF NOT EXISTS `profile` ('
                                                + 'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                                                + 'gender VARCHAR(10) NOT NULL,'
                                                + 'age DATE NOT NULL,'
                                                + 'weight DOUBLE NOT NULL)'); });
    // SHOKARTA: id autoincrement only now, later to be have to be online while register profile so master database on internet will provide id number

    // create table for wotkouts if doesnt exists yet
    db.transaction(function(tx) { tx.executeSql('CREATE TABLE IF NOT EXISTS `workouts` ('
                                                + 'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                                                + 'id_workout INTEGER NOT NULL,'
                                                + 'timestamp INTEGER NOT NULL,'
                                                + 'timespent TINYINT NOT NULL,'
                                                + 'gps_latitude DOUBLE NOT NULL,'
                                                + 'gps_longitude DOUBLE NOT NULL,'
                                                + 'gps_altitude DOUBLE NOT NULL,'
                                                + 'bpm INTEGER,'
                                                + 'distance DOUBLE NOT NULL,'
                                                + 'altitude_difference DOUBLE NOT NULL,'
                                                + 'speed DOUBLE NOT NULL,'
                                                + 'calories DOUBLE NOT NULL,'
                                                + 'hydratation DOUBLE NOT NULL)'); });

    // create table for workouts summary if doesnt exists yet
    db.transaction(function(tx) { tx.executeSql('CREATE TABLE IF NOT EXISTS `workouts_summary` ('
                                                + 'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                                                + 'sport TINYINT NOT NULL,'
                                                + 'distance DOUBLE,'
                                                + 'time DOUBLE NOT NULL,'
                                                + 'calories DOUBLE NOT NULL,'
                                                + 'hydration DOUBLE NOT NULL)'); });

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT count(*) AS checkCount FROM \'profile\'');
        var myAmount = rs.rows.item(0).checkCount;

        if (myAmount < 1) {
            db.transaction(function(tx) {
                var sql = 'INSERT INTO `profile` (gender,age,weight) VALUES (0, 0, 0)';
                tx.executeSql(sql);
                db_getProfile();
                stackView.push(registerProfile1);
            });
        }
        else { db_getProfile(); stackView.push(mainScreen); }
    });
}

function db_getProfile() {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);
    var myVarriable = [];

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT id,gender,age,weight FROM `profile`');
        var ix;
        for (ix = 0; ix < rs.rows.length; ++ix) {
            profile = { id: rs.rows.item(ix).id,
                        gender: rs.rows.item(ix).gender,
                        age: rs.rows.item(ix).age,
                        weight: rs.rows.item(ix).weight };
        }
    });
}

function db_saveProfile1() {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    db.transaction(function(tx) {
        var sql = 'UPDATE `profile` SET gender=\'' + genderChosen + '\' WHERE id=1';
        tx.executeSql(sql);
        stackView.push(registerProfile2);
    });
}
function db_saveProfile2() {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    db.transaction(function(tx) {
        var sql = 'UPDATE `profile` SET age=\'' + ageTextFieldYear.text + '-' + formatSecs2(parseInt(ageTextFieldMonth.text,10)) + '-' + formatSecs2(parseInt(ageTextFieldDay.text,10)) + '\' WHERE id=1';
        tx.executeSql(sql);
        stackView.push(registerProfile3);
    });
}
function db_saveProfile3() {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    db.transaction(function(tx) {
        var sql = 'UPDATE `profile` SET weight=' + weightTextField.text + ' WHERE id=1';
        tx.executeSql(sql);
        stackView.push(mainScreen);
    });
}



function db_saveProfile() {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    db.transaction(function(tx) {
        var sql = 'INSERT INTO `profile` (gender,age,weight) VALUES (\'' + genderTextField.currentText + '\',' + ageTextField.text + ',' + weightTextField.text + ')';
        tx.executeSql(sql);
    });
}


// PUSH
function push_start(site) {
    stackView.push(site);
}

function workout_getInfo() {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT id,sport,distance,time,calories,hydration,(SELECT AVG(speed) FROM `workouts` WHERE id_workout=(SELECT id_workout FROM `workouts` ORDER BY id DESC LIMIT 1) AND speed>0) AS AvgSpeed, (SELECT timestamp FROM `workouts` WHERE id_workout=(SELECT id_workout FROM `workouts` ORDER BY id DESC LIMIT 1)) AS Date FROM `workouts_summary` ORDER BY id DESC LIMIT 1');
        var ix;
        if (rs.rows.length > 0) {
            for (ix = 0; ix < rs.rows.length; ++ix) {
                lastIdCurrentWorkout = {    id: rs.rows.item(ix).id,
                                            sport: rs.rows.item(ix).sport,
                                            distance: rs.rows.item(ix).distance,
                                            time: rs.rows.item(ix).time,
                                            calories: rs.rows.item(ix).calories,
                                            hydration: rs.rows.item(ix).hydration,
                                            avgspeed: rs.rows.item(ix).AvgSpeed,
                                            date: rs.rows.item(ix).Date             };
            }
        }
        else {
                lastIdCurrentWorkout = {    id: 0,
                                            sport: 0,
                                            distance: 0,
                                            time: 0,
                                            calories: 0,
                                            hydration: 0,
                                            avgspeed: 0,
                                            date: 0         };
        }
    });
}

function getSummaryWorkouts() {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT count(id) AS var1,sum(distance) AS var2,sum(time) AS var3,sum(calories) AS var4,sum(hydration) AS var5 FROM `workouts_summary`');
            if (rs.rows.item(0).var1 > 0) {
                    summaryWorkouts = {  amountWorkouts: rs.rows.item(0).var1,
                                         amountDistance: rs.rows.item(0).var2,
                                         amountTimespent: rs.rows.item(0).var3,
                                         amountCalories: rs.rows.item(0).var4,
                                         amountHydration: rs.rows.item(0).var5   };
            }
            else {
                summaryWorkouts = {  amountWorkouts: 0,
                                     amountDistance: 0,
                                     amountTimespent: 0,
                                     amountCalories: 0,
                                     amountHydration: 0   };
            }
    });
}

function workout_getInfoFromWorkout(id_workout) {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT speed,bpm,distance FROM `workouts` WHERE id_workout='+ id_workout +' ORDER BY id DESC LIMIT 1');
        for (var ix = 0; ix < rs.rows.length; ++ix) {
            currentWorkout = {  bpm: rs.rows.item(ix).bpm,
                                speed: rs.rows.item(ix).speed,
                                distance: rs.rows.item(ix).distance };
        }
    });
}

// New Workout Start
function workout_newstart() {

    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    db.transaction(function(tx) {
        var sql1 = 'INSERT INTO `workouts_summary` (sport, distance, time, calories, hydration) VALUES (1, 0, 0, 0, 0)';
        tx.executeSql(sql1);

        // ID of the new workout
        var workout_id_sql = tx.executeSql('SELECT last_insert_rowid()')
        workout_id = workout_id_sql.insertId

        var timestamp = Math.floor(Date.now() / 1000);
        var gps_latitude = gps_lat;
        var gps_longitude = gps_long;
//        var gps_latitude = Math.random() * (50.399 - 50.398) + 50.398; // SHOKARTA - GPS Latitude
//        var gps_longitude = Math.random() * (13.185 - 13.184) + 13.184; // SHOKARTA - GPS Longitude
        var gps_altitude = Math.random() * (360 - 350) + 320; // SHOKARTA - GPS Altitude
        var bpm = Math.floor(Math.random() * (189 - 150) + 150); // SHOKARTA - BPM
        var sql2 = 'INSERT INTO `workouts` (id_workout, timestamp, timespent, gps_latitude, gps_longitude, gps_altitude, bpm, distance, altitude_difference, speed, calories, hydratation) VALUES (' + workout_id + ', ' + timestamp + ', 0, ' + gps_latitude + ', ' + gps_longitude + ', ' + gps_altitude + ', ' + bpm + ', 0, 0, 0, 0, 0)';
        tx.executeSql(sql2);

        stackView.push(ongoingWorkoutScreen);
    });
}

// Workout Refresh
function workout_refresh(id_workout, timerCheck) {

    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    // gets current info from current workout
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT sport,distance,time,calories,hydration FROM `workouts_summary` WHERE id=' + id_workout);
        var ix;
        for (ix = 0; ix < rs.rows.length; ++ix) {
            lastWorkoutSummary = {  id_workout: id_workout,
                sport: rs.rows.item(ix).sport,
                distance: rs.rows.item(ix).distance,
                time: rs.rows.item(ix).time,
                calories: rs.rows.item(ix).calories,
                hydration: rs.rows.item(ix).hydration   };
        }
    });

    // gets first workout input
    var firstWorkoutInput = [];
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM `workouts` WHERE id_workout=' + id_workout +' ORDER BY id ASC LIMIT 1');
        var ix;
        for (ix = 0; ix < rs.rows.length; ++ix) {
            firstWorkoutInput = {   id: rs.rows.item(ix).id,
                id_workout: id_workout,
                timestamp: rs.rows.item(ix).timestamp,
                timespent: rs.rows.item(ix).timespent,
                gps_latitude: rs.rows.item(ix).gps_latitude,
                gps_longitude: rs.rows.item(ix).gps_longitude,
                gps_altitude: rs.rows.item(ix).gps_altitude,
                bpm: rs.rows.item(ix).bpm,
                distance: rs.rows.item(ix).distance,
                altitude_difference: rs.rows.item(ix).altitude_difference,
                calories: rs.rows.item(ix).calories,
                gps_alcaloriestitude: rs.rows.item(ix).gps_alcaloriestitude,
                hydratation: rs.rows.item(ix).hydratation   };
        }
    });

    // gets last workout input
    var lastWorkoutInput = [];
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM `workouts` WHERE id_workout=' + id_workout + ' ORDER BY id DESC LIMIT 1');
        var ix;
        for (ix = 0; ix < rs.rows.length; ++ix) {
            lastWorkoutInput = {    id: rs.rows.item(ix).id,
                id_workout: id_workout,
                timestamp: rs.rows.item(ix).timestamp,
                timespent: rs.rows.item(ix).timespent,
                gps_latitude: rs.rows.item(ix).gps_latitude,
                gps_longitude: rs.rows.item(ix).gps_longitude,
                gps_altitude: rs.rows.item(ix).gps_altitude,
                bpm: rs.rows.item(ix).bpm,
                distance: rs.rows.item(ix).distance,
                altitude_difference: rs.rows.item(ix).altitude_difference,
                calories: rs.rows.item(ix).calories,
                gps_alcaloriestitude: rs.rows.item(ix).gps_alcaloriestitude,
                hydratation: rs.rows.item(ix).hydratation   };
        }
    });

    // inserts new record to current workout
    var newWorkoutInput = [];
    db.transaction(function(tx) {
        var timestamp = Math.floor(Date.now() / 1000);
        var timespent = timerCheck;
        var gps_latitude = gps_lat;
        var gps_longitude = gps_long;
//        var gps_latitude = Math.random() * (50.399 - 50.398) + 50.398; // SHOKARTA - GPS Latitude
//        var gps_longitude = Math.random() * (13.185 - 13.184) + 13.184; // SHOKARTA - GPS Longitude
        var gps_altitude = Math.random() * (360 - 350) + 320; // SHOKARTA - GPS Altitude
        var bpm = Math.floor(Math.random() * (189 - 150) + 150); // SHOKARTA

        // Distance
        var distance =
                Math.sqrt(
                    (Math.pow(Math.acos(
                        Math.sin(lastWorkoutInput.gps_latitude * Math.PI / 180) *
                        Math.sin(gps_latitude * Math.PI / 180) +
                        Math.cos(lastWorkoutInput.gps_latitude * Math.PI / 180) *
                        Math.cos(gps_latitude * Math.PI / 180) *
                        Math.cos((gps_longitude * Math.PI / 180) - (lastWorkoutInput.gps_longitude * Math.PI / 180))
                    ) * 6370, 2)) +
                    (Math.pow((( Math.max( lastWorkoutInput.gps_altitude, gps_altitude) - Math.min( lastWorkoutInput.gps_altitude, gps_altitude)) / 1000), 2)
                ));

        var altitude_difference = gps_altitude - lastWorkoutInput.gps_altitude;
        var speed = (distance)/((timespent)/60/24);

        // Calories
        var calories;
        if(bpm > 0) {
            calories =
                    ((getAge(profile.age) * genderRecount[profile.gender].age_factor) -
                    ((profile.weight * 2.20462262) * genderRecount[profile.gender].weight_factor) +
                    (bpm * genderRecount[profile.gender].heartrate_factor) -
                    genderRecount[profile.gender].calories_factor) *
                    (((timespent) / 60 ) / 4.184);
        }
        else { calories = sports[lastWorkoutSummary.sport].factor * profile.weight * distance; }
        if (calories < 0) { calories = 0; }

        var hydration = calories / 771.61791764707;

        var sql = 'INSERT INTO `workouts` (id_workout, timestamp, timespent, gps_latitude, gps_longitude, gps_altitude, bpm, distance, altitude_difference, speed, calories, hydratation) VALUES (' + id_workout + ', ' + timestamp + ', ' + timespent + ', ' + gps_latitude + ', ' + gps_longitude + ', ' + gps_altitude + ', ' + bpm + ', ' + distance + ', ' + altitude_difference + ', ' + speed + ', ' + calories + ', ' + hydration + ')';
        tx.executeSql(sql);
        newWorkoutInput = { id_workout: id_workout,
                            timestamp: timestamp,
                            timespent: timespent,
                            gps_latitude: gps_latitude,
                            gps_longitude: gps_longitude,
                            gps_altitude: gps_altitude,
                            bpm: bpm,
                            distance: distance,
                            altitude_difference: altitude_difference,
                            speed: speed,
                            calories: calories,
                            hydration: hydration  };

        // update workouts_summary accordingly
        db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

        db.transaction(function(tx) {
            var newDistance = lastWorkoutSummary.distance + newWorkoutInput.distance;
            var newTime = lastWorkoutSummary.time + newWorkoutInput.timespent;
            var newCalories = lastWorkoutSummary.calories + newWorkoutInput.calories;
            var newHydration = lastWorkoutSummary.hydration + newWorkoutInput.hydration;
            var sql = 'UPDATE `workouts_summary` SET distance=' + newDistance + ', time=' + newTime + ', calories=' + newCalories + ', hydration=' + newHydration + ' WHERE id=' + id_workout;
            tx.executeSql(sql);
        });
    });
}

// Workout Refresh
function workout_delete(id_workout) {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    // gets current info from current workout
    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM `workouts` WHERE id_workout=' + id_workout);
        tx.executeSql('DELETE FROM `workouts_summary` WHERE id=' + id_workout);
    });
    workout_getInfo();
    stackView.push(mainScreen);
}

// Info for miniMap
function workout_getMapFromWorkout() {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT min(gps_latitude) AS min_lat, avg(gps_latitude) AS avg_lat, max(gps_latitude) AS max_lat, min(gps_longitude) AS min_long, avg(gps_longitude) AS avg_long, max(gps_longitude) AS max_long FROM `workouts` ORDER BY id_workout LIMIT 1');
        for (var ix = 0; ix < rs.rows.length; ++ix) {
            mapWorkout = {  min_lat: rs.rows.item(ix).min_lat,
                            avg_lat: rs.rows.item(ix).avg_lat,
                            max_lat: rs.rows.item(ix).max_lat,
                            min_long: rs.rows.item(ix).min_long,
                            avg_long: rs.rows.item(ix).avg_long,
                            max_long: rs.rows.item(ix).max_long,
                            zoomIndex: 0.15 * Math.max(Math.abs(rs.rows.item(ix).max_lat-rs.rows.item(ix).min_lat),Math.abs(rs.rows.item(ix).max_long-rs.rows.item(ix).min_long))  };
        }
    });
}
