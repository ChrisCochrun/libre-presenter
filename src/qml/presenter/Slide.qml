import QtQuick 2.13
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
/* import QtMultimedia 5.15 */
/* import QtAudioEngine 1.15 */
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
    property url imageSource
    property url videoSource
    property string chosenFont: "Quicksand"
    property string text: "This is demo text"
    property color backgroundColor
    property var hTextAlignment: Text.AlignHCenter
    property var vTextAlignment: Text.AlignVCenter

    //these properties are for giving video info to parents
    property int mpvPosition: mpv.position
    property int mpvDuration: mpv.duration
    property var mpvLoop: mpv.getProperty("loop")
    property bool mpvIsPlaying: mpv.isPlaying

    // These properties help to determine the state of the slide
    property string itemType
    property bool preview: false

    implicitWidth: 1920
    implicitHeight: 1080

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
                /* showPassiveNotification(videoSource + " has been loaded"); */
                if (itemType == "song")
                    mpv.setProperty("loop", "inf");
                else
                    mpv.setProperty("loop", "no");
                /* showPassiveNotification(mpv.getProperty("loop")); */
            }

            MouseArea {
                id: playArea
                anchors.fill: parent
                enabled: editMode
                onPressed: mpv.playPause();
                cursorShape: preview ? Qt.ArrowCursor : Qt.BlankCursor
            }

            Controls.ProgressBar {
                anchors.top: parent.bottom
                visible: editMode
                width: parent.width - 400
                value: mpv.position
                to: mpv.duration
            }
        }

        Timer {
            id: mpvLoadingTimer
            interval: 100
            onTriggered: {
                /* showPassiveNotification("YIPPEEE!") */
                mpv.loadFile(videoSource.toString());
                if (editMode) {
                    print("WHY AREN'T YOU PASUING!");
                    pauseTimer.restart();
                }
                blackTimer.restart();
            }
        }

        Timer {
            id: pauseTimer
            interval: 200
            onTriggered: mpv.pause()
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
                horizontalAlignment: hTextAlignment
                verticalAlignment: vTextAlignment
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

    function pauseVideo() {
        mpv.pause();
    }
}
