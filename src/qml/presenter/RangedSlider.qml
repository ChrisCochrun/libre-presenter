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
    property real firstVisualPosition
    property real secondVisualPosition

    signal firstReleased()
    signal secondReleased()

    Kirigami.Theme.colorSet: Kirigami.Theme.Button

    color: Kirigami.Theme.backgroundColor
    border.width: 0
    radius: width / 2

    height: 6

    Rectangle {
        id: first
        x: firstVisualPosition
        y: -6
        implicitWidth: 18
        implicitHeight: 18
        color: firstMouse.containsMouse ? Kirigami.Theme.hoverColor : Kirigami.Theme.alternateBackgroundColor
        border.width: firstMouse.containsMouse ? 2 : 1
        border.color: firstMouse.containsMouse ? Kirigami.Theme.hoverColor : Kirigami.Theme.backgroundColor
        radius: width / 2

        Drag.active: firstMouse.drag.active
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2

        /* states: State { */
        /*     name: "dragged" */
        /*     when: first.Drag.active */
        /*     PropertyChanges { */
        /*         target: first */
        /*         x: x */
        /*         width: width */
        /*         height: height */
        /*     } */
        /* } */
        MouseArea {
            id: firstMouse
            anchors.fill: parent
            hoverEnabled: true
            drag {
                target: first
                axis: Drag.XAxis
                maximumX: root.right
                minimumX: root.left
            }
            onReleased: {
                firstValue = mouseX;
                firstReleased();
            }
        }
    }

    Rectangle {
        id: second
        x: secondVisualPosition
        y: -6
        implicitWidth: 18
        implicitHeight: 18
        color: secondMouse.containsMouse ? Kirigami.Theme.hoverColor : Kirigami.Theme.alternateBackgroundColor
        border.width: secondMouse.containsMouse ? 2 : 1
        border.color: secondMouse.containsMouse ? Kirigami.Theme.hoverColor : Kirigami.Theme.backgroundColor
        radius: width / 2

        Drag.active: secondMouse.drag.active
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2

        /* states: State { */
        /*     name: "dragged" */
        /*     when: second.Drag.active */
        /*     PropertyChanges { */
        /*         target: second */
        /*         x: x */
        /*         width: width */
        /*         height: height */
        /*     } */
        /* } */
        MouseArea {
            id: secondMouse
            anchors.fill: parent
            hoverEnabled: true
            drag {
                target: second
                axis: Drag.XAxis
                maximumX: root.width
                minimumX: 0
            }
            onReleased: {
                secondValue = second.x;
                secondReleased();
            }
        }
    }

    Rectangle {
        id: range
        color: Kirigami.Theme.hoverColor
        radius: width / 2
    }
}
