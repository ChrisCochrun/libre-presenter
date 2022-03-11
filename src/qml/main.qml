import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import Qt.labs.platform 1.1 as Labs
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
    property var screens

    property bool editMode: false

    signal edit()

    pageStack.initialPage: mainPage
    header: Presenter.Header {}
    /* Loader { */
    /*     Labs.MenuBar { */
    /*         Labs.Menu { */
    /*             title: qsTr("File") */
    /*             Labs.MenuItem { text: qsTr("New...") } */
    /*             Labs.MenuItem { text: qsTr("Open...") } */
    /*             Labs.MenuItem { text: qsTr("Save") } */
    /*             Labs.MenuItem { text: qsTr("Save As...") } */
    /*             Labs.MenuSeparator { } */
    /*             Labs.MenuItem { text: qsTr("Quit") } */
    /*         } */
    /*         Labs.Menu { */
    /*             title: qsTr("Edit") */
    /*             Labs.MenuItem { text: qsTr("Cut") } */
    /*             Labs.MenuItem { text: qsTr("Copy") } */
    /*             Labs.MenuItem { text: qsTr("Paste") } */
    /*         } */
    /*         Labs.Menu { */
    /*             title: qsTr("Help") */
    /*             Labs.MenuItem { text: qsTr("About") } */
    /*         } */
    /*     } */
    /* } */
    width: 1800
    height: 900

    Presenter.MainWindow {
        id: mainPage
    }

    function toggleEditMode() {
        editMode = !editMode;
        mainPage.editSwitch(editMode);
    }

    function toggleLibrary() {
        libraryOpen = !libraryOpen
    }

    Component.onCompleted: {
        showPassiveNotification(Kirigami.Settings.style);
        Kirigami.Settings.style = "Plasma";
        showPassiveNotification(Kirigami.Settings.style);
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
