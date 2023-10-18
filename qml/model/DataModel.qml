import QtQuick 2.0
import "../util"

Item {

    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target

    // whether api is busy (ongoing network requests)
    readonly property bool isBusy: api.busy

    // whether a user is logged in
    readonly property bool userLoggedIn: _.userLoggedIn

    // whether todos are currently being fetched
    readonly property bool isFetchingStreams: _.isFetchingStreams

    // model data properties
    readonly property alias streams: _.streams

    signal fetchStreamsSucceeded()
    signal fetchStreamsFailed(var error)

    Connections {
        id: logicConnection

        function onFetchStreams() {

            //var cached = cache.getValue("streams")
            //if(cached) {
            //    _.streams = cached
            //}

            _.isFetchingStreams = true;
            api.getStreams(function(data) {
                //cache.setValue("streams", JSON.parse(data));
                _.streams = JSON.parse(data);
                _.isFetchingStreams = false;
                fetchStreamsSucceeded()
            },
            function(error) {
                // action failed if no cached data
                _.isFetchingStreams = false;
                //if(cached) {
                //    fetchStreamsSucceeded()
                //} else {
                    fetchStreamsFailed(error)
                //}
            });
        }

        function onClearCache() {
            //cache.clearAll()
        }

        function onLogin() {
            _.userLoggedIn = true
        }

        function onLogout() {
            _.userLoggedIn = false
        }
    }

    // you can place getter functions here that do not modify the data
    // pages trigger write operations through logic signals only

    // rest api for data access
    RestAPI {
        id: api
        maxRequestTimeout: 10000 // use max request timeout of 10 sec
    }

    // storage for caching
    Storage {
        id: cache
    }

    // private
    Item {
        id: _
        property var streams: []
        property bool userLoggedIn: true
        property bool isFetchingStreams: false
    }
}
