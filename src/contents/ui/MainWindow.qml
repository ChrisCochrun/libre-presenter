import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.0 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import QtMultimedia 5.15
import QtAudioEngine 1.15
import org.kde.kirigami 2.13 as Kirigami

Component {
    id: root
    Kirigami.ScrollablePage {
        id: mainPage
        title: "Presenter"
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
        /* Kirigami.OverlaySheet { */
        /*     id: sheet */
        /*     onSheetOpenChanged: page.actions.main.checked = sheetOpen */
        /*     Controls.Label { */
        /*         wrapMode: Text.WordWrap */
        /*         text: "Lorem ipsum dolor sit amet" */
        /*     } */
        /* } */
        //Page contents...

        Rectangle {
            id: bg
            anchors.fill: parent
            color: "blue"
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
}

