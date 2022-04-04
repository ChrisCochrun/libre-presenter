import QtQuick 2.13
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
/* import QtMultimedia 5.15 */
import QtAudioEngine 1.15
import QtGraphicalEffects 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import mpv 1.0

Item {
    id: root

    // Let's make this slide editable
    property bool editMode: false

    // These properties are for the slides visuals
    property real textSize: 50
    property bool dropShadow: false
    property url imageSource: imageBackground
    property url videoSource: videoBackground
    property string chosenFont: "Quicksand"
    property var text: "This is demo text"
    property color backgroundColor
    property var horizontalAlignment
    property var verticalAlignment

    //these properties are for giving video info to parents
    property int mpvPosition: mpv.position
    property int mpvDuration: mpv.duration
    property var mpvLoop: mpv.getProperty("loop")

    // These properties help to determine the state of the slide
    property string itemType
    property bool preview: false

    Rectangle {
        id: basePrColor
        anchors.fill: parent
        color: "black"

        MpvObject {
            id: mpv
	    objectName: "mpv"
            anchors.fill: parent
            useHwdec: true
            enableAudio: !preview
            Component.onCompleted: mpvLoadingTimer.start()
            onFileLoaded: {
                showPassiveNotification(videoSource + " has been loaded");
                if (itemType == "song")
                    mpv.setProperty("loop", "inf");
                showPassiveNotification(mpv.getProperty("loop"));
            }

            MouseArea {
                id: playArea
                anchors.fill: parent
                enabled: editMode
                onPressed: mpv.loadFile(videoSource.toString());
                cursorShape: preview ? Qt.ArrowCursor : Qt.BlankCursor
            }

            Controls.ProgressBar {
                anchors.centerIn: parent
                visible: editMode
                width: parent.width - 400
                value: mpv.position
                to: mpv.duration
            }
        }

        Timer {
            id: mpvLoadingTimer
            interval: 2
            onTriggered: {
                mpv.loadFile(videoSource.toString());
                blackTimer.restart();
            }
        }

        Timer {
            id: blackTimer
            interval: 400
            onTriggered: {
                black.visible = false;
            }
        }

        Rectangle {
            id: black
            color: "Black"
            anchors.fill: parent
            visible: false
        }

        Image {
            id: backgroundImage
            anchors.fill: parent
            source: imageSource
            fillMode: Image.PreserveAspectCrop
            clip: true
            visible: true

        }

        FastBlur {
            id: imageBlue
            anchors.fill: parent
            source: imageSource === "" ? mpv : backgroundImage
            radius: blurRadius

            Controls.Label {
                id: lyrics
                text: root.text
                font.pixelSize: textSize
                /* minimumPointSize: 5 */
                fontSizeMode: Text.Fit
                font.family: chosenFont
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                style: Text.Raised
                anchors.fill: parent
                clip: true

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 5
                    verticalOffset: 5
                    radius: 11.0
                    samples: 24
                    color: "#80000000"
                }
            }
        }
    }

    function changeText(text) {
        lyrics.text = text
    }

    function loadVideo() {
        mpvLoadingTimer.restart()
    }

    function stopVideo() {
        mpv.stop();
        black.visible = true;
        showPassiveNotification("Black is: " + black.visible);
    }
}
