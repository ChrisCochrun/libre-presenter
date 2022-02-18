import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.0 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import QtMultimedia 5.15
import QtAudioEngine 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

ColumnLayout {
    id: root

    property var selectedItem: serviceItemList.selected

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

    ListView {
        id: serviceItemList
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: listModel
        delegate: Kirigami.DelegateRecycler {
            width: serviceItemList.width
            sourceComponent: itemDelegate
        }
        clip: true
        spacing: 2
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

        Component {
            id: itemDelegate
            Kirigami.BasicListItem {
                id: serviceItem
                width: serviceItemList.width
                height:50
                label: itemName
                subtitle: type
                hoverEnabled: true
                backgroundColor: serviceDrop.containsDrag ? Kirigami.Theme.highlightColor : Kirigami.Theme.viewBackgroundColor
                onClicked: serviceItemList.currentIndex = index

                Presenter.DragHandle {
                    listItem: serviceItem
                    listView: serviceItemList
                    onMoveRequested: listModel.move(oldIndex, newIndex, 1)
                    anchors.fill: parent
                }

                DropArea {
                    id: serviceDrop
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onEntered: showPassiveNotification(drag.source + " has entered")
                    onDropped: listModel.append(drag.source)
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
            anchors.leftMargin: 10
            active: hovered || pressed
        }
        ListModel {
            id: listModel
            ListElement {
                itemName: "10,000 Reason"
                type: "song"
            }
            ListElement {
                itemName: "Marvelous Light"
                type: "song"
            }
         }
    }

}

