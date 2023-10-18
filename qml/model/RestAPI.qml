import QtQuick 2.0

Item {

    // loading state
    readonly property bool busy: _.requestCount > 0

    // configure request timeout
    property int maxRequestTimeout: 10000

    // private
    QtObject {
        id: _

        property int requestCount: 0;

        function fetch(url, onSuccess, onError, etag) {
            //console.log("fetching", url);
            ++requestCount;
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    --requestCount;
                    switch(xhr.status)
                    {
                    case 200:
                        if (onSuccess) {
                            onSuccess(xhr.responseText, xhr.getResponseHeader('etag'));
                        }
                        break;
                    case 304:
                        if (onUnmodified) {
                            onUnmodified();
                        } else {
                            console.warn("Unmodified!");
                        }
                        break;
                    default:
                        if (onError) {
                            onError(xhr.status + " " + xhr.statusText);
                        } else {
                            console.error("Error : " + xhr.status + " " + xhr.statusText);
                        }
                    }
                }
            }
            xhr.timeout = maxRequestTimeout;
            xhr.open("GET", url);
            if (etag !== null) {
                xhr.setRequestHeader('If-None-Match', etag);
            }
            xhr.send();
        }
    }

    // public rest api functions

    function getStreams(onSuccess, onFailure, etag) {
        _.fetch("https://video.isilive.ca/cdn/app_streams.js", onSuccess, onFailure, etag);
        // _.fetch("https://video.isilive.ca/cdn/app_streams.js", onSuccess, onFailure, etag);
/*
        var fakeBody = {
            'ontla': [
                {
                    title: 'House English',
                    video_url: 'https://http-delivery.isilive.ca/live/_definst_/ontla/house-en/playlist.m3u8'
                },
                {
                    title: 'House Francais',
                    video_url: 'https://http-delivery.isilive.ca/live/_definst_/ontla/house-fr/playlist.m3u8'
                },
                {
                    title: 'Amethyst Room English',
                    video_url: 'https://http-delivery.isilive.ca/live/_definst_/ontla/house-en/playlist.m3u8'
                },
                {
                    title: 'Amethyst Room Francais',
                    video_url: 'https://http-delivery.isilive.ca/live/_definst_/ontla/house-fr/playlist.m3u8'
                }
            ],
            'nunavut': [
                {
                    title: 'English',
                    video_url: 'https://http-delivery.isilive.ca/live/_definst_/nunavut/live-eng/playlist.m3u8'
                },
                {
                    title: 'áƒá“„á’ƒá‘Žá‘á‘¦',
                    video_url: 'https://http-delivery.isilive.ca/live/_definst_/nunavut/live-iku/playlist.m3u8'
                },
                {
                    title: 'Inuinnaqtun',
                    video_url: 'https://http-delivery.isilive.ca/live/_definst_/nunavut/live-inu/playlist.m3u8'
                },
                {
                    title: 'Original',
                    video_url: 'https://http-delivery.isilive.ca/live/_definst_/nunavut/live-flo/playlist.m3u8'
                }
            ]
        }
        onSuccess(fakeBody);
*/
    }

}
