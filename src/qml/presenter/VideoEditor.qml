import QtQuick 2.15
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

                Controls.Label {
                    text: "Title:"
                }
                Controls.TextField {
                    implicitWidth: 300
                    hoverEnabled: true
                    placeholderText: "Song Title..."
                    text: video.title
                    padding: 10
                    onEditingFinished: updateTitle(text);
                }

                Controls.Label {
                    text: "Looping:"
                    Layout.leftMargin: 20
                }
                Controls.CheckBox {
                    id: loopCheckBox
                    Layout.preferredWidth: 300
                    Layout.fillWidth: true
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
                    id: fileButton
                    text: "File"
                    icon.name: "fileopen"
                    hoverEnabled: true
                    onClicked: fileType.open()
                }
            }
        }

        Item {
            Layout.columnSpan: 2
            Layout.preferredWidth: root.width - 50
            Layout.preferredHeight: Layout.preferredWidth / 16 * 9
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 10

            MpvObject {
                id: videoPreview
                width: parent.width
                height: parent.height
	        objectName: "mpv"
                useHwdec: true
                enableAudio: audioOn
                Component.onCompleted: mpvLoadingTimer.start()
                onPositionChanged: videoSlider.value = position
                onFileLoaded: {
                    /* showPassiveNotification(video.title + " has been loaded"); */
                    videoPreview.pause();
                }
            }

            Rectangle {
                id: videoBg
                color: Kirigami.Theme.alternateBackgroundColor

                anchors.top: videoPreview.bottom
                width: parent.width
                height: videoTitleField.height

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

                    Controls.Label {
                        id: videoTime
                        text: new Date(videoPreview.position * 1000).toISOString().slice(11, 19);
                    }
                }

            }
        }

        Controls.RangeSlider {
            id: videoLengthSlider

            Layout.columnSpan: 2
            Layout.preferredWidth: videoPreview.Layout.preferredWidth
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.leftMargin: 25
            Layout.rightMargin: 25
            Layout.topMargin: 50

            to: videoPreview.duration
            from: 0
            stepSize: 0.1
            snapMode: Controls.RangeSlider.SnapAlways

            first.value: video.startTime
            second.value: video.endTime

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

        Controls.ToolButton {
            text: "FIX"
            onClicked: videoLengthSlider.setValues(video.startTime, video.endTime)
        }

        Item {
            id: botEmpty
            Layout.fillHeight: true
        }

        Controls.TextArea {
            id: filePathLabel
            Layout.alignment: Qt.AlignBottom
            Layout.fillWidth: true
            Layout.columnSpan: 2
            text: "File path: " + video.filePath
            background: Item{}
            readOnly: true
            HoverHandler {
                id: hoverHandler
                enabled: false
                cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.IBeamCursor
            }
        }

        /* } */
    }
    Timer {
        id: mpvLoadingTimer
        interval: 100
        onTriggered: {
            videoPreview.loadFile(video.filePath.toString());
            videoLengthSlider.setValues(video.startTime, video.endTime);
            /* showPassiveNotification(video[0]); */
        }
    }

    function changeVideo(index) {
        let vid = videoProxyModel.getVideo(index);
        root.video = vid;
        console.log(video.startTime);
        console.log(video.endTime);
        mpvLoadingTimer.restart();
        videoLengthSlider.setValues(vid.startTime, vid.endTime);
    }

    function stop() {
        console.log("stopping video");
        videoPreview.pause();
        console.log("quit mpv");
    }

    function updateEndTime(value) {
        videoPreview.seek(value);
        videoProxyModel.updateEndTime(video.id, value);
        video.endTime = value;
        /* showPassiveNotification(video.endTime); */
    }

    function updateStartTime(value) {
        /* changeStartTime(value, false); */
        videoPreview.seek(value);
        videoProxyModel.updateStartTime(video.id, value);
        video.startTime = value;
        /* showPassiveNotification(value); */
    }

    function updateTitle(text) {
        changeTitle(text, false);
        videoProxyModel.updateTitle(video.id, text);
        /* showPassiveNotification(video.title); */
    }

    function updateLoop(value) {
        /* changeStartTime(value, false); */
        let bool = videoProxyModel.updateLoop(video.id, value);
        video.loop = value;
        /* showPassiveNotification("Loop changed to: " + video.loop); */
    }

    function changeTitle(text, updateBox) {
        if (updateBox)
            videoTitleField.text = text;
        video.title = text;
    }
}
