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

    Presenter.Slide {
        id: representation
        anchors.fill: parent
        textSize: width / 15
        editMode: true
        imageSource: imageBackground
        videoSource: videoBackground
        preview: true
    }
}
