QT += quick qml widgets svg
QTPLUGIN += qsvg

SOURCES += src/main.cpp

RESOURCES += src/main.qrc

include(lib/org/qtmob/material/wrapper/org_qtmob_material_wrapper.pri)

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle

OTHER_FILES += \
    android/AndroidManifest.xml


ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
