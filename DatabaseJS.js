// SPORTS
var sports = [];
sports[1] = { name: "Running",  factor: 1 };
sports[2] = { name: "Walking",  factor: 2 };
sports[3] = { name: "Swimming", factor: 3 };
sports[4] = { name: "Swimming", factor: 3 };

// RECOUNTING by GENDER
var genderRecount = [];
genderRecount['Male'] = {   calories_factor: 55.0969, age_factor: 0.2017, weight_factor: 0.09036, heartrate_factor: 0.6309 };
genderRecount['Female'] = { calories_factor: 20.4022, age_factor: 0.0074, weight_factor: 0.05741, heartrate_factor: 0.4472 };

// HEART RATE ZONES DETERMINE
function getHZcolor(bpm_input) {
    var maxHR;
    if (db_getProfile().gender === "Male") {  maxHR = 214 - db_getProfile().age * 0.8; }
    else { maxHR = maxHR = 209 - db_getProfile().age * 0.8; }

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
                                                + 'age TINYINT NOT NULL,'
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
    // `workouts_summary` (sport, distance, time, calories, hydration)
    // create table for workouts summary if doesnt exists yet
    db.transaction(function(tx) { tx.executeSql('CREATE TABLE IF NOT EXISTS `workouts_summary` ('
                                                + 'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                                                + 'sport TINYINT NOT NULL,'
                                                + 'distance DOUBLE,'
                                                + 'time DOUBLE NOT NULL,'
                                                + 'calories DOUBLE NOT NULL,'
                                                + 'hydration DOUBLE NOT NULL)'); });
}
function db_checkProfile() {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT count(*) AS checkCount FROM sqlite_master WHERE type=\'table\' AND name=\'profile\'');
        var myAmount = rs.rows.item(0).checkCount;

        if (myAmount < 1) { stackView.push(registerProfile1); }

        var rs2 = tx.executeSql('SELECT count(id) AS checkCount2 FROM profile');
        var myAmount2 = rs2.rows.item(0).checkCount2;

        if (myAmount2 < 1) { stackView.push(registerProfile1); }
        else {               stackView.push(mainScreen); }
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
            myVarriable = {id: rs.rows.item(ix).id, gender: rs.rows.item(ix).gender, age: rs.rows.item(ix).age, weight: rs.rows.item(ix).weight};
            //              myVarriable = [rs.rows.item(ix).id, rs.rows.item(ix).gender, rs.rows.item(ix).age, rs.rows.item(ix).weight];
        }
    });
    return myVarriable;
}

function db_saveProfile1() {

    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    var gender = genderTextField.currentText;
    db.transaction(function(tx) {
        var sql = 'INSERT INTO `profile` (gender,age,weight) VALUES (\'' + gender + '\', 0, 0)';
        tx.executeSql(sql);
        stackView.push(registerProfile2);
    });
}
function db_saveProfile2() {

    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    var age = ageTextField.text;
    db.transaction(function(tx) {
        var sql = 'UPDATE `profile` SET age=' + age + ' WHERE id=1';
        tx.executeSql(sql);
        stackView.push(registerProfile3);
    });
}
function db_saveProfile3() {

    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    var weight = weightTextField.text;
    db.transaction(function(tx) {
        var sql = 'UPDATE `profile` SET weight=' + weight + ' WHERE id=1';
        tx.executeSql(sql);
        stackView.push(mainScreen);
    });
}



function db_saveProfile() {

    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    var gender = genderTextField.currentText;
    var age = ageTextField.text;
    var weight = weightTextField.text;
    db.transaction(function(tx) {
        var sql = 'INSERT INTO `profile` (gender,age,weight) VALUES (\'' + gender + '\',' + age + ',' + weight + ')';
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

    var lastIdCurrentWorkout = [];
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT id,sport,distance,time,calories,hydration,(SELECT AVG(speed) FROM `workouts` WHERE id_workout=(SELECT id_workout FROM `workouts` ORDER BY id DESC LIMIT 1) AND speed>0) AS AvgSpeed FROM `workouts_summary` ORDER BY id DESC LIMIT 1');
        var ix;
        for (ix = 0; ix < rs.rows.length; ++ix) {
            lastIdCurrentWorkout = {    id: rs.rows.item(ix).id,
                                        sport: rs.rows.item(ix).sport,
                                        distance: rs.rows.item(ix).distance,
                                        time: rs.rows.item(ix).time,
                                        calories: rs.rows.item(ix).calories,
                                        hydration: rs.rows.item(ix).hydration,
                                        avgspeed: rs.rows.item(ix).AvgSpeed    };
        }
    });
    return lastIdCurrentWorkout;
}

function getSummaryWorkouts() {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    var summaryWorkouts = [];
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
    return summaryWorkouts;
}

function workout_getInfoFromWorkout(id_workout) {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    var lastInfoCurrentWorkout = [];
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT speed,bpm FROM `workouts` WHERE id_workout='+ id_workout +' ORDER BY id DESC LIMIT 1');
        var ix;
        for (ix = 0; ix < rs.rows.length; ++ix) {
            lastInfoCurrentWorkout = {  bpm: rs.rows.item(ix).bpm,
                                        speed: rs.rows.item(ix).speed   };
        }
    });
    return lastInfoCurrentWorkout;
}

// New Workout Start
function workout_newstart() {

    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    db.transaction(function(tx) {
        var sql1 = 'INSERT INTO `workouts_summary` (sport, distance, time, calories, hydration) VALUES (1, 0, 0, 0, 0)';
        tx.executeSql(sql1);

        // ID of the new workout
        var workout_id = 0;
        var workout_id_sql = tx.executeSql('SELECT last_insert_rowid()')
        workout_id = workout_id_sql.insertId    // SHOKARTA - jak to pouzit a poslat do viewu?

        var timestamp = Math.floor(Date.now() / 1000);
        var gps_latitude = Math.random() * (50.399 - 50.398) + 50.398; // SHOKARTA - GPS Latitude
        var gps_longitude = Math.random() * (13.185 - 13.184) + 13.184; // SHOKARTA - GPS Longitude
        var gps_altitude = Math.random() * (360 - 350) + 320; // SHOKARTA - GPS Altitude
        var bpm = Math.floor(Math.random() * (189 - 75) + 75); // SHOKARTA
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
    var lastWorkoutSummary = [];
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
        var gps_latitude = Math.random() * (50.399 - 50.398) + 50.398; // SHOKARTA - GPS Latitude
        var gps_longitude = Math.random() * (13.185 - 13.184) + 13.184; // SHOKARTA - GPS Longitude
        var gps_altitude = Math.random() * (360 - 350) + 320; // SHOKARTA - GPS Altitude
        var bpm = Math.floor(Math.random() * (189 - 75) + 75); // SHOKARTA

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
        var profile = db_getProfile();
        if(bpm > 0) {
            calories =
                (profile.age * genderRecount[profile.gender].age_factor) -
                ((profile.weight * 2,20462262) * genderRecount[profile.gender].weight_factor) +
                (bpm * genderRecount[profile.gender].heartrate_factor) -
                (genderRecount[profile.gender].calories_factor) *
                ((timespent / 60) / 4.184);
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
