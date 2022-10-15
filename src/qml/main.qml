import QtQuick 2.15
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import Qt.labs.platform 1.1 as Labs
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import QtMultimedia 5.15
/* import QtAudioEngine 1.15 */
import org.kde.kirigami 2.13 as Kirigami
import "./presenter" as Presenter
import org.presenter 1.0

Kirigami.ApplicationWindow {
    id: rootApp

    property bool libraryOpen: true
    property bool presenting: false

    property var presentationScreen

    property var screens

    property bool editMode: false

    signal edit()

    onActiveFocusItemChanged: print("FOCUS CHANGED TO: " + activeFocusControl)

    pageStack.initialPage: mainPage
    header: Presenter.Header {}

    menuBar: Controls.MenuBar {
        visible: !Kirigami.Settings.hasPlatformMenuBar
        Controls.Menu {
            title: qsTr("File")
            Controls.MenuItem { text: qsTr("New...") }
            Controls.MenuItem { text: qsTr("Open...") }
            Controls.MenuItem {
                text: qsTr("Save")
                onTriggered: saveFileDialog.open()
            }
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

    Loader {
        id: menuLoader
        active: Kirigami.Settings.hasPlatformMenuBar
        sourceComponent: globalMenuComponent
        onLoaded: print("Loaded global menu")
    }

    Component {
        id: globalMenuComponent
        Labs.MenuBar {
            id: globalMenu
            Labs.Menu {
                title: qsTr("File")
                Labs.MenuItem { text: qsTr("New...") }
                Labs.MenuItem {
                    text: qsTr("Open...")
                    shortcut: "Ctrl+O"
                    onTriggered: loadFileDialog.open()
                }
                Labs.MenuItem {
                    text: qsTr("Save")
                    shortcut: "Ctrl+S"
                    onTriggered: saveFileDialog.open()
                }
                Labs.MenuItem {
                    text: qsTr("Save As...")
                    shortcut: "Ctrl+Shift+S"
                    onTriggered: saveAs()
                }
                Labs.MenuSeparator { }
                Labs.MenuItem { text: qsTr("Quit") }
            }
            Labs.Menu {
                title: qsTr("Settings")
                Labs.MenuItem {
                    text: qsTr("Configure")
                    shortcut: "Ctrl+Shift+I"
                    onTriggered: openSettings()
                }
            }
            Labs.Menu {
                title: qsTr("Help")
                Labs.MenuItem { text: qsTr("About") }
            }
        }
    }

    width: 1800
    height: 900

    Presenter.MainWindow {
        id: mainPage
    }

    FileDialog {
        id: saveFileDialog
        title: "Save"
        folder: shortcuts.home
        /* fileMode: FileDialog.SaveFile */
        defaultSuffix: ".pres"
        selectExisting: false
        onAccepted: {
            save(saveFileDialog.fileUrl + ".pres");
        }
        onRejected: {
            print("Canceled")
        }
    }

    FileDialog {
        id: loadFileDialog
        title: "Load"
        folder: shortcuts.home
        /* fileMode: FileDialog.SaveFile */
        defaultSuffix: ".pres"
        selectExisting: true
        onAccepted: {
            load(loadFileDialog.fileUrl);
        }
        onRejected: {
            print("Canceled")
        }
    }

    function toggleEditMode() {
        editMode = !editMode;
        mainPage.editSwitch();
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

    function save(file) {
        const saved = FileManager.save(file, mainPage.serviceItems.getItems());
        saved ? showPassiveNotification("SAVED! " + file)
            : showPassiveNotification("FAILED!");
    }

    function saveAs() {
        
    }

    function load(file) {
        const loaded = FileManager.load(file);
        loaded ? showPassiveNotification("Loaded: " + file)
            : showPassiveNotification("FAILED!");
        print("Number of items: " + loaded.length);
        print(loaded[0].audio);
    }

    Component.onCompleted: {
        /* showPassiveNotification(Kirigami.Settings.style); */
        /* Kirigami.Settings.style = "Plasma"; */
        /* showPassiveNotification(Kirigami.Settings.style); */
        print("OS is: " + Qt.platform.os);
        print("MENU " + Kirigami.Settings.hasPlatformMenuBar)
        /* print("checking screens"); */
        print("Present Mode is " + presenting);
        /* print(Qt.application.state); */
        screens = Qt.application.screens;
        presentationScreen = screens[1]
        print(Kirigami.Settings.Style);
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
