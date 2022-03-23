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
            appendItem(dragItemTitle,
                       dragItemType,
                       dragItemText,
                       dragItemBackgroundType,
                       dragItemBackground,
                       dragItemIndex);
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
                    id: serviceItem
                    implicitWidth: serviceItemList.width
                    height: 50
                    Kirigami.BasicListItem {
                        anchors.fill: parent
                        label: name
                        subtitle: type
                        hoverEnabled: true
                        supportsMouseEvents: false
                        backgroundColor: {
                            if (parent.ListView.isCurrentItem) {
                                Kirigami.Theme.highlightColor;
                                /* } else if (serviceDrop.constainsDrag){ */
                                /*     Kirigami.Theme.hoverColor; */
                            } else if (mouseHandler.containsMouse){
                                Kirigami.Theme.highlightColor;
                            } else {
                                Kirigami.Theme.backgroundColor;
                            }
                        }
                        textColor: {
                            if (parent.ListView.isCurrentItem || mouseHandler.containsMouse)
                                activeTextColor;
                            else
                                Kirigami.Theme.textColor;
                        }
                    }
                    Presenter.DragHandle {
                        id: mouseHandler
                        anchors.fill: parent
                        listItem: serviceItem
                        listView: serviceItemList
                        onMoveRequested: serviceListModel.move(oldIndex, newIndex, 1)
                        onClicked: {
                            serviceItemList.currentIndex = index;
                            /* showPassiveNotification(serviceItemList.currentIndex); */
                            changeSlideBackground(background, backgroundType);
                            changeSlideText(text);
                            changeSlideType(type);
                        }
                    }

                    DropArea {
                        id: serviceDrop
                        anchors.fill: parent
                        onDropped: {
                            addItem(index,
                                    dragItemTitle,
                                    dragItemType,
                                    dragItemText,
                                    dragItemBackgroundType,
                                    dragItemBackground,
                                    dragItemIndex);
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
                anchors.rightMargin: 0
                active: hovered || pressed
            }

            ListModel {
                id: serviceListModel
                ListElement {
                    name: "10,000 Reason"
                    type: "song"
                    text: "YIP YIP!"
                    backgroundType: "image"
                    background: "file:/home/chris/nextcloud/tfc/openlp/CMG - Nature King 21.jpg"
                }
                ListElement {
                    name: "Marvelous Light"
                    type: "song"
                    text: "HALLELUJAH!"
                    backgroundType: "video"
                    background: "file:/home/chris/nextcloud/tfc/openlp/Fire Embers_Loop.mp4"
                }
                ListElement {
                    name: "Test"
                    type: "video"
                    text: ""
                    backgroundType: "video"
                    background: "file:/home/chris/nextcloud/tfc/openlp/videos/test.mp4"
                }
            }
        }
    }

    function addItem(index, name, type, text, backgroundType, background, itemID) {
        serviceListModel.insert(index, {
            "name": name,
            "type": type,
            "text": text,
            "backgroundType": backgroundType,
            "background": background})
    }

    function appendItem(name, type, text, backgroundType, background, itemID) {
        serviceListModel.append({
            "name": name,
            "type": type,
            "text": text,
            "backgroundType": backgroundType,
            "background": background});

        if (type == "song") {
            const lyrics = songsqlmodel.getLyricList(itemID);
            print(lyrics);
        }

    }
}

