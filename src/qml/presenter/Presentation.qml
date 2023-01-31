import QtQuick 2.15
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
/* import QtAudioEngine 1.15 */
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0
import mpv 1.0

FocusScope {
    id: root

    /* height: parent.height */

    property var text
    property int textIndex: 0
    property string itemType: SlideObject.type
    property url imagebackground: SlideObject.imageBackground
    property url vidbackground: SlideObject.videoBackground

    property Item slide: previewSlide

    property bool focusTimer: true

    /* Component.onCompleted: nextSlideAction() */

    ColumnLayout {
        id: mainGrid
        anchors.fill: parent
        /* anchors.bottomMargin: Kirigami.Units.largeSpacing * 2 */
        /* columns: 3 */
        /* rowSpacing: 5 */
        /* columnSpacing: 0 */

        Controls.ToolBar {
            Layout.fillWidth: true
            /* Layout.columnSpan: 3 */
            Layout.alignment: Qt.AlignTop
            id: toolbar
            RowLayout {
                anchors.fill: parent 

                Controls.ToolButton {
                    text: "Solo"
                    icon.name: "viewimage"
                    hoverEnabled: true
                    onClicked: {
                        stack.replace(presenterView)
                    }
                }
                Controls.ToolButton {
                    text: "Grid"
                    icon.name: "view-app-grid-symbolic"
                    hoverEnabled: true
                    onClicked: {
                        stack.replace(gridView)
                    }
                }
                Controls.ToolButton {
                    text: "Details"
                    icon.name: "view-list-details"
                    hoverEnabled: true
                    onClicked: serviceThing.activate();
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
                    text: "Wah!"
                    icon.name: "audio-volume-high"
                    hoverEnabled: true
                    onClicked: {
                        audio.loadFile("/home/chris/nextcloud/tfcstaff/Lessons/2022-2023 Lessons/Unit 4/4.1/Wah Wahh Wahhh Sound Effect.m4a");
                    }
                }
            }
        }

        Controls.StackView {
            id: stack
            Layout.fillHeight: true
            Layout.fillWidth: true
            initialItem: presenterView

        }

        Component {
            id: presenterView

            Item {
                anchors.fill: parent
                Item {
                    id: slideArea
                    implicitWidth: parent.width
                    implicitHeight: parent.height - previewSlidesList.height
                    /* anchors.bottomMargin: previewSlidesList.height */

                    Kirigami.Icon {
                        source: "arrow-left"
                        implicitWidth: Kirigami.Units.gridUnit * 7
                        implicitHeight: Kirigami.Units.gridUnit * 10
                        anchors.right: previewSlide.left
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            onPressed: previousSlideAction()
                            cursorShape: Qt.PointingHandCursor
                        }
                    }

                    Presenter.Slide {
                        id: previewSlide
                        implicitWidth: root.width - 400 > 200 ? root.width - 400 : 200
                        implicitHeight: width / 16 * 9
                        anchors.centerIn: parent
                        textSize: SlideObject.fontSize
                        itemType: SlideObject.type
                        imageSource: SlideObject.imageBackground
                        videoSource: SlideObject.videoBackground
                        audioSource: SlideObject.audio
                        chosenFont: SlideObject.font
                        text: SlideObject.text
                        pdfIndex: SlideObject.pdfIndex
                        preview: true 
                    }

                    Kirigami.Icon {
                        source: "arrow-right"
                        implicitWidth: Kirigami.Units.gridUnit * 7
                        implicitHeight: Kirigami.Units.gridUnit * 10
                        anchors.left: previewSlide.right
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            onPressed: nextSlideAction()
                            cursorShape: Qt.PointingHandCursor
                        }
                    }

                    RowLayout {
                        spacing: 2
                        width: previewSlide.width
                        /* Layout.alignment: Qt.AlignHCenter, Qt.AlignTop */
                        anchors.top: previewSlide.bottom
                        anchors.topMargin: 10
                        anchors.horizontalCenter: previewSlide.horizontalCenter
                        /* Layout.columnSpan: 3 */
                        visible: itemType === "video";
                        Controls.ToolButton {
                            Layout.preferredWidth: 25
                            Layout.preferredHeight: 25
                            icon.name: previewSlide.mpvIsPlaying ? "media-pause" : "media-play"
                            hoverEnabled: true
                            onClicked: SlideObject.playPause();
                        }
                        Controls.Slider {
                            id: videoSlider
                            Layout.fillWidth: true
                            Layout.preferredHeight: 25
                            from: 0
                            to: previewSlide.mpvDuration
                            value: previewSlide.mpvPosition
                            live: true
                            onMoved: changeVidPos(value);
                        }

                        Controls.Switch {
                            text: "Loop"
                            checked: previewSlide.mpvLoop === "inf" ? true : false
                            onToggled: mainPage.loopVideo()
                            Keys.onLeftPressed: previousSlideAction()
                            Keys.onRightPressed: nextSlideAction()
                            Keys.onUpPressed: previousSlideAction()
                            Keys.onDownPressed: nextSlideAction()
                        }
                    }

                }

                ListView {
                    // The active items X value from root
                    property int activeX
                    id: previewSlidesList
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: Kirigami.Units.gridUnit * 9
                    orientation: ListView.Horizontal
                    spacing: Kirigami.Units.smallSpacing * 2
                    cacheBuffer: 900
                    reuseItems: true
                    model: SlideModel
                    delegate: Presenter.PreviewSlideListDelegate {}

                    Kirigami.WheelHandler {
                        id: wheelHandler
                        target: previewSlidesList
                        filterMouseEvents: true
                    }

                    Controls.ScrollBar.horizontal: Controls.ScrollBar {
                        active: hovered || pressed
                    }

                }

                Rectangle {
                    id: activeHighlightBar
                    width: Kirigami.Units.gridUnit * 10
                    height: Kirigami.Units.gridUnit / 4
                    y: previewSlidesList.y + Kirigami.Units.gridUnit * 6.15
                    x: previewSlidesList.currentItem.x + Kirigami.Units.smallSpacing
                    radius: 5
                    color: Kirigami.Theme.negativeTextColor

                    Behavior on x { PropertyAnimation {
                        properties: "x"
                        easing.type: Easing.InOutElastic;
                        easing.period: 1.5
                        duration: 150
                    }}
                }
            }
        }

        Component {
            id: gridView
            /* Layout.fillHeight: true */
            /* Layout.fillWidth: true */
            /* Layout.alignment: Qt.AlignTop */
            /* visible: false */

            GridView {
                // The active items X value from root
                property int activeX
                id: previewSlidesGrid
                anchors.fill: parent
                cellWidth: Kirigami.Units.gridUnit * 11
                cellHeight: Kirigami.Units.gridUnit * 8
                /* spacing: Kirigami.Units.smallSpacing * 2 */
                cacheBuffer: 200
                reuseItems: false
                clip: true
                model: SlideModel
                delegate: Presenter.PreviewSlideListDelegate { showVidBG: false }

                Kirigami.WheelHandler {
                    id: gridWheelHandler
                    target: previewSlidesGrid
                    filterMouseEvents: true
                }

                Controls.ScrollBar.vertical: Controls.ScrollBar {
                    active: hovered || pressed
                }

            }


        }
    }

    Item {
        id: keyHandler
        /* anchors.fill: parent */
        focus: true
        Keys.onLeftPressed: previousSlideAction()
        Keys.onRightPressed: nextSlideAction()
        Keys.onUpPressed: previousSlideAction()
        Keys.onDownPressed: nextSlideAction()
        Keys.onSpacePressed: nextSlideAction()
    }

    Connections {
        target: SlideObject
        function onVideoBackgroundChanged() {
            if (SlideObject.videoBackground === "")
                stopVideo();
            else
                loadVideo();
        }
        function onIsPlayingChanged() {
            if(SlideObject.isPlaying)
                previewSlide.playVideo();
            pauseVideo();
        }
        /* function onAudioChanged() { */
        /*     showPassiveNotification("Audio should change"); */
        /*     previewSlide.playAudio(); */
        /* } */
    }

    Timer {
        interval: 500
        running: false
        repeat: focusTimer
        onTriggered: root.visible ? keyHandler.forceActiveFocus() : null
    }

    MpvObject {
        id: audio
        useHwdec: true
        enableAudio: true
        // embeded mpv allows to set commandline propertys using the options/<name>
        // syntax. This could be abstracted later, but for now this works.
        Component.onCompleted: audio.setProperty("options/audio-display", "no");
    }

    function pauseVideo() {
        previewSlide.pauseVideo();
    }

    function loadVideo() {
        /* showPassiveNotification("Loading Video " + vidbackground) */
        previewSlide.loadVideo();
    }

    function loopVideo() {
        previewSlide.loopVideo();
    }

    function stopVideo() {
        /* showPassiveNotification("Stopping Video") */
        previewSlide.stopVideo()
    }

    function nextSlideAction() {
        keyHandler.forceActiveFocus();
        console.log(currentServiceItem);
        const nextSlideIdx = currentSlide + 1;
        if (nextSlideIdx > totalSlides || nextSlideIdx < 0)
            return;
        console.log("currentServiceItem " + currentServiceItem);
        console.log("currentSlide " + currentSlide);
        console.log("nextSlideIdx " + nextSlideIdx);
        changeSlide(nextSlideIdx);
    }

    function nextSlide() {
        changeServiceItem(currentServiceItem++);
        console.log(slideItem);
    }

    function previousSlideAction() {
        keyHandler.forceActiveFocus();
        const prevSlideIdx = currentSlide - 1;
        if (prevSlideIdx > totalSlides || prevSlideIdx < 0)
            return;
        console.log("currentServiceItem " + currentServiceItem);
        console.log("currentSlide " + currentSlide);
        console.log("prevSlideIdx " + prevSlideIdx);
        changeSlide(prevSlideIdx);
    }

    function previousSlide() {
        changeServiceItem(--currentServiceItem);
        console.log(slideItem);
    }

    function clearText() {
        SlideObject.setText("");
    }

    function playAudio() {
    }

}
