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
    anchors.fill: parent

    // Let's make this slide editable
    property bool editMode: false

    // These properties are for the slides visuals
    property real textSize: 72
    property bool dropShadow: false
    property url imageSource: imageBackground
    property url videoSource: videoBackground
    property string chosenFont: "Quicksand"
    property color backgroundColor

    // These properties help to determine the state of the slide
    property string itemType

    Rectangle {
        id: basePrColor
        anchors.fill: parent
        color: "black"

        MpvObject {
            id: mpv
	    objectName: "mpv"
            anchors.fill: parent
            useHwdec: true
            Component.onCompleted: mpvLoadingTimer.start()
            onFileLoaded: {
                print(videoSource + " has been loaded");
                mpv.setProperty("loop", "inf");
                print(mpv.getProperty("loop"));
            }

            MouseArea {
                id: playArea
                anchors.fill: parent
                enabled: editMode
                onPressed: mpv.loadFile(videoSource.toString());
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
            interval: 100
            onTriggered: mpv.loadFile(videoSource.toString())
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
            source: imageSource == "" ? mpv : backgroundImage
            radius: blurRadius

            Controls.Label {
                id: lyrics
                text: "This is some test lyrics" // change to song lyrics of current verse
                font.pointSize: textSize
                minimumPointSize: 5
                fontSizeMode: Text.Fit
                font.family: chosenFont
                style: Text.Raised
                anchors.centerIn: parent
                /* width: parent.width */
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
}
