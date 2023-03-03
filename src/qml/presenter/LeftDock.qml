import QtQuick 2.13
/* import QtQuick.Dialogs 1.0 */
import QtQuick.Controls 2.0 as Controls
/* import QtQuick.Window 2.15 */
import QtQuick.Layouts 1.15
/* import QtQuick.Shapes 1.15 */
import QtQml.Models 2.12
/* import QtMultimedia 5.15 */
/* import QtAudioEngine 1.15 */
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0

ColumnLayout {
    id: root

    property var selectedItem: serviceItemList.selected
    property var hlItem 

    Rectangle {
        id: headerBackground
        color: Kirigami.Theme.backgroundColor
        height: 40
        opacity: 1.0
        Layout.fillWidth: true

        Kirigami.Heading {
            id: serviceTitle
            text: "Service List"
            anchors.centerIn: headerBackground 
            padding: 5
            level: 3
        }
    }

    DropArea {
        id: serviceDropEnd
        Layout.fillHeight: true
        Layout.fillWidth: true
        onDropped: (drag) => {
            console.log("DROPPED AT END");
            appendItem(dragItemTitle,
                       dragItemType,
                       dragItemBackground,
                       dragItemBackgroundType,
                       dragItemText,
                       dragItemIndex);
            dropHighlightLine.visible = false;
        }

        keys: ["library"]

        onEntered: (drag) => {
            if (drag.keys[0] === "library") {
                dropHighlightLine.visible = true;
                var lastItem = serviceItemList.itemAtIndex(ServiceItemModel.rowCount() - 1);
                dropHighlightLine.y = lastItem.y + lastItem.height;
            }
        }

        /* onExited: dropHighlightLine.visible = false; */

        ListView {
            id: serviceItemList
            anchors.fill: parent
            /* model: ServiceItemModel */
            /* delegate: Kirigami.DelegateRecycler { */
            /*     width: serviceItemList.width */
            /*     sourceComponent: itemDelegate */
            /* } */
            clip: true
            spacing: 3
            property int indexDragged
            property int moveToIndex
            property int draggedY

            addDisplaced: Transition {
                NumberAnimation {properties: "x, y"; duration: 100}
            }
            moveDisplaced: Transition {
                NumberAnimation { properties: "x, y"; duration: 100 }
            }
            remove: Transition {
                NumberAnimation { properties: "x, y"; duration: 100 }
                NumberAnimation { properties: "opacity"; duration: 100 }
            }

            removeDisplaced: Transition {
                NumberAnimation { properties: "x, y"; duration: 100 }
            }

            displaced: Transition {
                NumberAnimation {properties: "x, y"; duration: 100}
            }

            model: DelegateModel {
                id: visualModel
                model: ServiceItemModel

                delegate: DropArea {
                    id: serviceDrop
                    implicitWidth: serviceItemList.width
                    height: 50
                    /* enabled: false */

                    onEntered: (drag) => {
                        if (drag.keys[0] === "library") {
                            dropHighlightLine.visible = true;
                            dropHighlightLine.y = y - 2;
                        }
                    }

                    /* onExited: dropHighlightLine.visible = false; */

                    onDropped: (drag) => {
                        console.log("DROPPED IN ITEM AREA: " + drag.keys);
                        console.log(dragItemIndex + " " + index);
                        const hlIndex = serviceItemList.currentIndex;
                        if (drag.keys[0] === "library") {
                            addItem(index,
                                    dragItemTitle,
                                    dragItemType,
                                    dragItemBackground,
                                    dragItemBackgroundType,
                                    dragItemText,
                                    dragItemIndex);
                        } else if (drag.keys[0] === "serviceitem") {
                            ServiceItemModel.move(serviceItemList.indexDragged,
                                                  serviceItemList.moveToIndex);
                            serviceItemList.currentIndex = moveToIndex;
                        }
                        dropHighlightLine.visible = false;
                    }

                    keys: ["library","serviceitem"]

                    Kirigami.BasicListItem {
                        id: visServiceItem
                        width: serviceDrop.width
                        height: serviceDrop.height
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }
                        label: name
                        subtitle: type
                        hoverEnabled: false
                        supportsMouseEvents: false
                        backgroundColor: {
                            if (serviceItemList.currentIndex === index)
                                Kirigami.Theme.highlightColor;
                            else if (mouseHandler.containsMouse)
                                Kirigami.Theme.hoverColor;
                            else
                                 Kirigami.Theme.backgroundColor;
                        }
                        textColor: {
                            if (serviceItemList.currentIndex === index ||
                                mouseHandler.containsMouse)
                                activeTextColor;
                            else
                                Kirigami.Theme.textColor;
                        }

                        onYChanged: serviceItemList.updateDrag(Math.round(y));

                        states: [
                            State {
                                when: mouseHandler.drag.active
                                ParentChange {
                                    target: visServiceItem
                                    parent: serviceItemList
                                }

                                PropertyChanges {
                                    target: visServiceItem
                                    backgroundColor: Kirigami.Theme.backgroundColor
                                    textColor: Kirigami.Theme.textColor
                                    anchors.verticalCenter: undefined
                                    anchors.horizontalCenter: undefined
                                }
                            }
                        ]

                        /* Drag.dragType: Drag.Automatic */
                        Drag.active: mouseHandler.drag.active
                        Drag.hotSpot.x: width / 2
                        Drag.hotSpot.y: height / 2
                        Drag.keys: ["serviceitem"]

                        MouseArea {
                            id: mouseHandler
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            preventStealing: true

                            drag {
                                target: visServiceItem
                                axis: Drag.YAxis
                                /* minimumY: root.y */
                                /* maximumY: serviceItemList.height - serviceDrop.height */
                                smoothed: false
                            }

                            drag.onActiveChanged: {
                                if (mouseHandler.drag.active) {
                                    serviceItemList.indexDragged = index;
                                } 
                            }

                            /* onPositionChanged: { */
                            /*     if (!pressed) { */
                            /*         return; */
                            /*     } */
                            /*     mouseArea.arrangeItem(); */
                            /* } */

                            onPressed: {
                                serviceItemList.interactive = false;
                            }

                            onClicked: {
                                if (mouse.button === Qt.RightButton)
                                    rightClickMenu.popup();
                                else {
                                    serviceItemList.currentIndex = index;
                                    /* currentServiceItem = index; */
                                    /* changeItem(index); */
                                }
                            }

                            onDoubleClicked: {
                                showPassiveNotification("Double Clicked")
                                serviceItemList.currentIndex = index;
                                currentServiceItem = index;
                                changeServiceItem(index);
                            }

                            onReleased: {
                                console.log("should drop");
                                visServiceItem.Drag.drop();
                            }
                        }
                    }

                    Controls.Menu {
                        id: rightClickMenu
                        x: mouseHandler.mouseX
                        y: mouseHandler.mouseY + 10
                        Kirigami.Action {
                            text: "delete"
                            onTriggered: removeItem(index);
                        }
                    }
                }

            }
        

            Kirigami.WheelHandler {
                id: wheelHandler
                target: serviceItemList
                filterMouseEvents: true
                keyNavigationEnabled: true
            }

            Controls.ScrollBar.vertical: Controls.ScrollBar {
                anchors.right: serviceItemList.right
                anchors.rightMargin: 0
                active: hovered || pressed
            }

            function updateDrag(y) {
                if (moveToIndex === serviceItemList.indexAt(0,y))
                    return;
                else
                    moveToIndex = serviceItemList.indexAt(0,y);
                moveRequested(indexDragged, moveToIndex);
            }

            function moveRequested(oldIndex, newIndex) {
                if (newIndex === oldIndex)
                    return;
                if (newIndex === -1)
                    newIndex = 0;
                console.log("moveRequested: ", oldIndex, newIndex);
                visualModel.items.move(oldIndex, newIndex);
                indexDragged = newIndex;
                serviceItemList.currentIndex = indexDragged;
            }

        }

        Rectangle {
            id: dropHighlightLine
            width: parent.width
            height: 4
            color: Kirigami.Theme.hoverColor
            visible: false

        }
        Canvas {
            /* asynchronous: true; */
            x: dropHighlightLine.width - 8
            y: dropHighlightLine.y - 17
            z: 1
            width: 100; height: 100;
            contextType: "2d"
            onPaint: {
                var ctx = getContext("2d");
                ctx.fillStyle = Kirigami.Theme.hoverColor;
                ctx.rotate(30);
                ctx.transform(0.8, 0, 0, 0.8, 0, 30)
                ctx.path = tearDropPath;
                ctx.fill();
            }
            visible: dropHighlightLine.visible
        }
        Path {
            id: tearDropPath
            startX: dropHighlightLine.width
            startY: dropHighlightLine.y + 4
            PathSvg {
                path: "M15 3
                           Q16.5 6.8 25 18
                           A12.8 12.8 0 1 1 5 18
                           Q13.5 6.8 15 3z"
            }
        }
    } 

    Kirigami.ActionToolBar {
        id: serviceToolBar
        Layout.fillWidth: true
        opacity: 1.0
        actions: [
            Kirigami.Action {
                /* text: "Up" */
                icon.name: "arrow-up"
                onTriggered: {
                    const oldid = serviceItemList.currentIndex;
                    const newid = serviceItemList.currentIndex - 1;
                    showPassiveNotification("Up");
                    serviceItemList.moveRequested(oldid, newid);
                    serviceItemList.currentIndex = newid;
                }
            },
            Kirigami.Action {
                /* text: "Down" */
                icon.name: "arrow-down"
                onTriggered: {
                    const oldid = serviceItemList.currentIndex;
                    const newid = serviceItemList.currentIndex + 1;
                    showPassiveNotification("Down");
                    serviceItemList.moveRequested(oldid, newid);
                    serviceItemList.currentIndex = newid;
                }
            },
            Kirigami.Action {
                /* text: "Remove" */
                icon.name: "delete"
                onTriggered: {
                    showPassiveNotification("remove");
                    removeItem(serviceItemList.currentIndex);
                }
            }
        ]
    }

    Connections {
        target: ServiceItemModel
        onDataChanged: {
            if (active)
                serviceItemList.positionViewAtIndex(index, ListView.Contain);
        }
    }

    Component.onCompleted: {
        /* totalServiceItems = serviceItemList.count; */
        console.log("THE TOTAL SERVICE ITEMS: " + totalServiceItems);
    }

    function removeItem(index) {
        ServiceItemModel.removeItem(index);
        /* totalServiceItems--; */
    }

    function addItem(index, name, type,
                     background, backgroundType, text, itemID) {
        const newtext = songsqlmodel.getLyricList(itemID);
        console.log("adding: " + name + " of type " + type);
        ServiceItemModel.insertItem(index, name,
                                    type, background,
                                    backgroundType, newtext);
        /* totalServiceItems++; */
    }

    function appendItem(name, type, background, backgroundType, text, itemID) {
        console.log("adding: " + name + " of type " + type);
        let lyrics;
        if (type === "song") {
            console.log(itemID);
            lyrics = songsqlmodel.getLyricList(itemID);
            console.log(lyrics);
        }

        console.log(background);
        console.log(backgroundType);

        ServiceItemModel.addItem(name, type, background,
                                 backgroundType, lyrics);
        /* totalServiceItems++; */
    }

}
