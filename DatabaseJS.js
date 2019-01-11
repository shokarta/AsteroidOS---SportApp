// SPORTS
var sports = [];
sports[1] = { name: "Running",  factor: 1 };
sports[2] = { name: "Walking",  factor: 2 };
sports[3] = { name: "Swimming", factor: 3 };

// Recounting by GENDER
var genderRecount = [];
genderRecount['Male'] = {   calories_factor: 55.0969, age_factor: 0.2017, weight_factor: 0.09036, heartrate_factor: 0.6309 };
genderRecount['Female'] = { calories_factor: 20.4022, age_factor: 0.0074, weight_factor: 0.05741, heartrate_factor: 0.4472 };



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
        var rs = tx.executeSql('SELECT id,gender,age,weight FROM `profile`');
        var myAmount = rs.rows.length;

        if (myAmount < 1) { stackView.push(registerProfile1); }
        else {              stackView.push(mainScreen); }
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
        console.log(myVarriable);
    });
    return myVarriable;
}

function db_saveProfile1() {

    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    var gender = genderTextField.currentText;
    db.transaction(function(tx) {
        var sql = 'INSERT INTO `profile` (gender,age,weight) VALUES (\'' + gender + '\', 0, 0)';
        console.log(sql);
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
        console.log(sql);
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
        console.log(sql);
        tx.executeSql(sql);
        stackView.push(registerProfileDone);
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
        console.log(sql);
        tx.executeSql(sql);
    });
}


// PUSH
function push_start() {
    stackView.push(mainScreen);
}


function workout_getInfo() {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);
    var lastIdCurrentWorkout = [];

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT id,sport,distance,time,calories,hydration FROM `workouts_summary` ORDER BY id DESC LIMIT 1');
        var ix;
        for (ix = 0; ix < rs.rows.length; ++ix) {
            lastIdCurrentWorkout = {    id: rs.rows.item(ix).id,
                sport: rs.rows.item(ix).sport,
                distance: rs.rows.item(ix).distance,
                time: rs.rows.item(ix).time,
                calories: rs.rows.item(ix).calories,
                hydration: rs.rows.item(ix).hydration   };
        }
        console.log(lastIdCurrentWorkout);
    });
    return lastIdCurrentWorkout;
}

// New Workout Start
function workout_newstart() {

    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    db.transaction(function(tx) {
        var sql1 = 'INSERT INTO `workouts_summary` (sport, distance, time, calories, hydration) VALUES (1, 0, 0, 0, 0)';
        console.log(sql1);
        tx.executeSql(sql1);

        // ID of the new workout
        var workout_id = 0;
        var workout_id_sql = tx.executeSql('SELECT last_insert_rowid()')
        workout_id = workout_id_sql.insertId    // SHOKARTA - jak to pouzit a poslat do viewu?

        var timestamp = Math.floor(Date.now() / 1000);
        var gps_latitude = Math.random() * (50.399519 - 50.392956) + 50.392956; // SHOKARTA - GPS Latitude
        var gps_longitude = Math.random() * (13.181750 - 13.171348) + 13.171348; // SHOKARTA - GPS Longitude
        var gps_altitude = Math.random() * (390 - 320) + 320; // SHOKARTA - GPS Altitude
        var bpm = 0; // SHOKARTA
        var sql2 = 'INSERT INTO `workouts` (id_workout, timestamp, timespent, gps_latitude, gps_longitude, gps_altitude, bpm, distance, altitude_difference, speed, calories, hydratation) VALUES (' + workout_id + ', ' + timestamp + ', 0, ' + gps_latitude + ', ' + gps_longitude + ', ' + gps_altitude + ', ' + bpm + ', 0, 0, 0, 0, 0)';
        console.log(sql2);
        tx.executeSql(sql2);

        stackView.push(ongoingWorkoutScreen);
    });
}

// Workout Refresh
function workout_refresh(id_workout) {

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
        console.log(lastWorkoutSummary);
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
        console.log(firstWorkoutInput);
    });

    // gets last workout input
    var lastWorkoutInput = [];
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM `workouts` WHERE id_workout=' + id_workout +' ORDER BY id DESC LIMIT 1');
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
        console.log(lastWorkoutInput);
    });

    // inserts new record to current workout
    db.transaction(function(tx) {
        var timestamp = Math.floor(Date.now() / 1000);
        //var timespent = timestamp - lastWorkoutInput('timestamp');
        var timespent = timestamp - lastWorkoutInput.timestamp;
        var gps_latitude = Math.random() * (50.399519 - 50.392956) + 50.392956; // SHOKARTA - GPS Latitude
        var gps_longitude = Math.random() * (13.181750 - 13.171348) + 13.171348; // SHOKARTA - GPS Longitude
        var gps_altitude = Math.random() * (390 - 320) + 320; // SHOKARTA - GPS Altitude
        var bpm = 0; // SHOKARTA

        // Distance
        var distance = Math.sqrt(((Math.acos( Math.sin(lastWorkoutInput.gps_latitude*Math.pi/180)*Math.sin(gps_latitude*Math.pi/180) + Math.cos(lastWorkoutInput.gps_latitude*Math.pi/180)*Math.cos(gps_latitude*Math.pi/180)*Math.cos(gps_longitude*Math.pi/180-lastWorkoutInput.gps_longitude*Math.pi/180) ) * 6370)^2)+(((Math.max(lastWorkoutInput.gps_altitude, gps_altitude)-Math.min(lastWorkoutInput.gps_altitude, gps_altitude))/1000)^2))

        var altitude_difference = gps_altitude - lastWorkoutInput.gps_altitude;
        var speed = (distance)/((timestamp - lastWorkoutInput.timestamp)/60/24);

        // Calories
        var calories;
        if(bpm > 0) { calories = ((db_getProfile('age')*genderRecord(db_getProfile('gender').age_factor))-((db_getProfile('weight')*2,20462262)*genderRecord(db_getProfile('gender').weight_factor))+(bpm*genderRecord(db_getProfile('gender').heartrate_factor))-genderRecord(db_getProfile('gender').calories_factor))*(((timespent)/60)/4,184); }
        else { calories = sports[lastWorkoutSummary.sport].factor * db_getProfile('weight') * distance; }
        if (calories < 0) { calories = 0; }

        var hydration = calories / 771.61791764707;

        var sql = 'INSERT INTO `workouts` (id_workout, timestamp, timespent, gps_latitude, gps_longitude, gps_altitude, bpm, distance, altitude_difference, speed, calories, hydratation) VALUES (' + id_workout + ', ' + timestamp + ', ' + gps_latitude + ', ' + gps_longitude + ', ' + gps_altitude + ', ' + bpm + ', ' + distance + ', ' + altitude_difference + ', ' + speed + ', ' + calories + ', ' + hydration + ')';
        console.log(sql);
        tx.executeSql(sql);

        // update workouts_summary accordingly (pricist nove hodnoty)


        stackView.push(ongoingWorkoutScreen);
    });
}
