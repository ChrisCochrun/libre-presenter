import QtQuick 2.13
import QtQuick.Controls 2.15 as Controls
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import mpv 1.0

Item {
    id: root

    property string type: "video"
    property var video
    property bool audioOn: true

    GridLayout {
        id: mainLayout
        anchors.fill: parent
        columns: 2
        rowSpacing: 5
        columnSpacing: 0

        Controls.ToolBar {
            Layout.fillWidth: true
            Layout.columnSpan: 2
            id: toolbar
            RowLayout {
                anchors.fill: parent 

                Controls.TextField {
                    implicitWidth: 300
                    hoverEnabled: true
                    placeholderText: "Song Title..."
                    text: video.title
                    padding: 10
                    onEditingFinished: updateTitle(text);
                }

                Controls.CheckBox {
                    id: loopCheckBox
                    Layout.preferredWidth: 300
                    Layout.fillWidth: true
                    Layout.leftMargin: 20
                    Layout.rightMargin: 20

                    text: "Repeat"
                    padding: 10
                    checked: video.loop
                    onToggled: updateLoop(!video.loop)
                }

                Controls.ToolSeparator {}

                Item { Layout.fillWidth: true }
                Controls.ToolSeparator {}
                Controls.ToolButton {
                    text: "Effects"
                    icon.name: "image-auto-adjust"
                    hoverEnabled: true
                    onClicked: {}
                }
                Controls.ToolButton {
                    id: backgroundButton
                    text: "Background"
                    icon.name: "fileopen"
                    hoverEnabled: true
                    onClicked: backgroundType.open()
                }

                Controls.Popup {
                    id: backgroundType
                    x: backgroundButton.x
                    y: backgroundButton.y + backgroundButton.height + 20
                    modal: true
                    focus: true
                    dim: false
                    background: Rectangle {
                        Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip
                        color: Kirigami.Theme.backgroundColor
                        radius: 10
                        border.color: Kirigami.Theme.activeBackgroundColor
                        border.width: 2
                    }
                    closePolicy: Controls.Popup.CloseOnEscape | Controls.Popup.CloseOnPressOutsideParent
                    ColumnLayout {
                        anchors.fill: parent
                        Controls.ToolButton {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: "Video"
                            icon.name: "emblem-videos-symbolic"
                            onClicked: videoFileDialog.open() & backgroundType.close()
                        }
                        Controls.ToolButton {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            text: "Image"
                            icon.name: "folder-pictures-symbolic"
                            onClicked: imageFileDialog.open() & backgroundType.close()
                        }
                    }
                }
            }
        }

        Item {
            id: topEmpty
            Layout.preferredHeight: 50
            Layout.fillWidth: true
            Layout.columnSpan: 2
        }

        Controls.Label {
            id: filePathLabel
            Layout.columnSpan: 2
            Layout.preferredWidth: 600
            Layout.alignment: Qt.AlignCenter
            text: video.filePath
        }

        MpvObject {
            id: videoPreview
	    objectName: "mpv"
            Layout.columnSpan: 2
            Layout.preferredWidth: 600
            Layout.preferredHeight: Layout.preferredWidth / 16 * 9
            Layout.alignment: Qt.AlignCenter
            useHwdec: true
            enableAudio: audioOn
            Component.onCompleted: mpvLoadingTimer.start()
            onPositionChanged: videoSlider.value = position
            onFileLoaded: {
                showPassiveNotification(video.title + " has been loaded");
                videoPreview.pause();
            }
        }
        Rectangle {
            id: videoBg
            color: Kirigami.Theme.alternateBackgroundColor

            Layout.columnSpan: 2
            Layout.preferredWidth: videoPreview.Layout.preferredWidth
            Layout.preferredHeight: videoTitleField.height
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                anchors.fill: parent
                spacing: 2
                Kirigami.Icon {
                    source: videoPreview.isPlaying ? "media-pause" : "media-play"
                    Layout.preferredWidth: 25
                    Layout.preferredHeight: 25
                    MouseArea {
                        anchors.fill: parent
                        onPressed: videoPreview.playPause()
                        cursorShape: Qt.PointingHandCursor
                    }
                }
                Controls.Slider {
                    id: videoSlider
                    Layout.fillWidth: true
                    Layout.preferredHeight: 25
                    from: 0
                    to: videoPreview.duration
                    /* value: videoPreview.postion */
                    live: true
                    onMoved: videoPreview.seek(value);
                }
            }

        }

        Item {
            Layout.columnSpan: 2
            Layout.preferredHeight: 60
        }

        Controls.RangeSlider {
            id: videoLengthSlider

            Layout.columnSpan: 2
            Layout.preferredWidth: videoPreview.Layout.preferredWidth
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.leftMargin: width / 3
            Layout.rightMargin: width / 3

            to: videoPreview.duration
            from: 0

            first.value: 0
            second.value: to

            first.onMoved: updateStartTime(first.value)
            second.onMoved: updateEndTime(second.value)

        }

        Controls.Label {
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: videoLengthSlider.Layout.leftMargin
            text: "Start Time: " + videoLengthSlider.first.value
        }

        Controls.Label {
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: videoLengthSlider.Layout.rightMargin
            text: "End Time: " + videoLengthSlider.second.value
        }

        Item {
            id: botEmpty
            Layout.fillHeight: true
        }

        /* } */
    }
    Timer {
        id: mpvLoadingTimer
        interval: 100
        onTriggered: {
            videoPreview.loadFile(video.filePath.toString());
            /* showPassiveNotification(video[0]); */
        }
    }

    function changeVideo(video) {
        root.video = video;
        mpvLoadingTimer.restart();
    }

    function stop() {
        console.log("stopping video");
        videoPreview.pause();
        console.log("quit mpv");
    }

    function updateEndTime(value) {
        /* changeStartTime(value, false); */
        videosqlmodel.updateEndTime(video.id, value);
        video.endTime = value;
        showPassiveNotification(video.endTime);
    }

    function updateStartTime(value) {
        /* changeStartTime(value, false); */
        videosqlmodel.updateStartTime(video.id, value);
        video.startTime = value;
        showPassiveNotification(video.startTime);
    }

    function updateTitle(text) {
        changeTitle(text, false);
        videosqlmodel.updateTitle(video.id, text);
        showPassiveNotification(video.title);
    }

    function updateLoop(value) {
        /* changeStartTime(value, false); */
        videosqlmodel.updateLoop(video.id, value);
        video.loop = value;
        showPassiveNotification("Loop changed to: " + video.loop);
    }

    function changeTitle(text, updateBox) {
        if (updateBox)
            videoTitleField.text = text;
        video.title = text;
    }
}
