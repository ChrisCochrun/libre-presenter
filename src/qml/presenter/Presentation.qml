import QtQuick 2.15
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
/* import QtAudioEngine 1.15 */
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0

FocusScope {
    id: root

    height: parent.height

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
        anchors.bottomMargin: 160
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
                    onClicked: serviceThing.slapVariantAround(imagesqlmodel.getImage(1).title);
                }
                Controls.ToolButton {
                    text: "Grid"
                    icon.name: "view-app-grid-symbolic"
                    hoverEnabled: true
                    onClicked: serviceThing.checkActive();
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
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            /* Layout.columnSpan: 3 */
            Layout.alignment: Qt.AlignTop

            Kirigami.Icon {
                source: "arrow-left"
                implicitWidth: Kirigami.Units.gridUnit * 7
                implicitHeight: Kirigami.Units.gridUnit * 10
                anchors.right: previewSlide.left
                anchors.verticalCenter: parent.verticalCenter
                /* Layout.alignment: Qt.AlignRight */
                MouseArea {
                    anchors.fill: parent
                    onPressed: previousSlideAction()
                    cursorShape: Qt.PointingHandCursor
                }
            }

            Presenter.Slide {
                id: previewSlide
                implicitWidth: root.width - 400 
                implicitHeight: width / 16 * 9
                /* minimumWidth: 200 */
                anchors.centerIn: parent
                textSize: width / 15
                itemType: root.itemType
                imageSource: imagebackground
                videoSource: vidbackground
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
                /* Layout.alignment: Qt.AlignLeft */
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

        /* Item { */
        /*     Layout.fillHeight: true */
        /*     Layout.fillWidth: true */
        /*     Layout.columnSpan: 3 */
        /* } */

        Item {
            Layout.preferredHeight: 60
            Layout.fillWidth: true
            /* Layout.columnSpan: 3 */
            Layout.alignment: Qt.AlignTop
        }

    }

    ListView {
        // The active items X value from root
        property int activeX
        id: previewSlidesList
        anchors.top: mainGrid.bottom
        anchors.bottom: root.bottom - Kirigami.Units.gridUnit
        width: parent.width
        orientation: ListView.Horizontal
        spacing: Kirigami.Units.smallSpacing * 2
        cacheBuffer: 900
        reuseItems: true
        model: serviceItemModel
        delegate: Presenter.PreviewSlideListDelegate {}

        Kirigami.WheelHandler {
            id: wheelHandler
            target: previewSlidesList
            filterMouseEvents: true
            onWheel: {
                wheel.accepted = true;
                showPassiveNotification(wheel.inverted)
            }
        }
    }

    Rectangle {
        id: activeHighlightBar
        width: Kirigami.Units.gridUnit * 10
        height: Kirigami.Units.gridUnit / 4
        y: previewSlidesList.y + Kirigami.Units.gridUnit * 6
        x: {
            let slideX = SlideObject.slideIndex === 0 ? previewSlidesList.currentItem.width : (SlideObject.slideIndex - 1) * previewSlidesList.currentItem.width
            previewSlidesList.currentItem.x + Kirigami.Units.smallSpacing
        }
        radius: 5
        color: Kirigami.Theme.negativeTextColor

        Behavior on x { PropertyAnimation {
            properties: "x"
            easing.type: Easing.InOutElastic;
            easing.period: 1.5
            duration: 150
        }}
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
        const nextServiceItemIndex = currentServiceItem + 1;
        const nextItem = serviceItemModel.getItem(nextServiceItemIndex);
        console.log("currentServiceItem " + currentServiceItem);
        console.log("nextServiceItem " + nextServiceItemIndex);
        console.log(nextItem.name);
        const change = SlideObject.next(nextItem);
        console.log(change);
        if (currentServiceItem === totalServiceItems - 1 & change)
            return;
        if (change) {
            SlideObject.changeSlide(nextItem);
            currentServiceItem++;
            changeServiceItem(currentServiceItem);
            leftDock.changeItem();
        }
    }

    function nextSlide() {
        changeServiceItem(currentServiceItem++);
        console.log(slideItem);
    }

    function previousSlideAction() {
        keyHandler.forceActiveFocus();
        const prevServiceItemIndex = currentServiceItem - 1;
        const prevItem = serviceItemModel.getItem(prevServiceItemIndex);
        console.log("currentServiceItem " + currentServiceItem);
        console.log("prevServiceItem " + prevServiceItemIndex);
        console.log(prevItem.name);
        const change = SlideObject.previous(prevItem);
        console.log(change);
        if (currentServiceItem === 0 & change) {
            return;
        };
        if (change) {
            SlideObject.changeSlide(prevItem);
            currentServiceItem--;
            changeServiceItem(currentServiceItem);
            leftDock.changeItem();
        }
    }

    function previousSlide() {
        changeServiceItem(--currentServiceItem);
        console.log(slideItem);
    }

    function changeSlide() {
        if (itemType === "song") {
            SlideObject.setText(root.text[textIndex]);
            console.log(root.text[textIndex]);
            textIndex++;
        } else if (itemType === "video") {
            clearText();
        }
        else if (itemType === "image") {
            clearText();
        }
    }

    function clearText() {
        SlideObject.setText("");
    }
}
