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
    property var video: null

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
