import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0
import Qt.labs.settings 1.0

Kirigami.OverlaySheet {
    id: root

    property bool ytdlLoaded: false

    header: Kirigami.Heading {
        text: "Add a new video"
    }

    ColumnLayout {
        Controls.ToolBar {
            id: toolbar
            Layout.fillWidth: true
            RowLayout {
                anchors.fill: parent
                Controls.Label {
                    id: videoInputLabel
                    text: "Enter a video"
                }

                Controls.TextField {
                    id: videoInput
                    Layout.fillWidth: true
                    hoverEnabled: true
                    placeholderText: "Enter a video url..."
                    text: ""
                    onEditingFinished: videoInput.text.startsWith("http") ? loadVideo() : showPassiveNotification("Coach called, this isn't it.");
                }
            }
        }

        Item {
            id: centerItem
            Layout.preferredHeight: Kirigami.Units.gridUnit * 25
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            visible: true

            Controls.BusyIndicator {
                id: loadingIndicator
                anchors.centerIn: parent
                running: ytdl.loading
            }

            Ytdl {
                id: ytdl
                loaded: false
                loading: false
            }

            /* Rectangle { */
            /*     color: "blue" */
            /*     anchors.fill: parent */
            /* } */
            ColumnLayout {
                id: loadedItem
                anchors.fill: parent
                visible: ytdl.loaded
                Image {
                    id: thumbnailImage
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.preferredHeight: width * 9 / 16
                    source: ytdl.thumbnail
                    fillMode: Image.PreserveAspectFit
                    clip: true

                    Item {
                        id: mask
                        anchors.fill: thumbnailImage
                        visible: false

                        Rectangle {
                            color: "white"
                            radius: 20
                            anchors.centerIn: parent
                            width: thumbnailImage.paintedWidth
                            height: thumbnailImage.paintedHeight
                        }
                    }
                    OpacityMask {
                        anchors.fill: thumbnailImage
                        source: thumbnailImage
                        maskSource: mask
                    }

                }
                Item {
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Controls.Label {
                        id: videoTitle
                        text: ytdl.title
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 2
                    Controls.Button {
                        anchors.right: parent.right
                        text: "Ok"
                        onClicked: { clear(); root.close();}
                    }
                }
            }

        }
    }

    function loadVideo() {
        if (ytdl.getVideo(videoInput.text))
            loadingIndicator.visible = true;
    }

    function clear() {
        ytdl.title = "";
        ytdl.thumbnail = "";
        ytdl.loaded = false;
        ytdl.loading = false;
    }
}
