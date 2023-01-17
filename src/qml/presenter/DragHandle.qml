import QtQuick 2.13
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami

Item {
    id: root

    /**
     * listItem: Item
     * The id of the delegate that we want to drag around, which *must*
     * be a child of the actual ListView's delegate
     */
    property Item listItem

    /**
     * listView: Listview
     * The id of the ListView the delegates belong to.
     */
    property ListView listView
    property bool containsMouse

    /**
     * Emitted when the drag handle wants to move the item in the model
     * The following example does the move in the case a ListModel is used
     * @code
     *  onMoveRequested: listModel.move(oldIndex, newIndex, 1)
     * @endcode
     * @param oldIndex the index the item is currently at
     * @param newIndex the index we want to move the item to
     */
    signal moveRequested(int oldIndex, int newIndex)

    /**
     * Emitted when the drag operation is complete and the item has been
     * dropped in the new final position
     */
    signal dropped()

    // Emitted when clicking to activate underneath mousearea
    signal clicked()
    signal rightClicked()

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag {
            target: listItem
            axis: Drag.YAxis
            minimumY: 0
            maximumY: listView.height - listItem.height
            filterChildren: true
        }
        /* cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor */

        property int startY
        property int mouseDownY
        property Item originalParent
        property int autoScrollThreshold: (listView.contentHeight > listView.height) ? listItem.height * 3 : 0

        function arrangeItem() {
            var newIndex = listView.indexAt(1,
                                            listView.contentItem.mapFromItem(listItem, 0, 0).y +
                                            mouseArea.mouseDownY);

            if (Math.abs(listItem.y - mouseArea.startY) > height && newIndex > -1 &&
                newIndex !== index) {
                console.log("old index is: " + index + " and new index is: " + newIndex);
                root.moveRequested(index, newIndex);
            }
        }

        preventStealing: false
        onPressed: {
            listView.interactive = false;
            mouseArea.originalParent = listItem.parent;
            listItem.parent = listView;
            listItem.y = mouseArea.originalParent.mapToItem(listItem.parent, listItem.x, listItem.y).y;
            mouseArea.originalParent.z = 99;
            mouseArea.startY = listItem.y;
            mouseArea.mouseDownY = mouse.y;
        }

        onPositionChanged: {
            if (!pressed) {
                return;
            }
            mouseArea.arrangeItem();

            scrollTimer.interval = 500 * Math.max(0.1, (1-Math.max(mouseArea.autoScrollThreshold - listItem.y, listItem.y - listView.height + mouseArea.autoScrollThreshold + listItem.height) / mouseArea.autoScrollThreshold));
            scrollTimer.running = (listItem.y < mouseArea.autoScrollThreshold ||
                                   listItem.y > listView.height - mouseArea.autoScrollThreshold);
        }
        onReleased: {
            listView.interactive = true;
            listItem.y = mouseArea.originalParent.mapFromItem(listItem, 0, 0).y;
            listItem.parent = mouseArea.originalParent;
            dropAnimation.running = true;
            scrollTimer.running = false;
            root.dropped();
        }
        onCanceled: released()
        SequentialAnimation {
            id: dropAnimation
            YAnimator {
                target: listItem
                from: listItem.y
                to: 0
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
            PropertyAction {
                target: listItem.parent
                property: "z"
                value: 0
            }
        }
        Timer {
            id: scrollTimer
            interval: 500
            repeat: true
            onTriggered: {
                if (listItem.y < mouseArea.autoScrollThreshold) {
                    listView.contentY = Math.max(0, listView.contentY - Kirigami.Units.gridUnit)
                } else {
                    listView.contentY = Math.min(listView.contentHeight - listView.height, listView.contentY + Kirigami.Units.gridUnit)
                }
                mouseArea.arrangeItem();
            }
        }

        MouseArea {
            id: clickArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onEntered: root.containsMouse = true
            onExited: root.containsMouse = false
            onClicked: {
                if (mouse.button === Qt.RightButton)
                    root.rightClicked();
                else
                    root.clicked();
            }
        }
    }
}
