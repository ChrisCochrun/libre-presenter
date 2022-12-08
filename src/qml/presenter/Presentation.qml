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
                }
                Controls.ToolButton {
                    text: "Grid"
                    icon.name: "view-app-grid-symbolic"
                    hoverEnabled: true
                    onClicked: myObject.sayHi(myObject.string, myObject.number);
                }
                Controls.ToolButton {
                    text: "Details"
                    icon.name: "view-list-details"
                    hoverEnabled: true
                    onClicked: showPassiveNotification(myObject.string);
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
                implicitWidth: 100
                implicitHeight: 200
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
                implicitWidth: 700
                implicitHeight: width / 16 * 9
                /* minimumWidth: 300 */
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
                implicitWidth: 100
                implicitHeight: 200
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
                Kirigami.Icon {
                    source: previewSlide.mpvIsPlaying ? "media-pause" : "media-play"
                    Layout.preferredWidth: 25
                    Layout.preferredHeight: 25
                    MouseArea {
                        anchors.fill: parent
                        onPressed: SlideObject.playPause();
                        cursorShape: Qt.PointingHandCursor
                    }
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
        id: previewSlidesList
        /* Layout.fillHeight: true */
        /* Layout.fillWidth: true */
        /* Layout.columnSpan: 3 */
        /* Layout.alignment: Qt.AlignBottom */
        /* Layout.bottomMargin: 140 */
        anchors.top: mainGrid.bottom
        anchors.bottom: root.bottom
        /* anchors.bottomMargin: 100 */
        width: parent.width
        orientation: ListView.Horizontal
        cacheBuffer: 900
        reuseItems: true

        model: serviceItemModel
        delegate: Rectangle {
            id: previewHighlight
            implicitWidth: 210
            implicitHeight: width / 16 * 9
            color: {
                if (active || previewerMouse.containsMouse)
                    Kirigami.Theme.highlightColor
                else
                    Kirigami.Theme.backgroundColor
            }

            Presenter.Slide {
                id: previewSlideItem
                anchors.centerIn: parent
                implicitWidth: 200
                implicitHeight: width / 16 * 9
                textSize: width / 4
                itemType: type
                imageSource: backgroundType === "image" ? background : ""
                videoSource: backgroundType === "video" ? background : ""
                audioSource: ""
                chosenFont: font
                text: model.text[0] === "This is demo text" ? "" : model.text[0]
                pdfIndex: 0
                preview: true 
                editMode: true 

            }

            Controls.Label {
                id: slidesTitle
                width: previewSlideItem.width
                anchors.top: previewSlideItem.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 5
                elide: Text.ElideRight
                text: name
                /* font.family: "Quicksand Bold" */
            }

            MouseArea {
                id: previewerMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: changeServiceItem(index)
                cursorShape: Qt.PointingHandCursor
            }


            Connections {
                target: serviceItemModel
                onDataChanged: if (active)
                    previewSlidesList.positionViewAtIndex(index, ListView.Center)
            }
        }
        Kirigami.WheelHandler {
            id: wheelHandler
            target: previewSlidesList
            filterMouseEvents: true
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
        print(currentServiceItem);
        const nextServiceItemIndex = currentServiceItem + 1;
        const nextItem = serviceItemModel.getItem(nextServiceItemIndex);
        print("currentServiceItem " + currentServiceItem);
        print("nextServiceItem " + nextServiceItemIndex);
        print(nextItem.name);
        const change = SlideObject.next(nextItem);
        print(change);
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
        print(slideItem);
    }

    function previousSlideAction() {
        keyHandler.forceActiveFocus();
        const prevServiceItemIndex = currentServiceItem - 1;
        const prevItem = serviceItemModel.getItem(prevServiceItemIndex);
        print("currentServiceItem " + currentServiceItem);
        print("prevServiceItem " + prevServiceItemIndex);
        print(prevItem.name);
        const change = SlideObject.previous(prevItem);
        print(change);
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
        print(slideItem);
    }

    function changeSlide() {
        if (itemType === "song") {
            SlideObject.setText(root.text[textIndex]);
            print(root.text[textIndex]);
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
