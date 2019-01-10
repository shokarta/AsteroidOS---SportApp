function db_createTable() {
    // open database connection
    db = LocalStorage.openDatabaseSync(dbId, dbVersion, dbDescription, dbSize);

    // create table for profile if doesnt exists yet
    db.transaction(function(tx) { tx.executeSql('CREATE TABLE IF NOT EXISTS `profile` ('
                                                      + 'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                                                      + 'gender VARCHAR(10) NOT NULL,'
                                                      + 'age TINYINT NOT NULL,'
                                                      + 'weight DOUBLE NOT NULL)'); });

    // create table for wotkouts if doesnt exists yet
    db.transaction(function(tx) { tx.executeSql('CREATE TABLE IF NOT EXISTS `workouts` ('
                                                      + 'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                                                      + 'id_workout INTEGER NOT NULL,'
                                                      + 'timestamp INTEGER NOT NULL,'
                                                      + 'timespent TINYINT NOT NULL,'
                                                      + 'gps_latitude DOUBLE NOT NULL,'
                                                      + 'gps_longitude DOUBLE NOT NULL,'
                                                      + 'gps_altitude DOUBLE NOT NULL,'
                                                      + 'bpm INTEGER, distance DOUBLE NOT NULL,'
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

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT id,gender,age,weight FROM `profile`');
        var myId;
        var myGender;
        var myAge;
        var myWeight;
        var ix;
        for (ix = 0; ix < rs.rows.length; ++ix) {
            myId = rs.rows.item(ix).id;
            myGender = rs.rows.item(ix).gender;
            myAge = rs.rows.item(ix).age;
            myWeight = rs.rows.item(ix).weight;
            personalListView.model.append({
                id: myId,
                gender: myGender,
                age: myAge,
                weight: myWeight
            });
        }
    });
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
