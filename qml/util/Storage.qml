import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Item {

    QtObject {
        id: _
        property var db: {
            try {
                var db = LocalStorage.openDatabaseSync("Parlance_DB", "", "Parlance Local Database", 1000000);
                try {
                    db.transaction(function (tx) {
                        tx.executeSql('CREATE TABLE IF NOT EXISTS storage (key text, value text)')
                    })
                } catch (err) {
                    console.error("Error initializing database: " + err)
                }
            } catch (err) {
                console.error("Cannot open database: " + err);
            }
            return db;
        }
    }

    function setValue(key, value) {
        try {
            _.db.transaction(function (tx) {
                var results = tx.executeSql('SELECT value FROM storage WHERE key = ?', key);
                if (results.rows.length > 0) {
                    tx.executeSql('UPDATE storage set value=? where key = ?', [JSON.stringify(value), key]);
                } else {
                    tx.executeSql('INSERT INTO storage VALUES(?, ?)', [key, JSON.stringify(value)])
                }
            });
        } catch (err) {
            console.error("Error storing into database: " + err)
        }
    }

    function getValue(key) {
        var value = null;
        try {
            _.db.transaction(function (tx) {
                var results = tx.executeSql('SELECT value FROM storage WHERE key = ?', key);
                if (results.rows.length > 0) {
                    value = JSON.parse(results.rows.item(0).value);
                }
            })
        } catch (err) {
            console.error("Error reading from database: " + err)
        }
        return value;
    }

    function clearAll() {
        try {
            _.db.transaction(function (tx) {
                tx.executeSql('DELETE FROM storage');
            })
        } catch (err) {
            console.error("Error clearing database: " + err)
        }
    }
}
