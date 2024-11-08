# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-haeretahiti

CONFIG += sailfishapp

SOURCES += \
    src/busline.cpp \
    src/buslinemodel.cpp \
    src/busposition.cpp \
    src/buspositionmodel.cpp \
    src/busstop.cpp \
    src/busstopmodel.cpp \
    src/harbour-teretahiti.cpp

OTHER_FILES += \
    qml/harbour-haeretahiti.qml \
    qml/cover/CoverPage.qml \
    translations/*.ts \
    harbour-haeretahiti.desktop

CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-haeretahiti-fr.ts

DISTFILES += \
    qml/pages/LinesPage.qml \
    qml/pages/NextBusesPage.qml \
    qml/pages/StopsPage.qml \
    rpm/harbour-haeretahiti.spec \
    rpm/harbour-haeretahiti.yaml


SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

HEADERS += \
    src/busline.h \
    src/buslinemodel.h \
    src/busposition.h \
    src/buspositionmodel.h \
    src/busstop.h \
    src/busstopmodel.h

QT += positioning location

RESOURCES += \
  misc.qrc
