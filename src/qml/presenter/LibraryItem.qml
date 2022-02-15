import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

Column {
    id: root

    property string title: ""
    required property var model
    property bool open

    Rectangle {
        id: panel
        implicitHeight: 40
        implicitWidth: parent.width
        color: Kirigami.Theme.backgroundColor

        Controls.Label {
            id: titleLabel
            anchors.centerIn: parent
            text: title
        }

        Controls.Label {
            text: "^"
            font.pointSize: 24
            anchors.right: parent.right
            anchors.margins: 15
            anchors.baseline: open ? titleLabel.bottom : parent.bottom
            rotation: open ? 180 : 0

            Behavior on rotation {
                NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: open = !open
        }
    }

    ListView {
        id: libraryList

        model: _songListModel
        delegate: libraryDelegate
        clip: true
        implicitWidth: parent.width
        height: {
            if (open)
                parent.height - panel.height
            else
                0
        }
        y: panel.height

        Behavior on height {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
        }

        Kirigami.WheelHandler {
            id: wheelHandler
            target: libraryList
            filterMouseEvents: true
            keyNavigationEnabled: true
        }

        Controls.ScrollBar.vertical: Controls.ScrollBar {
            anchors.right: libraryList.right
            anchors.leftMargin: 10
            active: hovered || pressed
        }
    }


    Component {
        id: libraryDelegate
        Kirigami.BasicListItem {
            width: ListView.view.width
            height:40
            label: title
            subtitle: author
            hoverEnabled: true
            onClicked: {
                ListView.view.currentIndex = index
                songTitle = title
                songLyrics = lyrics
                songAuthor = author
                showPassiveNotification(songLyrics, 3000)
            }
        }
    }

}
