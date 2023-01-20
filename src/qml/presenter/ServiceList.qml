import QtQuick 2.13
/* import QtQuick.Dialogs 1.0 */
import QtQuick.Controls 2.0 as Controls
/* import QtQuick.Window 2.13 */
import QtQuick.Layouts 1.2
import QtQuick.Shapes 1.15
/* import QtQml.Models 2.12 */
/* import QtMultimedia 5.15 */
/* import QtAudioEngine 1.15 */
import QtGraphicalEffects 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0

Item {
    id: root
    property var selectedItem: serviceItemList.selected
    property var hlItem 

    Rectangle {
        id: background
        color: Kirigami.Theme.backgroundColor
        anchors.fill: parent
    }

    FastBlur {
        id: backgroundBlur
        source: ShaderEffectSource {
            sourceItem: background
            sourceRect: Qt.rect(0, 0, backgroundBlur.width, backgroundBlur.height)
        }
        anchors.fill: parent
        radius: 82
        opacity: 0.60
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent

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
                showPassiveNotification(drag.source.title);
                appendItem(dragItemTitle,
                           dragItemType,
                           dragItemBackground,
                           dragItemBackgroundType,
                           dragItemText,
                           dragItemAudio,
                           dragItemFont,
                           dragItemFontSize,
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

            Component {
                id: delegate
                Kirigami.AbstractListItem {
                    id: serviceListItem
                    implicitWidth: serviceItemList.width
                    height: Kirigami.Units.gridUnit * 2

                    DropArea {
                        id: serviceDrop
                        anchors.fill: parent

                        onEntered: (drag) => {
                            if (drag.keys[0] === "library") {
                                dropHighlightLine.visible = true;
                                showPassiveNotification("Y is: " + serviceDrop.mapToItem(
                                    serviceItemList,0,0).y);
                                dropHighlightLine.y = serviceDrop.mapToItem(
                                    serviceItemList,0,0).y - 2;
                            }
                        }

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
                                        dragItemAudio,
                                        dragItemFont,
                                        dragItemFontSize,
                                        dragItemIndex);
                            } else if (drag.keys[0] === "serviceitem") {
                                /* ServiceItemModel.moveRows(serviceItemList.indexDragged, */
                                /*                       serviceItemList.moveToIndex, 1); */
                                /* serviceItemList.currentIndex = moveToIndex; */
                            }
                            dropHighlightLine.visible = false;
                        }

                        keys: ["library","serviceitem"]

                        Rectangle {
                            id: visServiceItem
                            width: serviceDrop.width
                            height: serviceDrop.height
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }
                            color: {
                                if (active)
                                    Kirigami.Theme.highlightColor;
                                else if (selected)
                                    Kirigami.Theme.focusColor;
                                else if (mouseHandler.containsMouse)
                                    Kirigami.Theme.hoverColor;
                                else
                                    Kirigami.Theme.backgroundColor;
                            }

                            Controls.Label {
                                id: label
                                anchors.left: dragHandle.right
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 5
                                text: name
                                elide: Text.ElideRight
                                width: parent.width - trailing.width - dragHandle.width - 15
                                color: {
                                    if (selected ||
                                        mouseHandler.containsMouse || active)
                                        Kirigami.Theme.highlightedTextColor;
                                    else
                                        Kirigami.Theme.textColor;
                                }
                            }

                            Controls.Label {
                                id: trailing
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.rightMargin: 5
                                text: type
                                color: {
                                    if (selected ||
                                        mouseHandler.containsMouse || active)
                                        Kirigami.Theme.highlightedTextColor;
                                    else
                                        Kirigami.Theme.disabledTextColor;
                                }
                            }

                            /* onYChanged: serviceItemList.updateDrag(Math.round(y)); */

                            states: [
                                State {
                                    when: mouseHandler.drag.active
                                    ParentChange {
                                        target: visServiceItem
                                        parent: serviceItemList
                                    }

                                    PropertyChanges {
                                        target: visServiceItem
                                        /* backgroundColor: Kirigami.Theme.backgroundColor */
                                        /* textColor: Kirigami.Theme.textColor */
                                        anchors.verticalCenter: undefined
                                        anchors.horizontalCenter: undefined
                                    }
                                }
                            ]

                            /* Drag.dragType: Drag.Automatic */
                            /* Drag.active: mouseHandler.drag.active */
                            /* Drag.hotSpot.x: width / 2 */
                            /* Drag.hotSpot.y: height / 2 */
                            /* Drag.keys: ["serviceitem"] */

                            MouseArea {
                                id: mouseHandler
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton

                                /* drag { */
                                /*     target: visServiceItem */
                                /*     axis: Drag.YAxis */
                                /*     /\* minimumY: root.y *\/ */
                                /*     /\* maximumY: serviceItemList.height - serviceDrop.height *\/ */
                                /*     smoothed: false */
                                /* } */

                                /* drag.onActiveChanged: { */
                                /*     if (mouseHandler.drag.active) { */
                                /*         serviceItemList.indexDragged = index; */
                                /*     }  */
                                /* } */

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
                                        rightClickMenu.popup(mouse);
                                    else {
                                        serviceItemList.currentIndex = index;
                                        ServiceItemModel.select(index);
                                    }
                                }

                                onDoubleClicked: {
                                    changeServiceItem(index);
                                }

                                onReleased: {
                                    console.log("should drop");
                                    visServiceItem.Drag.drop();
                                }
                            }

                            Kirigami.ListItemDragHandle {
                                id: dragHandle
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 5
                                /* width: 20 */
                                listItem: serviceListItem
                                listView: serviceItemList
                                onMoveRequested: ServiceItemModel.moveRows(oldIndex,
                                                                           newIndex,
                                                                           1)
                            }

                        }
                        Controls.Menu {
                            id: rightClickMenu
                            x: mouse.mouseX
                            y: mouse.mouseY + 10
                            Kirigami.Action {
                                text: "delete"
                                onTriggered: removeItem(index);
                            }
                        }
                    }
                }
            }

            ListView {
                id: serviceItemList
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: serviceListScrollBar.visible ?
                    parent.width - serviceListScrollBar.width : parent.width
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

                model: ServiceItemModel

                delegate: Kirigami.DelegateRecycler {
                    width: serviceItemList.width
                    sourceComponent: delegate
                }
                Kirigami.WheelHandler {
                    id: wheelHandler
                    target: serviceItemList
                    filterMouseEvents: true
                    /* keyNavigationEnabled: true */
                }

                Controls.ScrollBar.vertical: Controls.ScrollBar {
                    id: serviceListScrollBar
                    parent: serviceItemList.parent
                    anchors.right: background.right
                    anchors.left: serviceItemList.right
                    anchors.top: serviceItemList.top
                    anchors.bottom: serviceItemList.bottom
                    active: hovered || pressed
                }

                /* function updateDrag(y) { */
                /*     if (moveToIndex === serviceItemList.indexAt(0,y)) */
                /*         return; */
                /*     else */
                /*         moveToIndex = serviceItemList.indexAt(0,y); */
                /*     moveRequested(indexDragged, moveToIndex); */
                /* } */

                /* function moveRequested(oldIndex, newIndex) { */
                /*     console.log("moveRequested: ", oldIndex, newIndex); */
                /*     ServiceItemModel.moveRows(oldIndex, newIndex, 1); */
                /*     indexDragged = newIndex; */
                /*     serviceItemList.currentIndex = newIndex; */
                /* } */

            }

            Rectangle {
                id: dropHighlightLine
                width: parent.width
                height: 4
                color: Kirigami.Theme.hoverColor
                visible: false
                Component.onCompleted: {
                    dragHighlightLine = dropHighlightLine;
                }
            }
            Canvas {
                x: dropHighlightLine.width - 8
                y: dropHighlightLine.y - 17
                z: 1
                width: 100; height: 100;
                contextType: "2d"
                renderStrategy: Canvas.Threaded
                onPaint: {
                    console.log(Kirigami.Theme.hoverColor.name());
                    var ctx = getContext("2d");
                    ctx.fillRule = Qt.OddEvenFill
                    ctx.fillStyle = Kirigami.Theme.hoverColor.rgb();
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

            /* Shape { */
            /*     x: dropHighlightLine.width - 8 */
            /*     y: dropHighlightLine.y - 17 */
            /*     z: 1 */
            /*     width: 100; height: 100; */

            /*     ShapePath { */
            /*         fillColor: Kirigami.Theme.hoverColor */
            /*         startX: 0; startY: 0 */
            /*         PathLine { x: 180; y: 130 } */
            /*         PathLine { x: 20; y: 130 } */
            /*         PathLine { x: 20; y: 20 } */
            /*         PathArc { */
            /*             x: 40; y: 200; */
            /*             radiusX: 200; */
            /*             radiusY: 200; */
            /*             useLargeArc: true */
            /*         } */
            /*         PathLine { x: 40; y: 120 } */
            /*         PathArc { */
            /*             x: -40; y: 120; */
            /*             radiusX: 120; */
            /*             radiusY: 120; */
            /*             useLargeArc: true; */
            /*             direction: PathArc.Counterclockwise */
            /*         } */
            /*         PathLine { x: -40; y: 200 } */
            /*     } */
            /* } */
        } 

        Kirigami.ActionToolBar {
            id: serviceToolBar
            Layout.fillWidth: true
            opacity: 1.0
            display: Button.IconOnly
            actions: [
                Kirigami.Action {
                    text: "Up"
                    icon.name: "arrow-up"
                    onTriggered: {
                        const oldid = serviceItemList.currentIndex;
                        if (oldid <= 0)
                        {
                            showPassiveNotification("wow stop trying to go nego");
                            return;
                        }
                        const newid = serviceItemList.currentIndex - 1;
                        showPassiveNotification(oldid + " " + newid);
                        showPassiveNotification("Up");
                        const ans = ServiceItemModel.moveRows(oldid, newid, 1);
                        if (ans)
                        {
                            serviceItemList.currentIndex = newid;
                            showPassiveNotification("move was successful, newid: "
                                                    + serviceItemList.currentIndex);
                        }
                        else
                            showPassiveNotification("move was unsuccessful")
                    }
                },
                Kirigami.Action {
                    text: "Down"
                    icon.name: "arrow-down"
                    onTriggered: {
                        const id = serviceItemList.currentIndex;
                        if (id + 1 >= serviceItemList.count)
                        {
                            showPassiveNotification("wow you dummy you can't got further down");
                            return;
                        };
                        showPassiveNotification("moving ", id, " down");
                        const ans = ServiceItemModel.moveDown(id);
                        if (ans)
                        {
                            serviceItemList.currentIndex = id + 1;
                            showPassiveNotification("move was successful, newid: "
                                                    + serviceItemList.currentIndex);
                        }
                        else
                            showPassiveNotification("move was unsuccessful, id: "
                                                    + id);
                    }
                },
                Kirigami.Action {
                    text: "Remove"
                    icon.name: "delete"
                    onTriggered: {
                        showPassiveNotification("remove");
                        removeItem(serviceItemList.currentIndex);
                    }
                },
                Kirigami.Action {
                    text: "Clear"
                    icon.name: "recycle"
                    onTriggered: {
                        showPassiveNotification("clearing all items");
                        ServiceItemModel.clearAll();
                    }
                }
            ]
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
                     background, backgroundType, text, audio,
                     font, fontSize, itemID) {
        if (type === "song") {
            const newtext = songsqlmodel.getLyricList(itemID);
            console.log("adding: " + name + " of type " + type + " with " + newtext.length + " slides");
            ServiceItemModel.insertItem(index, name,
                                        type, background,
                                        backgroundType, newtext,
                                        audio, font, fontSize, newtext.length, SlideModel);
            /* totalServiceItems++; */
            return;
        }
        if (type === "presentation") {
            console.log("adding: " + name + " of type " + type + " with " + dragItemSlideNumber + " slides");
            ServiceItemModel.insertItem(index, name,
                                        type, background,
                                        backgroundType, "",
                                        "", "", 0, dragItemSlideNumber, SlideModel);
            /* totalServiceItems++; */
            return;
        }
        console.log("adding: " + name + " of type " + type);
        ServiceItemModel.insertItem(index, name,
                                    type, background,
                                    backgroundType, "", "",
                                    "", 0, 0, SlideModel);
        /* totalServiceItems++; */
    }

    function appendItem(name, type, background, backgroundType,
                        text, audio, font, fontSize, itemID) {
        console.log("adding: " + name + " of type " + type);
        let lyrics;
        if (type === "song") {
            console.log("THIS IS A SONG!!!!!");
            console.log(itemID);
            lyrics = songsqlmodel.getLyricList(itemID);
            console.log(lyrics);
            ServiceItemModel.addItem(name, type, background,
                                     backgroundType, lyrics,
                                     audio, font, fontSize, lyrics.length(),
                                     SlideModel);
            /* totalServiceItems++; */
            return;
        };

        if (type === "presentation") {
            console.log("THIS IS A PRESENTATION!!!!!");
            console.log(itemID);
            console.log(lyrics);
            ServiceItemModel.addItem(name, type, background,
                                     backgroundType, "",
                                     audio, font, fontSize,
                                     dragSlideItemNumber,
                                     SlideModel);
            /* totalServiceItems++; */
            return;
        };
        console.log(background);
        console.log(backgroundType);

        ServiceItemModel.addItem(name, type, background,
                                 backgroundType, [""], "",
                                 "", 0, 0, SlideModel);
        /* totalServiceItems++; */
    }

    function changeItem() {
    }

}
