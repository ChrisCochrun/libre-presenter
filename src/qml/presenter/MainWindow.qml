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
    property url imageBackground: ""
    property url videoBackground: ""
    property var song
    property string songTitle: ""
    property string songLyrics: ""
    property string songAuthor: ""
    property int blurRadius: 0

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
                Controls.SplitView.maximumWidth: 300
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
            screen: secondScreen
            onClosing: presenting = false
            Component.onCompleted: {
                presentationWindow.showFullScreen();
                print(Qt.application.screens[1])
            }
            Presenter.Slide {
                id: presentationSlide
                imageSource: imageBackground
                videoSource: videoBackground
            }
        }
    }

    FileDialog {
        id: videoFileDialog
        title: "Please choose a background"
        folder: shortcuts.home
        selectMultiple: false
        nameFilters: ["Video files (*.mp4 *.mkv *.mov *.wmv *.avi *.MP4 *.MOV *.MKV)"]
        onAccepted: {
            imageBackground = ""
            videoBackground = videoFileDialog.fileUrls[0]
            print("video background = " + videoFileDialog.fileUrl)
        }
        onRejected: {
            print("Canceled")
            /* Qt.quit() */
        }

    }

    FileDialog {
        id: imageFileDialog
        title: "Please choose a background"
        folder: shortcuts.home
        selectMultiple: false
        nameFilters: ["Image files (*.jpg *.jpeg *.png *.JPG *.JPEG *.PNG)"]
        onAccepted: {
            videoBackground = ""
            imageBackground = imageFileDialog.fileUrls
        }
        onRejected: {
            print("Canceled")
            /* Qt.quit() */
        }

    }
}
