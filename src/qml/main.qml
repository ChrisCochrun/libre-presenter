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

    property var presentationScreen

    property var screens

    property bool editMode: false

    signal edit()

    pageStack.initialPage: mainPage
    header: Presenter.Header {}

    menuBar: Controls.MenuBar {
        Controls.Menu {
            title: qsTr("File")
            Controls.MenuItem { text: qsTr("New...") }
            Controls.MenuItem { text: qsTr("Open...") }
            Controls.MenuItem { text: qsTr("Save") }
            Controls.MenuItem { text: qsTr("Save As...") }
            Controls.MenuSeparator { }
            Controls.MenuItem { text: qsTr("Quit") }
        }
        Controls.Menu {
            title: qsTr("Settings")
            Controls.MenuItem {
                text: qsTr("Configure")
                onTriggered: openSettings()
            }
        }
        Controls.Menu {
            title: qsTr("Help")
            Controls.MenuItem { text: qsTr("About") }
        }
    }

    Labs.MenuBar {
        Labs.Menu {
            title: qsTr("File")
            Labs.MenuItem { text: qsTr("New...") }
            Labs.MenuItem { text: qsTr("Open...") }
            Labs.MenuItem { text: qsTr("Save") }
            Labs.MenuItem { text: qsTr("Save As...") }
            Labs.MenuSeparator { }
            Labs.MenuItem { text: qsTr("Quit") }
        }
        Labs.Menu {
            title: qsTr("Settings")
            Labs.MenuItem {
                text: qsTr("Configure")
                onTriggered: openSettings()
            }
        }
        Labs.Menu {
            title: qsTr("Help")
            Labs.MenuItem { text: qsTr("About") }
        }
    }

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

    function togglePresenting() {
        presenting = !presenting
        mainPage.present(presenting);
    }

    function openSettings() {
        settingsSheet.open()
    }

    Component.onCompleted: {
        /* showPassiveNotification(Kirigami.Settings.style); */
        /* Kirigami.Settings.style = "Plasma"; */
        /* showPassiveNotification(Kirigami.Settings.style); */
        print("OS is: " + Qt.platform.os);
        /* print("checking screens"); */
        print("Present Mode is " + presenting);
        /* print(Qt.application.state); */
        screens = Qt.application.screens;
        presentationScreen = screens[1]
        for (let i = 0; i < screens.length; i++) {
            /* print(screens[i]); */
            /* print(screens[i].name); */
            screenModel.append({
                "name": screens[i].name,
                "width": (screens[i].width * screens[i].devicePixelRatio),
                "height": (screens[i].height * screens[i].devicePixelRatio),
                "pixeldensity": screens[i].pixelDensity,
                "pixelratio": screens[i].devicePixelRatio
            })
            /* print("width of screen: " + (screens[i].width * screens[i].devicePixelRatio)); */
            /* print("height of screen: " + (screens[i].height * screens[i].devicePixelRatio)); */
            /* print("pixeldensity of screen: " + screens[i].pixelDensity); */
            /* print("pixelratio of screen: " + screens[i].devicePixelRatio); */
            if (i == 0)
                print("Current Screens available: ");
            print(screenModel.get(i).name);
        }
    }

    ListModel {
        id: screenModel
    }

    Presenter.Settings {
        id: settingsSheet
        theModel: screenModel
    }
    
}
