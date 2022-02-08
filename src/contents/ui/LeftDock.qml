import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.0 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import QtMultimedia 5.15
import QtAudioEngine 1.15
import org.kde.kirigami 2.13 as Kirigami

Item {
    id: root

    Rectangle {
        id: rootBG

        TextInput {
            id: serviceNameInput
            anchors.left: parent.left
            anchors.right: parent.right

        }

        Controls.Label {
            id: detailsLabel
            anchors.top: serviceNameInput.bottom
            anchors.topMargin: 20
        }

        ListView {
            id: serviceList
        }

    }

}
