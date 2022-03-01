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

    DropArea {
        id: serviceDropEnd
        Layout.fillHeight: true
        Layout.fillWidth: true
        onDropped: {
            serviceListModel.append({"name": dragSongTitle, "type": "song"});
        }
        keys: ["library"]

        ListView {
            id: serviceItemList
            anchors.fill: parent
            model: serviceListModel
            delegate: Kirigami.DelegateRecycler {
                width: serviceItemList.width
                sourceComponent: itemDelegate
            }
            clip: true
            spacing: 3

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
                Item {
                    implicitWidth: ListView.view.width
                    height: 50
                    Kirigami.BasicListItem {
                        id: serviceItem
                        width: serviceItemList.width
                        height: 50
                        label: name
                        subtitle: type
                        hoverEnabled: true
                        supportsMouseEvents: false
                        backgroundColor: {
                            if (serviceDrop.containsDrag | isCurrentItem) {
                                Kirigami.Theme.highlightColor
                            } else
                                Kirigami.Theme.viewBackgroundColor
                        }
                        /* onClicked: serviceItemList.currentIndex = index && showPassiveNotification(serviceItemList.currentIndex) */

                    }
                    Presenter.DragHandle {
                        width: serviceItemList.width
                        height: 50
                        /* anchors.fill: parent */
                        listItem: serviceItem
                        listView: serviceItemList
                        onMoveRequested: serviceListModel.move(oldIndex, newIndex, 1)
                        onActivated: serviceItemList.currentIndex = index && showPassiveNotification(serviceItemList.currentIndex)
                    }
                    DropArea {
                        id: serviceDrop
                        width: serviceItemList.width
                        height: 50
                        onDropped: {
                            serviceListModel.insert(index, {"name": dragSongTitle, "type": "song"});
                            showPassiveNotification(index);
                        }
                        keys: ["library"]
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
                id: serviceListModel
                ListElement {
                    name: "10,000 Reason"
                    type: "song"
                }
                ListElement {
                    name: "Marvelous Light"
                    type: "song"
                }
                ListElement {
                    name: "10,000 Reason"
                    type: "song"
                }
                ListElement {
                    name: "Marvelous Light"
                    type: "song"
                }
            }

        }

    }
}

