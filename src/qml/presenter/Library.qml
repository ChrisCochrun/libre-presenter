import QtQuick 2.13
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0

Item {
    id: root

    property string selectedLibrary: "songs"

    Kirigami.Theme.colorSet: Kirigami.Theme.View

    Rectangle {
        anchors.fill: parent
        color: Kirigami.Theme.backgroundColor
        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            Rectangle {
                id: songLibraryPanel
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                color: Kirigami.Theme.backgroundColor

                Controls.Label {
                    id: songLabel
                    anchors.centerIn: parent
                    text: "Songs"
                }

                Controls.Label {
                    id: songCount
                    anchors {left: songLabel.right
                             verticalCenter: songLabel.verticalCenter
                             leftMargin: 15}
                    text: songsqlmodel.rowCount()
                    font.pixelSize: 15
                    color: Kirigami.Theme.disabledTextColor
                }

                Kirigami.Icon {
                    id: drawerArrow
                    anchors {right: parent.right
                             verticalCenter: songCount.verticalCenter
                             rightMargin: 10}
                    source: "arrow-down"
                    rotation: selectedLibrary == "songs" ? 0 : 180

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
                        if (selectedLibrary == "songs")
                            selectedLibrary = ""
                        else
                            selectedLibrary = "songs"
                        print(selectedLibrary)
                    }
                }
            }

            ListView {
                Layout.preferredHeight: parent.height - 200
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                id: songLibraryList
                model: songsqlmodel
                delegate: songDelegate
                state: "selected"

                states: [
                    State {
                        name: "deselected"
                        when: (selectedLibrary !== "songs")
                        PropertyChanges { target: songLibraryList
                                          Layout.preferredHeight: 0
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
                        properties: "preferredHeight"
                        easing.type: Easing.OutCubic
                        duration: 300
                    }
                }

                header: Component {
                    Kirigami.ActionToolBar {
                        height: selectedLibrary == "songs" ? 40 : 0
                        width: parent.width
                        display: Button.IconOnly
                        actions: [
                            Kirigami.Action {
                                icon.name: "document-new"
                                text: "New Song"
                                tooltip: "Add a new song"
                                onTriggered: songLibraryList.newSong()
                            },
                            
                            Kirigami.Action {
                                displayComponent: Component {
                                    Kirigami.SearchField {
                                        id: searchField
                                        width: parent.width - 40
                                        onAccepted: showPassiveNotification(searchField.text, 3000)
                                    }
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

                headerPositioning: ListView.OverlayHeader

                Component {
                    id: songDelegate
                    Item{
                        implicitWidth: ListView.view.width
                        height: selectedLibrary == "songs" ? 50 : 0
                        Kirigami.BasicListItem {
                            id: songListItem

                            property bool rightMenu: false

                            implicitWidth: songLibraryList.width
                            height: selectedLibrary == "songs" ? 50 : 0
                            clip: true
                            label: title
                            subtitle: author
                            supportsMouseEvents: false
                            backgroundColor: {
                                if (parent.ListView.isCurrentItem) {
                                    Kirigami.Theme.highlightColor;
                                } else if (dragHandler.containsMouse){
                                    Kirigami.Theme.highlightColor;
                                } else {
                                     Kirigami.Theme.backgroundColor;
                                 }
                            }
                            textColor: {
                                if (parent.ListView.isCurrentItem || dragHandler.containsMouse)
                                    activeTextColor;
                                else
                                    Kirigami.Theme.textColor;
                            }

                            /* onAdd: { */
                            /*     showPassiveNotification(title, 3000) */
                            /*     songLibraryList.currentIndex = index */
                            /*     song = index */
                            /*     songTitle = title */
                            /*     songLyrics = lyrics */
                            /*     songAuthor = author */
                            /*     songVorder = vorder */
                            /* } */

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
                                when: songListItem.Drag.active
                                PropertyChanges {
                                    target: songListItem
                                    x: x
                                    y: y
                                }
                            }

                        }

                        MouseArea {
                            id: dragHandler
                            anchors.fill: parent
                            hoverEnabled: true
                            drag {
                                target: songListItem
                                onActiveChanged: {
                                    if (dragHandler.drag.active) {
                                        dragSongTitle = title
                                        showPassiveNotification(dragSongTitle)
                                    } else {
                                        songListItem.Drag.drop()
                                    }
                                }
                                filterChildren: true
                                threshold: 10
                            }
                            MouseArea {
                                id: clickHandler
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                onClicked: {
                                    if(mouse.button == Qt.RightButton)
                                        rightClickSongMenu.popup()
                                    else{
                                        showPassiveNotification(title, 3000)
                                        songLibraryList.currentIndex = index
                                        song = index
                                        songTitle = title
                                        songLyrics = lyrics
                                        songAuthor = author
                                        songVorder = vorder
                                    }
                                }

                            }
                        }
                        Controls.Menu {
                            id: rightClickSongMenu
                            x: clickHandler.mouseX
                            y: clickHandler.mouseY + 10
                            Kirigami.Action {
                                text: "delete"
                                onTriggered: songsqlmodel.deleteSong(index)
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

                function newSong() {
                    songsqlmodel.newSong();
                    songLibraryList.currentIndex = songsqlmodel.rowCount();
                    showPassiveNotification("newest song index: " + songLibraryList.currentIndex)
                }
            }

            Rectangle {
                id: videoLibraryPanel
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                color: Kirigami.Theme.backgroundColor
                opacity: 1.0

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
                Layout.preferredHeight: parent.height - 200
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                state: "deselected"

                states: [
                    State {
                        name: "deselected"
                        when: (selectedLibrary !== "videos")
                        PropertyChanges { target: videoLibraryList
                                          Layout.preferredHeight: 0
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
                        properties: "preferredHeight"
                        easing.type: Easing.OutCubic
                        duration: 300
                    }
                }
            }

            Rectangle {
                id: imageLibraryPanel
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
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
                Layout.preferredHeight: parent.height - 200
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                state: "deselected"

                states: [
                    State {
                        name: "deselected"
                        when: (selectedLibrary !== "images")
                        PropertyChanges { target: imageLibraryList
                                          Layout.preferredHeight: 0
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
                            properties: "preferredHeight"
                            easing.type: Easing.OutCubic
                            duration: 300
                        }
                    }

                }
                Rectangle {
                    id: presentationLibraryPanel
                    Layout.preferredHeight: 40
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
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
                    Layout.preferredHeight: parent.height - 200
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    state: "deselected"

                    states: [
                        State {
                            name: "deselected"
                            when: (selectedLibrary !== "presentations")
                            PropertyChanges { target: presentationLibraryList
                                              Layout.preferredHeight: 0
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
                            properties: "preferredHeight"
                            easing.type: Easing.OutCubic
                            duration: 300
                        }
                    }

                }
                Rectangle {
                    id: slideLibraryPanel
                    Layout.preferredHeight: 40
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
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
                    Layout.preferredHeight: parent.height - 200
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    state: "deselected"

                    states: [
                        State {
                            name: "deselected"
                            when: (selectedLibrary !== "slides")
                            PropertyChanges { target: slideLibraryList
                                              Layout.preferredHeight: 0
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
                            properties: "preferredHeight"
                            easing.type: Easing.OutCubic
                            duration: 300
                        }
                    }

                }
            }
    }
}
