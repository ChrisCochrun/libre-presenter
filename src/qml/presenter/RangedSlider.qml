import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.13 as Kirigami

Rectangle {
    id: root

    property var first
    property var second

    property real from
    property real to

    property real firstValue
    property real secondValue
    property real firstInitialValue
    property real secondInitialValue
    property real firstVisualPosition: firstInitialValue
    property real secondVisualPosition: secondInitialValue

    signal firstReleased()
    signal secondReleased()
    signal firstMoved()
    signal secondMoved()

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    color: Kirigami.Theme.backgroundColor
    border.width: 0
    radius: width / 2

    height: 6

    MouseArea {
        id: trayMouse
        anchors.fill: parent
        onClicked: {
            let mouseEnd = mouseX > second.x;
            let mouseBegin = mouseX < first.x;
            if (mouseBegin) {
                first.x = mouseX - first.width / 2
                firstMove();
                firstDrop();
            } else if (mouseEnd) {
                second.x = mouseX - second.width / 2
                secondMove();
                secondDrop();
            } else {
                if (mouseX - first.x > second.x - mouseX) {
                    second.x = mouseX - second.width / 2
                    secondMove();
                    secondDrop();
                } else {
                    first.x = mouseX - first.width / 2
                    firstMove();
                    firstDrop();
                }
            }
        }
    }

    Rectangle {
        id: range
        color: Kirigami.Theme.hoverColor
        height: root.height
        radius: width / 2
        border.width: 0
        anchors.right: second.right
        anchors.left: first.left
    }

    Rectangle {
        id: first
        x: firstInitialValue / (to - from) * (root.width - width)
        y: -6
        implicitWidth: 18
        implicitHeight: 18
        color: firstMouse.containsMouse || firstMouse.drag.active ? Kirigami.Theme.hoverColor : Kirigami.Theme.alternateBackgroundColor
        border.width: firstMouse.containsMouse || firstMouse.drag.active ? 2 : 1
        border.color: firstMouse.containsMouse || firstMouse.drag.active ? Kirigami.Theme.hoverColor : Kirigami.Theme.backgroundColor
        radius: width / 2

        Drag.active: firstMouse.drag.active
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2

        MouseArea {
            id: firstMouse
            anchors.fill: parent
            hoverEnabled: true
            drag {
                target: first
                axis: Drag.XAxis
                maximumX: Math.min((root.width - first.width / 2), second.x)
                minimumX: 0 + first.width / 2
            }
            onReleased: firstDrop()
            onPositionChanged: if (drag.active) firstMove()
        }
    }

    Rectangle {
        id: second
        x: secondInitialValue / (to - from) * (root.width - width)
        y: -6
        implicitWidth: 18
        implicitHeight: 18
        color: secondMouse.containsMouse || secondMouse.drag.active ? Kirigami.Theme.hoverColor : Kirigami.Theme.alternateBackgroundColor
        border.width: secondMouse.containsMouse || secondMouse.drag.active ? 2 : 1
        border.color: secondMouse.containsMouse || secondMouse.drag.active ? Kirigami.Theme.hoverColor : Kirigami.Theme.backgroundColor
        radius: width / 2

        Drag.active: secondMouse.drag.active
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2

        MouseArea {
            id: secondMouse
            anchors.fill: parent
            hoverEnabled: true
            drag {
                target: second
                axis: Drag.XAxis
                maximumX: root.width - second.width / 2
                minimumX: Math.max((0 + second.width / 2), first.x)
            }
            onReleased: secondDrop()
            onPositionChanged: if (drag.active) secondMove()
        }
    }

    function firstMove() {
        firstVisualPosition = (to - from) / (root.width - first.width) * (first.x - first.width / 2) + from;
        firstMoved()
    }

    function secondMove() {
        secondVisualPosition = (to - from) / (root.width - second.width) * (second.x - second.width / 2) + from;
        secondMoved()
    }

    function firstDrop() {
        firstValue = (to - from) / (root.width - first.width) * (first.x - first.width / 2) + from;
        firstVisualPosition = firstValue;
        firstReleased();
    }

    function secondDrop() {
        secondValue = (to - from) / (root.width - second.width) * (second.x - second.width / 2) + from;
        secondVisualPosition = secondValue;
        secondReleased();
    }
}
