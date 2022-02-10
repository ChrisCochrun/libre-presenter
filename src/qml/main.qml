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
    id: root

    property bool libraryOpen: true
    property bool presenting: false
        
    pageStack.initialPage: mainPage
    header: Presenter.Header {}
    width: 1280

    Presenter.MainWindow {
        id: mainPage
    }

    function toggleLibrary() {
        libraryOpen = !libraryOpen
    }
}
