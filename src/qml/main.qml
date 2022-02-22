import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.0 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import QtMultimedia 5.15
import QtAudioEngine 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./presenter" as Presenter

Kirigami.ApplicationWindow {
    id: rootApp

    property bool libraryOpen: true
    property bool presenting: false
    property bool presentMode: true
    property var screens
        
    pageStack.initialPage: mainPage
    header: Presenter.Header {}
    width: 1800
    height: 900

    Presenter.MainWindow {
        id: mainPage
    }

    function toggleLibrary() {
        libraryOpen = !libraryOpen
    }

    Component.onCompleted: {
        print("checking screens");
        print("Present Mode is " + presentMode);
        screens = Qt.application.screens;
        for (let i = 0; i < screens.length; i++) {
            print(screens[i].name);
            print("width of screen: " + (screens[i].width * screens[i].devicePixelRatio));
            print("height of screen: " + (screens[i].height * screens[i].devicePixelRatio));
            print("pixeldensity of screen: " + screens[i].pixelDensity);
            print("pixelratio of screen: " + screens[i].devicePixelRatio);
        }
    }

}
