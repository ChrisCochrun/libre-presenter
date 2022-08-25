import QtQuick 2.13
/* import QtQuick.Dialogs 1.0 */
import QtQuick.Controls 2.0 as Controls
/* import QtQuick.Window 2.13 */
import QtQuick.Layouts 1.2
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
        onDropped: {
            print("DROPPED AT END");
            appendItem(dragItemTitle,
                       dragItemType,
                       dragItemBackground,
                       dragItemBackgroundType,
                       dragItemText,
                       dragItemIndex);
        }
        keys: ["library"]

        ListView {
            id: serviceItemList
            anchors.fill: parent
            /* model: serviceItemModel */
            /* delegate: Kirigami.DelegateRecycler { */
            /*     width: serviceItemList.width */
            /*     sourceComponent: itemDelegate */
            /* } */
            clip: true
            spacing: 3
            property int indexDragged
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
                model: serviceItemModel

                delegate: DropArea {
                    id: serviceDrop
                    implicitWidth: serviceItemList.width
                    height: 50

                    onEntered: (drag) => {
                        if (drag.keys[0] === "library") {
                            indexedHLRec.visible = true;
                            indexedHLRec.y = y - 2;
                        }
                    }

                    onDropped: (drag) => {
                        print("DROPPED IN ITEM AREA: " + drag.keys);
                        print(dragItemIndex + " " + index);
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
                            moveRequested(dragItemIndex, index);
                            if (hlIndex === serviceItemList.indexDragged)
                                serviceItemList.currentIndex = index;
                            else if (hlIndex === index)
                                serviceItemList.currentIndex = index + 1;
                        }
                        indexedHLRec.visible = false;
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
                                    currentServiceItem = index;
                                    changeServiceItem(index);
                                }
                            }

                            onReleased: {
                                print("should drop");
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

                    function dropPlacement(drag) {
                        print(drag.y);
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
                var newIndex;
                print(serviceItemList.indexAt(0,y));
                serviceItemList.draggedY = y;
                if (y < 30) {
                    indexedHLRec.y = 0;
                    newIndex = 0;
                    moveRequested(indexDragged, newIndex)
                }
                else if (y < 80) {
                    indexedHLRec.y = 50;
                    newIndex = 1;
                    moveRequested(indexDragged, newIndex)
                }
                else if (y < 130) {
                    indexedHLRec.y = 100;
                    newIndex = 2;
                    moveRequested(indexDragged, newIndex)
                }
            }

            function moveRequested(oldIndex, newIndex) {
                serviceItemModel.move(oldIndex, newIndex);
            }

        }

        Rectangle {
            id: indexedHLRec
            width: parent.width
            height: 4
            color: Kirigami.Theme.hoverColor
            visible: false

        }
        Canvas {
            /* asynchronous: true; */
            x: indexedHLRec.width - 8
            y: indexedHLRec.y - 17
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
            visible: indexedHLRec.visible
        }
        Path {
            id: tearDropPath
            startX: indexedHLRec.width
            startY: indexedHLRec.y + 4
            PathSvg {
                path: "M15 3
                           Q16.5 6.8 25 18
                           A12.8 12.8 0 1 1 5 18
                           Q13.5 6.8 15 3z"
            }
        }
    } 

    Component.onCompleted: {
        totalServiceItems = serviceItemList.count;
        print("THE TOTAL SERVICE ITEMS: " + totalServiceItems);
    }

    function removeItem(index) {
        serviceItemModel.removeItem(index);
        totalServiceItems--;
    }

    function addItem(index, name, type,
                     background, backgroundType, text, itemID) {
        const newtext = songsqlmodel.getLyricList(itemID);
        print("adding: " + name + " of type " + type);
        serviceItemModel.insertItem(index, name,
                                    type, background,
                                    backgroundType, newtext);
        totalServiceItems++;
    }

    function appendItem(name, type, background, backgroundType, text, itemID) {
        print("adding: " + name + " of type " + type);
        let lyrics;
        if (type === "song") {
            print(itemID);
            lyrics = songsqlmodel.getLyricList(itemID);
            print(lyrics);
        }

        print(background);
        print(backgroundType);

        serviceItemModel.addItem(name, type, background,
                                 backgroundType, lyrics);
        totalServiceItems++;
    }

    function changeItem() {
        serviceItemList.currentIndex = currentServiceItem;
    }
}
