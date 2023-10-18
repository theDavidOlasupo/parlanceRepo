QT += qml quick multimedia gamepad
CONFIG += c++11

# configure the bundle identifier for iOS/tvos QT += quick multimedia gamepad
QMAKE_TARGET_BUNDLE_PREFIX = org.ola
QMAKE_BUNDLE = Parlance

assetsFolder.source = assets
DEPLOYMENTFOLDERS += assetsFolder

DEFINES += \
    APPLICATION_VERSION='\\"1.0.43\\"' \
    GMP_ID='\\"UA-56708757-1\\"'

RESOURCES += qml/qml.qrc \
    assets/common/common.qrc 

SOURCES += \
    main.cpp \
    qgamp/src/googlemp.cpp

HEADERS += \
    qgamp/src/googlemp.h

TRANSLATIONS += \
    qml/parlance_en.ts \
    qml/parlance_fr.ts

android {
    QT += androidextras
    RESOURCES += qml/main/default/main.qrc
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    ANDROID_API_VERSION=34
    ANDROID_MIN_SDK_VERSION=33
    ANDROID_TARGET_SDK_VERSION=34
    DISTFILES += \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew \
        android/gradlew.bat \
        android/res/values/libs.xml \
        android/AndroidManifest.xml
}

ios {
    CONFIG += release
    QMAKE_IOS_DEPLOYMENT_TARGET=12.0
    RESOURCES += qml/main/default/main.qrc
    QMAKE_INFO_PLIST = ios/Project-Info.plist
    QMAKE_ASSET_CATALOGS += ios/Assets.xcassets
    OTHER_FILES += $$QMAKE_INFO_PLIST
}

tvos {
    CONFIG += release
    QMAKE_TVOS_DEPLOYMENT_TARGET=12.0
    RESOURCES += qml/main/tvos/main.qrc
    QMAKE_INFO_PLIST = tvos/Project-Info.plist
    QMAKE_ASSET_CATALOGS += tvos/Assets.xcassets
    OTHER_FILES += $$QMAKE_INFO_PLIST
}

win32 {
    RESOURCES += qml/main/default/main.qrc
    RC_FILE += win/app_icon.rc
}

macx {
    QMAKE_MACOSX_DEPLOYMENT_TARGET=10.12
    RESOURCES += qml/main/default/main.qrc
    ICON = macx/app_icon.icns
}

linux:!android {
    RESOURCES += qml/main/default/main.qrc
}

android: include($$(ANDROID_HOME)/android_openssl/openssl.pri)

ANDROID_ABIS = armeabi-v7a arm64-v8a
