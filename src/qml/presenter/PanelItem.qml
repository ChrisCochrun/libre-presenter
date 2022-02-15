import QtQuick 2.7
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami

Item {
    id: root
    default property var contentItem: null
    property string title: "panel"
    property bool current: false
    Layout.fillWidth: true
    height: 30
    Layout.fillHeight: current
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        Rectangle {
            id: bar
            Layout.fillWidth: true
            height: 40
            color:  root.current ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor
            Controls.Label {
                anchors.fill: parent
                anchors.margins: 10
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                text: root.title
             }
            Controls.Label {
                anchors{
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                    margins: 10
                }
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: "^"
                rotation: root.current ? "180" : 0
                Behavior on rotation {
                    PropertyAnimation { duration: 100 }
                }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.current = !root.current;
                    if(root.parent.currentItem !== null)
                        root.parent.currentItem.current = false;

                    root.parent.currentItem = root;
                }
            }
        }
        Rectangle {
            id: container
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: bar.height / 4
            implicitHeight: root.height - bar.height
            color: Kirigami.Theme.backgroundColor
            clip: true
            Behavior on implicitHeight {
                PropertyAnimation { duration: 100 }
            }
        }
        Component.onCompleted: {
            if(root.contentItem !== null)
                root.contentItem.parent = container;
        }
    }
}
