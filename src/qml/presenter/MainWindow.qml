import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.0 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import QtMultimedia 5.15
import QtAudioEngine 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

Kirigami.Page {
    id: mainPage
    title: "Presenter"
    padding: 0
    property var video: null

    actions {
        main: Kirigami.Action {
            icon.name: "fileopen"
            text: "VideoBG"
            onTriggered: {
                print("Action button in buttons page clicked");
                fileDialog.open()
            }
        }
        right: Kirigami.Action {
            icon.name: "view-presentation"
            text: "Go Live"
            onTriggered: {
                print("Window is loading")
                presentLoader.active = true
            }
        }
    }

    Item {
        id: mainItem
        anchors.fill: parent
        height: parent.height

        GridLayout {
            id: gridLayout
            anchors.fill: parent
            height: parent.height
            columns: 3
            rows: 2
            Presenter.LeftDock {
                id: leftDock
                Layout.fillHeight: true
                implicitWidth: 200
            }

            Rectangle {
                id: leftDockBorder
                color: "lightblue"
                Layout.fillHeight: true
                width: 2
            }

            Rectangle {
                id: rightMainArea
                color: "red"
                Layout.fillHeight: true
                Layout.fillWidth: true
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
            video = fileDialog.fileUrl
        }
        onRejected: {
            print("Canceled")
            /* Qt.quit() */
        }
    }

    Loader {
        id: presentLoader
        active: false
        sourceComponent: Window {
            id: presentWindow
            title: "presentation-window"
            height: maximumHeight
            width: maximumWidth
            visible: true
            onClosing: presentLoader.active = false
            Component.onCompleted: {
                presentWindow.showFullScreen();
            }
            Item {
                id: basePresentationLayer
                anchors.fill: parent
                Rectangle {
                    id: basePrColor
                    anchors.fill: parent
                    color: "black"

                    MediaPlayer {
                        id: videoPlayer
                        source: video
                        loops: MediaPlayer.Infinite
                        autoPlay: true
                        notifyInterval: 100
                    }

                    VideoOutput {
                        id: videoOutput
                        anchors.fill: parent
                        source: videoPlayer
                    }
                    MouseArea {
                        id: playArea
                        anchors.fill: parent
                        onPressed: videoPlayer.play();
                    }

                    Controls.ProgressBar {
                        id: progressBar

                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 100
                        from: 0
                        to: videoPlayer.duraion
                        value: videoPlayer.position/videoPlayer.duration

                        height: 30

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                if (videoPlayer.seekable) {
                                    videoPlayer.seek(videoPlayer.duration * mouse.x/width);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
