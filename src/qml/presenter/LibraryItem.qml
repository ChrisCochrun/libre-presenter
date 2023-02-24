import QtQuick 2.13
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import Qt.labs.platform 1.1 as Labs
import QtQuick.Pdf 5.15
import QtQml.Models 2.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0

Item {
    id: root
    property var proxyModel
    property var innerModel
    property string libraryType
    property string headerLabel
    property string itemLabel
    property string itemSubtitle
    property var newItemFuntion
    property var deleteItemFuntion

    Rectangle {
        id: libraryPanel
        Layout.preferredHeight: 40
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignTop
        z: 2
        color: Kirigami.Theme.backgroundColor

        Controls.Label {
            id: libraryLabel
            /* anchors.centerIn: parent */
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideLeft
            text: label
        }

        Controls.Label {
            id: count
            anchors {left: libraryLabel.right
                     verticalCenter: libraryLabel.verticalCenter
                     leftMargin: 15}
            text: innerModel.rowCount()
            color: Kirigami.Theme.disabledTextColor
        }

        Kirigami.Icon {
            id: drawerArrow
            anchors {right: parent.right
                     verticalCenter: libraryLabel.verticalCenter
                     rightMargin: 10}
            source: "arrow-down"
            rotation: selectedLibrary == libraryType ? 0 : 180

            Behavior on rotation {
                NumberAnimation {
                    easing.type: Easing.OutCubic
                    duration: 300
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (selectedLibrary == libraryType)
                    selectedLibrary = ""
                else
                    selectedLibrary = libraryType
                /* console.log(selectedLibrary) */
            }
        }
    }

    Rectangle {
        id: libraryHeader
        z: 2
        Layout.preferredHeight: 40
        Layout.fillWidth: true
        /* width: parent.width */
        color: Kirigami.Theme.backgroundColor
        opacity: 1
        state: "selected"

        states: [
            State {
                name: "deselected"
                when: (selectedLibrary !== libraryType)
                PropertyChanges {
                    target: libraryHeader
                    Layout.preferredHeight: 0
                }
            },
            State {
                name: "selected"
                when: (selectedLibrary == libraryType)
                PropertyChanges { target: libraryHeader }
            }
        ]

        Kirigami.ActionToolBar {
            height: parent.height
            width: parent.width
            display: Controls.Button.IconOnly
            visible: selectedLibrary == libraryType
            actions: [
                Kirigami.Action {
                    icon.name: "document-new"
                    text: "New " + libraryType
                    tooltip: "Add a new " + libraryType
                    onTriggered: newItemFuntion
                },
                
                Kirigami.Action {
                    id: searchField
                    displayComponent: Kirigami.SearchField {
                        id: searchField
                        height: parent.height
                        width: parent.width - 40
                        onAccepted: proxyModel.setFilterRegularExpression(searchField.text)
                    }
                }
            ]

            Behavior on height {
                NumberAnimation {
                    easing.type: Easing.OutCubic
                    duration: 300
                }
            }
        }
    }

    ListView {
        Layout.preferredHeight: parent.height - 240
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignTop
        id: libraryList
        model: proxyModel
        ItemselectionModel {
            id: selectionModel
            model: proxyModel
            onSelectionChanged: {
                /* showPassiveNotification("deslected: " + deselected); */
                /* showPassiveNotification("selected: " + selected); */
                /* console.log(selected); */
            }
        }
        delegate: libraryDelegate
        state: "selected"

        states: [
            State {
                name: "deselected"
                when: (selectedLibrary !== libraryType)
                PropertyChanges {
                    target: libraryList
                    Layout.preferredHeight: 0
                }
            },
            State {
                name: "selected"
                when: (selectedLibrary == libraryType)
                PropertyChanges { target: libraryList }
            }
        ]

        transitions: Transition {
            to: "*"
            NumberAnimation {
                target: libraryList
                properties: "preferredHeight"
                easing.type: Easing.OutCubic
                duration: 300
            }
        }

        Component {
            id: libraryDelegate
            Item{
                implicitWidth: ListView.view.width
                height: selectedLibrary == libraryType ? 50 : 0
                Kirigami.BasiclistItem {
                    id: listItem

                    property bool rightMenu: false
                    property bool selected: selectionModel.isSelected(proxyModel.idx(index))

                    implicitWidth: libraryList.width
                    height: selectedLibrary == libraryType ? 50 : 0
                    clip: true
                    label: itemLabel
                    subtitle: itemSubtitle
                    icon: "folder-music-symbolic"
                    iconSize: Kirigami.Units.gridUnit
                    supportsMouseEvents: false
                    backgroundColor: Kirigami.Theme.backgroundColor;
                    Binding on backgroundColor {
                        when: dragHandler.containsMouse ||
                            (selectionModel.hasSelection &&
                             selectionModel.isSelected(proxyModel.idx(index)))
                        value: Kirigami.Theme.highlightColor
                    }

                    textColor: Kirigami.Theme.textColor;
                    Binding on textColor {
                        when: dragHandler.containsMouse ||
                            (selectionModel.hasSelection &&
                             selectionModel.isSelected(proxyModel.idx(index)))
                        value: Kirigami.Theme.highlightedTextColor
                    }

                    Behavior on height {
                        NumberAnimation {
                            easing.type: Easing.OutCubic
                            duration: 300
                        }
                    }
                    Drag.active: dragHandler.drag.active
                    Drag.hotSpot.x: width / 2
                    Drag.hotSpot.y: height / 2
                    Drag.keys: [ "library" ]

                    states: State {
                        name: "dragged"
                        when: listItem.Drag.active
                        PropertyChanges {
                            target: listItem
                            x: x
                            y: y
                            width: width
                            height: height
                        }
                        ParentChange {
                            target: listItem
                            parent: rootApp.overlay
                        }
                    }
                }

                MouseArea {
                    id: dragHandler
                    anchors.fill: parent
                    hoverEnabled: true
                    drag {
                        target: listItem
                        onActiveChanged: {
                            if (dragHandler.drag.active) {
                                dragItemIndex = id;
                                dragItemType = libraryType;
                                draggedLibraryItem = self;
                            } else {
                                listItem.Drag.drop();
                                dragHighlightLine.visible = false;
                            }
                        }
                        filterChildren: true
                        threshold: 10
                        /* onDropped: dragHighlightLine.visible = false; */
                    }
                    MouseArea {
                        id: clickHandler
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: {
                            if (mouse.button === Qt.RightButton)
                                rightClickMenu.popup()
                            else if ((mouse.button === Qt.LeftButton) &&
                                     (mouse.modifiers === Qt.ShiftModifier)) {
                                libraryList.selectSongs(index);
                            } else {
                                selectionModel.select(proxyModel.idx(index),
                                                      ItemselectionModel.ClearAndSelect);

                            }
                        }
                        onDoubleClicked: {
                            libraryList.currentIndex = index;
                            if (!editMode)
                                editMode = true;
                            editType = libraryType;
                            editSwitch(id);
                        }

                    }
                }
                Controls.Menu {
                    id: rightClickMenu
                    x: clickHandler.mouseX
                    y: clickHandler.mouseY + 10
                    Kirigami.Action {
                        text: "delete"
                        onTriggered: proxyModel.deleteSong(index)
                    }
                }
            }
        }

        Kirigami.WheelHandler {
            id: wheelHandler
            target: libraryList
            filterMouseEvents: true
            keyNavigationEnabled: true
        }

        Controls.ScrollBar.vertical: Controls.ScrollBar {
            active: hovered || pressed
        }

        function selectItems(row) {
            let currentRow = selectionModel.selectedIndexes[0].row;
            if (row === currentRow)
                return;

            if (row > currentRow) {
                for (var i = currentRow; i <= row; i++) {
                    let idx = proxyModel.idx(i);
                    selectionModel.select(idx, ItemSelectionModel.Select);
                }
            }
            else {
                for (var i = row; i <= currentRow; i++) {
                    let idx = proxyModel.idx(i);
                    selectionModel.select(idx, ItemSelectionModel.Select);
                }
            }
        }
    }
}
