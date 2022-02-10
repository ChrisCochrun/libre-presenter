import QtQuick 2.13
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import QtMultimedia 5.15
import QtAudioEngine 1.15
import QtGraphicalEffects 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

Item {
    id: root
    anchors.fill: parent

    property real textSize: 50
    property bool dropShadow: false
    property url imageSource: ""
    property url videoSource: ""
    property string chosenFont: "Quicksand"

    Rectangle {
        id: basePrColor
        anchors.fill: parent
        color: "black"

        MediaPlayer {
            id: videoPlayer
            source: videoSource
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

        Image {
            id: backgroundImage
            anchors.fill: parent
            source: imageSource
            fillMode: Image.PreserveAspectCrop
            clip: true

            Controls.Label {
                id: lyrics
                text: "This is some test lyrics" // change to song lyrics of current verse
                font.pointSize: textSize
                font.family: chosenFont
                style: Text.Raised
                anchors.centerIn: parent
            }

            DropShadow {
                id: textDropShadow
                source: lyrics
                anchors.fill: lyrics
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 17
                color: "#80000000"
                visible: true
            }
        }
    }
}
