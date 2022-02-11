import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import QtMultimedia 5.15
import QtAudioEngine 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

Controls.Page {
    id: mainPage
    padding: 0
    property url videoBackground: ""
    property url imageBackground: ""
    property string songTitle: ""
    property string songLyrics: ""

    Item {
        id: mainItem
        anchors.fill: parent

        Controls.SplitView {
            id: splitMainView
            anchors.fill: parent
            handle: Item{
                implicitWidth: 6

                Rectangle {
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    implicitWidth: 2
                    color: Controls.SplitHandle.hovered ? Kirigami.Theme.hoverColor : Kirigami.Theme.backgroundColor
                    //Controls.SplitHandle.pressed ? Kirigami.Theme.focusColor
                    //: (Controls.Splithandle.hovered ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor)
                }
            }

            Presenter.LeftDock {
                id: leftDock
                Controls.SplitView.fillHeight: true
                Controls.SplitView.preferredWidth: 200
            }

            Presenter.SongEditor {
                id: rightMainArea
                Controls.SplitView.fillHeight: true
                Controls.SplitView.fillWidth: true
                Controls.SplitView.preferredWidth: 700
                Controls.SplitView.minimumWidth: 500
            }

            Presenter.Library {
                id: library
                Controls.SplitView.fillHeight: true
                Controls.SplitView.preferredWidth: libraryOpen ? 200 : 0
                Controls.SplitView.maximumWidth: 350
            }
 
        }
    }

    Loader {
        id: presentLoader
        active: presenting
        sourceComponent: Window {
            id: presentationWindow
            title: "presentation-window"
            height: maximumHeight
            width: maximumWidth
            screen: Qt.application.screens[1]
            onClosing: presenting = false
            Component.onCompleted: {
                presentationWindow.showFullScreen();
            }
            Presenter.Slide {
                id: presentationSlide
                imageSource: "../../assets/parallel.jpg"
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a video"
        folder: shortcuts.home
        selectMultiple: false
        onAccepted: {
            print("You chose: " + fileDialog.fileUrls)
            background = fileDialog.fileUrls

            

        }
        onRejected: {
            print("Canceled")
            /* Qt.quit() */
        }
    }
}
