import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

Item {
    id: root

    property string selectedLibrary: "songs"

    Kirigami.Theme.colorSet: Kirigami.Theme.View

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        Rectangle {
            id: songLibraryPanel
            Layout.preferredHeight: 40
            Layout.fillWidth: true
            color: Kirigami.Theme.backgroundColor

            Controls.Label {
                anchors.centerIn: parent
                text: "Songs"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (selectedLibrary == "songs")
                        selectedLibrary = ""
                    else
                        selectedLibrary = "songs"
                    print(selectedLibrary)
                }
            }
        }

        ListView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            id: songLibraryList
            model: _songListModel
            delegate: itemDelegate
            state: "selected"

            Component.onCompleted: print(selectedLibrary)

            states: [
                State {
                    name: "deselected"
                    when: (selectedLibrary !== "songs")
                    PropertyChanges { target: songLibraryList
                                      height: 0
                                      Layout.fillHeight: false
                                      visible: false
                                    }
                },
                State {
                    name: "selected"
                    when: (selectedLibrary == "songs")
                    PropertyChanges { target: songLibraryList }
                }
            ]

            transitions: Transition {
                to: "*"
                NumberAnimation {
                    target: songLibraryList
                    properties: "height"
                    easing.type: Easing.OutCubic
                    duration: 300
                }
            }

            Component {
                id: itemDelegate
                Kirigami.BasicListItem {
                    id: songListItem
                    width: ListView.view.width
                    height:40
                    label: title
                    subtitle: author
                    hoverEnabled: true
                    onClicked: {
                        ListView.view.currentIndex = index
                        song = ListView.view.selected
                        songTitle = title
                        songLyrics = lyrics
                        songAuthor = author
                        showPassiveNotification(songLyrics, 3000)
                    }

                    Drag.active: dragHandler.drag.active
                    Drag.hotSpot.x: width / 2
                    Drag.hotSpot.y: height / 2

                    MouseArea {
                        id: dragHandler
                        anchors.fill: parent
                        drag {
                            target: songListItem
                            onActiveChanged: {
                                if (dragHandler.drag.active) {
                                    draggedLibraryItem = songLibraryList.currentItem
                                    showPassiveNotification(index)
                                }
                            }
                        }
                    }

                    states: State {
                        name: "dragged"
                        when: songListItem.Drag.active
                        PropertyChanges {
                            target: songListItem
                            x: x
                            y: y
                        }
                    }
                }
            }

            Kirigami.WheelHandler {
                id: wheelHandler
                target: songLibraryList
                filterMouseEvents: true
                keyNavigationEnabled: true
            }

            Controls.ScrollBar.vertical: Controls.ScrollBar {
                anchors.right: songLibraryList.right
                anchors.leftMargin: 10
                active: hovered || pressed
            }
        }

        Rectangle {
            id: videoLibraryPanel
            Layout.preferredHeight: 40
            Layout.fillWidth: true
            color: Kirigami.Theme.backgroundColor

            Controls.Label {
                anchors.centerIn: parent
                text: "Videos"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (selectedLibrary == "videos")
                        selectedLibrary = ""
                    else
                        selectedLibrary = "videos"
                    print(selectedLibrary)
                }
            }
        }

        ListView {
            id: videoLibraryList
            Layout.fillHeight: true
            Layout.fillWidth: true
            state: "deselected"

            states: [
                State {
                    name: "deselected"
                    when: (selectedLibrary !== "videos")
                    PropertyChanges { target: videoLibraryList
                                      height: 0
                                      Layout.fillHeight: false
                                      visible: false
                                    }
                },
                State {
                    name: "selected"
                    when: (selectedLibrary == "videos")
                    PropertyChanges { target: videoLibraryList }
                }
            ]

            transitions: Transition {
                to: "*"
                NumberAnimation {
                    target: videoLibraryList
                    properties: "height"
                    easing.type: Easing.OutCubic
                    duration: 300
                }
            }
        }

        Rectangle {
            id: imageLibraryPanel
            Layout.preferredHeight: 40
            Layout.fillWidth: true
            color: Kirigami.Theme.backgroundColor

            Controls.Label {
                anchors.centerIn: parent
                text: "Images"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (selectedLibrary == "images")
                        selectedLibrary = ""
                    else
                        selectedLibrary = "images"
                    print(selectedLibrary)
                }
            }
        }

        ListView {
            id: imageLibraryList
            Layout.fillHeight: true
            Layout.fillWidth: true
            state: "deselected"

            states: [
                State {
                    name: "deselected"
                    when: (selectedLibrary !== "images")
                    PropertyChanges { target: imageLibraryList
                                      height: 0
                                      Layout.fillHeight: false
                                      visible: false
                                    }
                },
                State {
                    name: "selected"
                    when: (selectedLibrary == "images")
                    PropertyChanges { target: imageLibraryList }
                }
            ]

            transitions: Transition {
                to: "*"
                NumberAnimation {
                    target: imageLibraryList
                    properties: "height"
                    easing.type: Easing.OutCubic
                    duration: 300
                }
            }

        }
        Rectangle {
            id: presentationLibraryPanel
            Layout.preferredHeight: 40
            Layout.fillWidth: true
            color: Kirigami.Theme.backgroundColor

            Controls.Label {
                anchors.centerIn: parent
                text: "Presentations"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (selectedLibrary == "presentations")
                        selectedLibrary = ""
                    else
                        selectedLibrary = "presentations"
                    print(selectedLibrary)
                }
            }
        }

        ListView {
            id: presentationLibraryList
            Layout.fillHeight: true
            Layout.fillWidth: true
            state: "deselected"

            states: [
                State {
                    name: "deselected"
                    when: (selectedLibrary !== "presentations")
                    PropertyChanges { target: presentationLibraryList
                                      height: 0
                                      Layout.fillHeight: false
                                      visible: false
                                    }
                },
                State {
                    name: "selected"
                    when: (selectedLibrary == "presentations")
                    PropertyChanges { target: presentationLibraryList }
                }
            ]

            transitions: Transition {
                to: "*"
                NumberAnimation {
                    target: presentationLibraryList
                    properties: "height"
                    easing.type: Easing.OutCubic
                    duration: 300
                }
            }

        }
        Rectangle {
            id: slideLibraryPanel
            Layout.preferredHeight: 40
            Layout.fillWidth: true
            color: Kirigami.Theme.backgroundColor

            Controls.Label {
                anchors.centerIn: parent
                text: "Slides"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (selectedLibrary == "slides")
                        selectedLibrary = ""
                    else
                        selectedLibrary = "slides"
                    print(selectedLibrary)
                }
            }
        }

        ListView {
            id: slideLibraryList
            Layout.fillHeight: true
            Layout.fillWidth: true
            state: "deselected"

            states: [
                State {
                    name: "deselected"
                    when: (selectedLibrary !== "slides")
                    PropertyChanges { target: slideLibraryList
                                      height: 0
                                      Layout.fillHeight: false
                                      visible: false
                                    }
                },
                State {
                    name: "selected"
                    when: (selectedLibrary == "slides")
                    PropertyChanges { target: slideLibraryList }
                }
            ]

            transitions: Transition {
                to: "*"
                NumberAnimation {
                    target: slideLibraryList
                    properties: "height"
                    easing.type: Easing.OutCubic
                    duration: 300
                }
            }

        }
    }

    /* Presenter.LibraryItem { */
    /*     id: songLibrary */
    /*     title: "Songs" */
    /*     model: _songListModel */
    /*     open: true */
    /*     /\* type: "song" *\/ */
    /*     width: parent.width */
    /*     anchors.top: parent.top */
    /* } */

    /* Presenter.LibraryItem { */
    /*     id: ssongLibrary */
    /*     title: "Songs" */
    /*     model: _songListModel */
    /*     open: false */
    /*     width: parent.width */
    /*     /\* type: "song" *\/ */
    /*     anchors.top: songLibrary.bottom */
    /* } */

}
