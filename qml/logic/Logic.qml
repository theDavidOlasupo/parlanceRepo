import QtQuick 2.0

QtObject {
    signal fetchStreams()
    signal clearCache()
    signal login(string username, string password)
    signal logout()
}
