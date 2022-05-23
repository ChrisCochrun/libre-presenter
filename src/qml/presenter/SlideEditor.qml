import QtQuick 2.15
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import QtMultimedia 5.15
/* import QtAudioEngine 1.15 */
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

Item {
    id: root

    property string imageBackground
    property string videoBackground
    property var hTextAlignment
    property var vTextAlignment
    property string font
    property real fontSize

    property ListModel songs: songModel

    ListView {
        id: slideList
        anchors.fill: parent
        model: songModel
        clip: true
        cacheBuffer: 900
        reuseItems: true
        spacing: Kirigami.Units.gridUnit
        flickDeceleration: 4000
        /* boundsMovement: Flickable.StopAtBounds */
        synchronousDrag: true
        delegate: Presenter.Slide {
            id: representation
            editMode: true
            imageSource: root.imageBackground
            videoSource: root.videoBackground
            hTextAlignment: root.hTextAlignment
            vTextAlignment: root.vTextAlignment
            chosenFont: root.font
            textSize: root.fontSize
            preview: true
            text: verse
            implicitWidth: slideList.width
            implicitHeight: width * 9 / 16
        }

    }

    Component.onCompleted: {
    }

    ListModel {
        id: songModel
    }

    function appendVerse(verse) {
        print(verse);
        songModel.append({"verse": verse})
    }

    /* function loadVideo() { */
    /*     representation.loadVideo(); */
    /* } */

    function updateHAlignment(alignment) {
        switch (alignment) {
        case "left" :
            root.hTextAlignment = Text.AlignLeft;
            break;
        case "center" :
            root.hTextAlignment = Text.AlignHCenter;
            break;
        case "right" :
            root.hTextAlignment = Text.AlignRight;
            break;
        case "justify" :
            root.hTextAlignment = Text.AlignJustify;
            break;
        }
    }

    function updateVAlignment(alignment) {
        switch (alignment) {
        case "top" :
            root.vTextAlignment = Text.AlignTop;
            break;
        case "center" :
            root.vTextAlignment = Text.AlignVCenter;
            break;
        case "bottom" :
            root.vTextAlignment = Text.AlignBottom;
            break;
        }
    }

}
