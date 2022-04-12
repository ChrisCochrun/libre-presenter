import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import QtMultimedia 5.15
import QtAudioEngine 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

Item {
    id: root

    property string imageBackground
    property string videoBackground
    property var hTextAlignment
    property var vTextAlignment

    Presenter.Slide {
        id: representation
        anchors.fill: parent
        textSize: width / 15
        editMode: true
        imageSource: imageBackground
        videoSource: videoBackground
        horizontalAlignment: hTextAlignment
        verticalAlignment: vTextAlignment
        preview: true
    }

    Component.onCompleted: {
    }

    function loadVideo() {
        representation.loadVideo();
        representation.pauseVideo();
    }

    function updateHAlignment(alignment) {
        switch (alignment) {
        case "left" :
            representation.horizontalAlignment = Text.AlignLeft;
            break;
        case "center" :
            representation.horizontalAlignment = Text.AlignHCenter;
            break;
        case "right" :
            representation.horizontalAlignment = Text.AlignRight;
            break;
        case "justify" :
            representation.horizontalAlignment = Text.AlignJustify;
            break;
        }
    }

    function updateVAlignment(alignment) {
        switch (alignment) {
        case "top" :
            representation.verticalAlignment = Text.AlignBottom;
            break;
        case "center" :
            representation.verticalAlignment = Text.AlignVCenter;
            break;
        case "bottom" :
            representation.verticalAlignment = Text.AlignBottom;
            break;
        }
    }
}
