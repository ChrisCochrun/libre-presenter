import QtQuick 2.13
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import Qt.labs.platform 1.1 as Labs
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0
import mpv 1.0

Item {
    id: root

    property string selectedLibrary: "songs"
    property bool overlay: false
    property var videoexts: ["mp4", "webm", "mkv", "avi", "MP4", "WEBM", "MKV"]
    property var imgexts: ["jpg", "png", "gif", "jpeg", "JPG", "PNG"]
    property var presexts: ["pdf", "PDF", "odp", "pptx"]

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
                z: 2
                color: Kirigami.Theme.backgroundColor

                Controls.Label {
                    id: songLabel
                    /* anchors.centerIn: parent */
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideLeft
                    text: "Songs"
                }

                Controls.Label {
                    id: songCount
                    anchors {left: songLabel.right
                             verticalCenter: songLabel.verticalCenter
                             leftMargin: 15}
                    text: songsqlmodel.rowCount()
                    color: Kirigami.Theme.disabledTextColor
                }

                Kirigami.Icon {
                    id: drawerArrow
                    anchors {right: parent.right
                             verticalCenter: songLabel.verticalCenter
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

            Rectangle {
                id: songLibraryHeader
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
                        when: (selectedLibrary !== "songs")
                        PropertyChanges { target: songLibraryHeader
                                          Layout.preferredHeight: 0
                                        }
                    },
                    State {
                        name: "selected"
                        when: (selectedLibrary == "songs")
                        PropertyChanges { target: songLibraryHeader }
                    }
                ]

                Kirigami.ActionToolBar {
                    height: parent.height
                    width: parent.width
                    display: Controls.Button.IconOnly
                    visible: selectedLibrary == "songs"
                    actions: [
                        Kirigami.Action {
                            icon.name: "document-new"
                            text: "New Song"
                            tooltip: "Add a new song"
                            onTriggered: songLibraryList.newSong()
                            /* visible: selectedLibrary == "songs" */
                        },
                        
                        Kirigami.Action {
                            displayComponent: Component {
                                Kirigami.SearchField {
                                    id: searchField
                                    height: parent.height
                                    width: parent.width - 40
                                    onAccepted: showPassiveNotification(searchField.text, 3000)
                                }
                            }
                            /* visible: selectedLibrary == "songs" */
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
                                } else if (songDragHandler.containsMouse){
                                    Kirigami.Theme.highlightColor;
                                } else {
                                     Kirigami.Theme.backgroundColor;
                                 }
                            }
                            textColor: {
                                if (parent.ListView.isCurrentItem || songDragHandler.containsMouse)
                                    activeTextColor;
                                else
                                    Kirigami.Theme.textColor;
                            }

                            Behavior on height {
                                NumberAnimation {
                                    easing.type: Easing.OutCubic
                                    duration: 300
                                }
                            }
                            Drag.active: songDragHandler.drag.active
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
                                    width: width
                                    height: height
                                }
                                ParentChange {
                                    target: songListItem
                                    parent: rootApp.overlay
                                }
                            }
                        }

                        MouseArea {
                            id: songDragHandler
                            anchors.fill: parent
                            hoverEnabled: true
                            drag {
                                target: songListItem
                                onActiveChanged: {
                                    if (songDragHandler.drag.active) {
                                        dragItemIndex = id;
                                        dragItemTitle = title;
                                        dragItemType = "song";
                                        dragItemBackgroundType = backgroundType;
                                        dragItemBackground = background;
                                        dragItemAudio = audio;
                                        dragItemFont = font;
                                        dragItemFontSize = fontSize;
                                        draggedLibraryItem = self;
                                    } else {
                                        songListItem.Drag.drop();
                                        dragHighlightLine.visible = false;
                                    }
                                }
                                filterChildren: true
                                threshold: 10
                                /* onDropped: dragHighlightLine.visible = false; */
                            }
                            MouseArea {
                                id: songClickHandler
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                onClicked: {
                                    if(mouse.button == Qt.RightButton)
                                        rightClickSongMenu.popup()
                                    else{
                                        /* showPassiveNotification(title + id, 3000); */
                                        songLibraryList.currentIndex = index;
                                        if (!editMode)
                                            editMode = true;
                                        editType = "song";
                                        editSwitch(id);
                                    }
                                }

                            }
                        }
                        Controls.Menu {
                            id: rightClickSongMenu
                            x: songClickHandler.mouseX
                            y: songClickHandler.mouseY + 10
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
                    /* parent: songLibraryList.parent */
                    /* anchors.right: songLibraryList.right */
                    /* anchors.top: songLibraryList.headerItem.top */
                    /* anchors.bottom: songLibraryList.bottom */
                    /* anchors.leftMargin: 10 */
                    /* anchors.left: songLibraryList.right */
                    active: hovered || pressed
                }

                function newSong() {
                    songsqlmodel.newSong();
                    songLibraryList.currentIndex = songsqlmodel.rowCount() - 1;
                    if (!editMode)
                        editMode = true;
                    editType = "song";
                    editSwitch(songLibraryList.currentIndex);
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
                    id: videoLabel
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideRight
                    text: "Videos"
                }

                Controls.Label {
                    id: videoCount
                    anchors {left: videoLabel.right
                             verticalCenter: videoLabel.verticalCenter
                             leftMargin: 15}
                    text: videosqlmodel.rowCount()
                    font.pixelSize: 15
                    color: Kirigami.Theme.disabledTextColor
                }

                Kirigami.Icon {
                    id: videoDrawerArrow
                    anchors {right: parent.right
                             verticalCenter: videoLabel.verticalCenter
                             rightMargin: 10}
                    source: "arrow-down"
                    rotation: selectedLibrary == "videos" ? 0 : 180

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
                        if (selectedLibrary == "videos")
                            selectedLibrary = ""
                        else
                            selectedLibrary = "videos"
                        print(selectedLibrary)
                    }
                }
            }

            Rectangle {
                id: videoLibraryHeader
                z: 2
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                /* width: parent.width */
                color: Kirigami.Theme.backgroundColor
                opacity: 1
                state: "deselected"

                states: [
                    State {
                        name: "deselected"
                        when: (selectedLibrary !== "videos")
                        PropertyChanges { target: videoLibraryHeader
                                          Layout.preferredHeight: 0
                                        }
                    },
                    State {
                        name: "selected"
                        when: (selectedLibrary == "videos")
                        PropertyChanges { target: videoLibraryHeader }
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

                Kirigami.ActionToolBar {
                    height: parent.height
                    width: parent.width
                    display: Controls.Button.IconOnly
                    visible: selectedLibrary == "videos"
                    actions: [
                        Kirigami.Action {
                            icon.name: "document-new"
                            text: "New Video"
                            tooltip: "Add a new video"
                            onTriggered: videoLibraryList.newVideo()
                            /* visible: selectedLibrary == "videos" */
                        },
                        
                        Kirigami.Action {
                            displayComponent: Component {
                                Kirigami.SearchField {
                                    id: searchField
                                    height: parent.height
                                    width: parent.width - 40
                                    onAccepted: showPassiveNotification(searchField.text, 3000)
                                }
                            }
                            /* visible: selectedLibrary == "videos" */
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
                id: videoLibraryList
                Layout.preferredHeight: parent.height - 240
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                model: videosqlmodel
                delegate: videoDelegate
                clip: true
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

                Component {
                    id: videoDelegate
                    Item{
                        implicitWidth: ListView.view.width
                        height: selectedLibrary == "videos" ? 50 : 0
                        Kirigami.BasicListItem {
                            id: videoListItem

                            property bool rightMenu: false

                            implicitWidth: videoLibraryList.width
                            height: selectedLibrary == "videos" ? 50 : 0
                            clip: true
                            label: title
                            /* subtitle: author */
                            supportsMouseEvents: false
                            backgroundColor: {
                                if (parent.ListView.isCurrentItem) {
                                    Kirigami.Theme.highlightColor;
                                } else if (videoDragHandler.containsMouse){
                                    Kirigami.Theme.highlightColor;
                                } else {
                                    Kirigami.Theme.backgroundColor;
                                }
                            }
                            textColor: {
                                if (parent.ListView.isCurrentItem || videoDragHandler.containsMouse)
                                    activeTextColor;
                                else
                                    Kirigami.Theme.textColor;
                            }

                            Behavior on height {
                                NumberAnimation {
                                    easing.type: Easing.OutCubic
                                    duration: 300
                                }
                            }
                            Drag.active: videoDragHandler.drag.active
                            Drag.hotSpot.x: width / 2
                            Drag.hotSpot.y: height / 2
                            Drag.keys: [ "library" ]

                            states: State {
                                name: "dragged"
                                when: videoListItem.Drag.active
                                PropertyChanges {
                                    target: videoListItem
                                    x: x
                                    y: y
                                    width: width
                                    height: height
                                }
                                ParentChange {
                                    target: videoListItem
                                    parent: rootApp.overlay
                                }
                            }

                        }

                        MouseArea {
                            id: videoDragHandler
                            anchors.fill: parent
                            hoverEnabled: true
                            drag {
                                target: videoListItem
                                onActiveChanged: {
                                    if (videoDragHandler.drag.active) {
                                        dragItemTitle = title;
                                        dragItemType = "video";
                                        dragItemText = "";
                                        dragItemBackgroundType = "video";
                                        dragItemBackground = filePath;
                                    } else {
                                        videoListItem.Drag.drop()
                                        dragHighlightLine.visible = false;
                                    }
                                }
                                filterChildren: true
                                threshold: 10
                            }
                            MouseArea {
                                id: videoClickHandler
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                onClicked: {
                                    if(mouse.button == Qt.RightButton)
                                        rightClickVideoMenu.popup()
                                    else{
                                        videoLibraryList.currentIndex = index
                                        const video = videosqlmodel.getVideo(videoLibraryList.currentIndex);
                                        if (!editMode)
                                            editMode = true;
                                        editType = "video";
                                        editSwitch(video);
                                    }
                                }

                            }
                        }
                        Controls.Menu {
                            id: rightClickVideoMenu
                            x: videoClickHandler.mouseX
                            y: videoClickHandler.mouseY + 10
                            Kirigami.Action {
                                text: "delete"
                                onTriggered: videosqlmodel.deleteVideo(index)
                            }
                        }
                    }
                }

                Controls.ScrollBar.vertical: Controls.ScrollBar {
                    anchors.right: videoLibraryList.right
                    /* anchors.leftMargin: 10 */
                    /* anchors.left: videoLibraryList.right */
                    active: hovered || pressed
                }

            }

            Rectangle {
                id: imageLibraryPanel
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                color: Kirigami.Theme.backgroundColor
                opacity: 1.0

                Controls.Label {
                    id: imageLabel
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideRight
                    text: "Images"
                }

                Controls.Label {
                    id: imageCount
                    anchors {left: imageLabel.right
                             verticalCenter: imageLabel.verticalCenter
                             leftMargin: 15}
                    text: imagesqlmodel.rowCount()
                    font.pixelSize: 15
                    color: Kirigami.Theme.disabledTextColor
                }

                Kirigami.Icon {
                    id: imageDrawerArrow
                    anchors {right: parent.right
                             verticalCenter: imageLabel.verticalCenter
                             rightMargin: 10}
                    source: "arrow-down"
                    rotation: selectedLibrary == "images" ? 0 : 180

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
                        if (selectedLibrary == "images")
                            selectedLibrary = ""
                        else
                            selectedLibrary = "images"
                        print(selectedLibrary)
                    }
                }
            }

            Rectangle {
                id: imageLibraryHeader
                z: 2
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                /* width: parent.width */
                color: Kirigami.Theme.backgroundColor
                opacity: 1
                state: "deselected"

                states: [
                    State {
                        name: "deselected"
                        when: (selectedLibrary !== "images")
                        PropertyChanges { target: imageLibraryHeader
                                          Layout.preferredHeight: 0
                                        }
                    },
                    State {
                        name: "selected"
                        when: (selectedLibrary == "images")
                        PropertyChanges { target: imageLibraryHeader }
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

                Kirigami.ActionToolBar {
                    height: parent.height
                    width: parent.width
                    display: Controls.Button.IconOnly
                    visible: selectedLibrary == "images"
                    actions: [
                        Kirigami.Action {
                            icon.name: "document-new"
                            text: "New Image"
                            tooltip: "Add a new image"
                            onTriggered: imageLibraryList.newImage()
                            /* visible: selectedLibrary == "images" */
                        },
                        
                        Kirigami.Action {
                            displayComponent: Component {
                                Kirigami.SearchField {
                                    id: searchField
                                    height: parent.height
                                    width: parent.width - 40
                                    onAccepted: showPassiveNotification(searchField.text, 3000)
                                }
                            }
                            /* visible: selectedLibrary == "images" */
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
                id: imageLibraryList
                Layout.preferredHeight: parent.height - 240
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                model: imagesqlmodel
                delegate: imageDelegate
                clip: true
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

                Component {
                    id: imageDelegate
                    Item{
                        implicitWidth: ListView.view.width
                        height: selectedLibrary == "images" ? 50 : 0
                        Kirigami.BasicListItem {
                            id: imageListItem

                            property bool rightMenu: false

                            implicitWidth: imageLibraryList.width
                            height: selectedLibrary == "images" ? 50 : 0
                            clip: true
                            label: title
                            /* subtitle: author */
                            supportsMouseEvents: false
                            backgroundColor: {
                                if (parent.ListView.isCurrentItem) {
                                    Kirigami.Theme.highlightColor;
                                } else if (imageDragHandler.containsMouse){
                                    Kirigami.Theme.highlightColor;
                                } else {
                                    Kirigami.Theme.backgroundColor;
                                }
                            }
                            textColor: {
                                if (parent.ListView.isCurrentItem || imageDragHandler.containsMouse)
                                    activeTextColor;
                                else
                                    Kirigami.Theme.textColor;
                            }

                            Behavior on height {
                                NumberAnimation {
                                    easing.type: Easing.OutCubic
                                    duration: 300
                                }
                            }
                            Drag.active: imageDragHandler.drag.active
                            Drag.hotSpot.x: width / 2
                            Drag.hotSpot.y: height / 2
                            Drag.keys: [ "library" ]

                            states: State {
                                name: "dragged"
                                when: imageListItem.Drag.active
                                PropertyChanges {
                                    target: imageListItem
                                    x: x
                                    y: y
                                    width: width
                                    height: height
                                }
                                ParentChange {
                                    target: imageListItem
                                    parent: rootApp.overlay
                                }
                            }

                        }

                        MouseArea {
                            id: imageDragHandler
                            anchors.fill: parent
                            hoverEnabled: true
                            drag {
                                target: imageListItem
                                onActiveChanged: {
                                    if (imageDragHandler.drag.active) {
                                        dragItemTitle = title;
                                        dragItemType = "image";
                                        dragItemText = "";
                                        dragItemBackgroundType = "image";
                                        dragItemBackground = filePath;
                                    } else {
                                        imageListItem.Drag.drop()
                                        dragHighlightLine.visible = false;
                                    }
                                }
                                filterChildren: true
                                threshold: 10
                            }
                            MouseArea {
                                id: imageClickHandler
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                onClicked: {
                                    if(mouse.button == Qt.RightButton)
                                        rightClickImageMenu.popup()
                                    else{
                                        imageLibraryList.currentIndex = index
                                        const image = imagesqlmodel.getImage(imageLibraryList.currentIndex);
                                        if (!editMode)
                                            editMode = true;
                                        editType = "image";
                                        editSwitch(image);
                                    }
                                }

                            }
                        }
                        Controls.Menu {
                            id: rightClickImageMenu
                            x: imageClickHandler.mouseX
                            y: imageClickHandler.mouseY + 10
                            Kirigami.Action {
                                text: "delete"
                                onTriggered: imagesqlmodel.deleteImage(index)
                            }
                        }
                    }
                }

                Controls.ScrollBar.vertical: Controls.ScrollBar {
                    /* anchors.right: videoLibraryList.right */
                    /* anchors.leftMargin: 10 */
                    /* anchors.left: videoLibraryList.right */
                    active: hovered || pressed
                }

            }

            Rectangle {
                id: presentationLibraryPanel
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                color: Kirigami.Theme.backgroundColor

                Controls.Label {
                    id: presentationLabel
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideRight
                    text: "Presentations"
                }

                Controls.Label {
                    id: presentationCount
                    anchors {left: presentationLabel.right
                             verticalCenter: presentationLabel.verticalCenter
                             leftMargin: 10}
                    text: pressqlmodel.rowCount()
                    font.pixelSize: 15
                    color: Kirigami.Theme.disabledTextColor
                }

                Kirigami.Icon {
                    id: presentationDrawerArrow
                    anchors {right: parent.right
                             verticalCenter: presentationLabel.verticalCenter
                             rightMargin: 10}
                    source: "arrow-down"
                    rotation: selectedLibrary == "presentations" ? 0 : 180

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
                        if (selectedLibrary == "presentations")
                            selectedLibrary = ""
                        else
                            selectedLibrary = "presentations"
                        print(selectedLibrary)
                    }
                }
            }

            Rectangle {
                id: presentationLibraryHeader
                z: 2
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                /* width: parent.width */
                color: Kirigami.Theme.backgroundColor
                opacity: 1
                state: "deselected"

                states: [
                    State {
                        name: "deselected"
                        when: (selectedLibrary !== "presentations")
                        PropertyChanges { target: presentationLibraryHeader
                                          Layout.preferredHeight: 0
                                        }
                    },
                    State {
                        name: "selected"
                        when: (selectedLibrary == "presentations")
                        PropertyChanges { target: presentationLibraryHeader }
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

                Kirigami.ActionToolBar {
                    height: parent.height
                    width: parent.width
                    display: Controls.Button.IconOnly
                    visible: selectedLibrary == "presentations"
                    actions: [
                        Kirigami.Action {
                            icon.name: "document-new"
                            text: "New Presentation"
                            tooltip: "Add a new presentation"
                            onTriggered: presentationLibraryList.newPresentation()
                            /* visible: selectedLibrary == "presentations" */
                        },
                        
                        Kirigami.Action {
                            displayComponent: Component {
                                Kirigami.SearchField {
                                    id: searchField
                                    height: parent.height
                                    width: parent.width - 40
                                    onAccepted: showPassiveNotification(searchField.text, 3000)
                                }
                            }
                            /* visible: selectedLibrary == "presentations" */
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
                id: presentationLibraryList
                Layout.preferredHeight: parent.height - 240
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                clip: true
                model: pressqlmodel
                delegate: presDelegate
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

                Component {
                    id: presDelegate
                    Item{
                        implicitWidth: ListView.view.width
                        height: selectedLibrary == "presentations" ? 50 : 0
                        Kirigami.BasicListItem {
                            id: presListItem

                            property bool rightMenu: false

                            implicitWidth: presentationLibraryList.width
                            height: selectedLibrary == "presentations" ? 50 : 0
                            clip: true
                            label: title
                            /* subtitle: author */
                            supportsMouseEvents: false
                            backgroundColor: {
                                if (parent.ListView.isCurrentItem) {
                                    Kirigami.Theme.highlightColor;
                                } else if (presDragHandler.containsMouse){
                                    Kirigami.Theme.highlightColor;
                                } else {
                                    Kirigami.Theme.backgroundColor;
                                }
                            }
                            textColor: {
                                if (parent.ListView.isCurrentItem || presDragHandler.containsMouse)
                                    activeTextColor;
                                else
                                    Kirigami.Theme.textColor;
                            }

                            Behavior on height {
                                NumberAnimation {
                                    easing.type: Easing.OutCubic
                                    duration: 300
                                }
                            }
                            Drag.active: presDragHandler.drag.active
                            Drag.hotSpot.x: width / 2
                            Drag.hotSpot.y: height / 2
                            Drag.keys: [ "library" ]

                            states: State {
                                name: "dragged"
                                when: presListItem.Drag.active
                                PropertyChanges {
                                    target: presListItem
                                    x: x
                                    y: y
                                    width: width
                                    height: height
                                }
                                ParentChange {
                                    target: presListItem
                                    parent: rootApp.overlay
                                }
                            }

                        }

                        MouseArea {
                            id: presDragHandler
                            anchors.fill: parent
                            hoverEnabled: true
                            drag {
                                target: presListItem
                                onActiveChanged: {
                                    if (presDragHandler.drag.active) {
                                        dragItemTitle = title;
                                        dragItemType = "presentation";
                                        dragItemText = "";
                                        dragItemBackgroundType = "image";
                                        dragItemBackground = filePath;
                                    } else {
                                        presListItem.Drag.drop()
                                        dragHighlightLine.visible = false;
                                    }
                                }
                                filterChildren: true
                                threshold: 10
                            }
                            MouseArea {
                                id: presClickHandler
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                onClicked: {
                                    if(mouse.button == Qt.RightButton)
                                        rightClickPresMenu.popup()
                                    else{
                                        presentationLibraryList.currentIndex = index
                                        const pres = pressqlmodel.getPresentation(presentationLibraryList.currentIndex);
                                        if (!editMode)
                                            editMode = true;
                                        editType = "presentation";
                                        editSwitch(pres);
                                    }
                                }

                            }
                        }
                        Controls.Menu {
                            id: rightClickPresMenu
                            x: presClickHandler.mouseX
                            y: presClickHandler.mouseY + 10
                            Kirigami.Action {
                                text: "delete"
                                onTriggered: pressqlmodel.deletePresentation(index)
                            }
                        }
                    }
                }
                Controls.ScrollBar.vertical: Controls.ScrollBar {
                    /* anchors.right: videoLibraryList.right */
                    /* anchors.leftMargin: 10 */
                    /* anchors.left: videoLibraryList.right */
                    active: hovered || pressed
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

            Rectangle {
                id: slideLibraryHeader
                z: 2
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                /* width: parent.width */
                color: Kirigami.Theme.backgroundColor
                opacity: 1
                state: "deselected"

                states: [
                    State {
                        name: "deselected"
                        when: (selectedLibrary !== "slides")
                        PropertyChanges { target: slideLibraryHeader
                                          Layout.preferredHeight: 0
                                        }
                    },
                    State {
                        name: "selected"
                        when: (selectedLibrary == "slides")
                        PropertyChanges { target: slideLibraryHeader }
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

                Kirigami.ActionToolBar {
                    height: parent.height
                    width: parent.width
                    display: Controls.Button.IconOnly
                    visible: selectedLibrary == "slides"
                    actions: [
                        Kirigami.Action {
                            icon.name: "document-new"
                            text: "New Slide"
                            tooltip: "Add a new slide"
                            onTriggered: slideLibraryList.newSlide()
                            /* visible: selectedLibrary == "slides" */
                        },
                        
                        Kirigami.Action {
                            displayComponent: Component {
                                Kirigami.SearchField {
                                    id: searchField
                                    height: parent.height
                                    width: parent.width - 40
                                    onAccepted: showPassiveNotification(searchField.text, 3000)
                                }
                            }
                            /* visible: selectedLibrary == "slides" */
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
                id: slideLibraryList
                Layout.preferredHeight: parent.height - 240
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

                Controls.ScrollBar.vertical: Controls.ScrollBar {
                    /* anchors.right: videoLibraryList.right */
                    /* anchors.leftMargin: 10 */
                    /* anchors.left: videoLibraryList.right */
                    active: hovered || pressed
                }

            }
        }

        DropArea {
            id: fileDropArea
            anchors.fill: parent
            onDropped: drop => {
                overlay = false;
                print("dropped");
                print(drop.urls);
                /* thumbnailer.loadFile(drop.urls[0]); */
                if (drop.urls.length > 1){
                    addFiles(drop.urls);
                } else if (drop.urls.length === 1)
                    addFile(drop.urls[0]);
                else if (drop.urls.length === 0)
                    print("stoppp it ya dum dum");
            }
            onEntered: {
                if (isDragFile(drag.urls[0]))
                    overlay = true;
            }
            onExited: overlay = false

            function addVideo(url) {
                videosqlmodel.newVideo(url);
                selectedLibrary = "videos";
                videoLibraryList.currentIndex = videosqlmodel.rowCount();
                print(videosqlmodel.getVideo(videoLibraryList.currentIndex));
                const video = videosqlmodel.getVideo(videoLibraryList.currentIndex);
                showPassiveNotification("newest video: " + video.title);
                if (!editMode)
                    editMode = true;
                editSwitch("video", video);
            }

            function addImg(url) {
                imagesqlmodel.newImage(url);
                selectedLibrary = "images";
                imageLibraryList.currentIndex = imagesqlmodel.rowCount();
                print(imagesqlmodel.getImage(imageLibraryList.currentIndex));
                const image = imagesqlmodel.getImage(imageLibraryList.currentIndex);
                showPassiveNotification("newest image: " + image.title);
                if (!editMode)
                    editMode = true;
                editSwitch("image", image);
            }

            function addPres(url) {
                pressqlmodel.newPresentation(url);
                selectedLibrary = "presentations";
                presentationLibraryList.currentIndex = pressqlmodel.rowCount();
                print(pressqlmodel.getPresentation(presentationLibraryList.currentIndex));
                const presentation = pressqlmodel.getImage(presentationLibraryList.currentIndex);
                showPassiveNotification("newest image: " + presentation.title);
                if (!editMode)
                    editMode = true;
                editSwitch("presentation", presentation);
            }

            function isDragFile(item) {
                var extension = item.split('.').pop();
                var valid = false;

                if(extension) {
                    print(extension);
                    valid = true;
                }

                return valid;
            }

            function addFile(file) {
                let extension = file.split('.').pop();
                if (videoexts.includes(extension))
                {
                    addVideo(file);
                    return;
                }
                if (imgexts.includes(extension))
                {
                    addImg(file);
                    return
                }
                if (presexts.includes(extension))
                {
                    addPres(file);
                    return
                }
                
            }

            function addFiles(files) {
                showPassiveNotification("More than one file");
                for (let i = 0; i < files.length; i++) {
                    let file = files[i];
                    let ext = file.split('.').pop()
                    if (videoexts.includes(ext))
                    {
                        addVideo(file);
                    }
                    if (imgexts.includes(ext))
                    {
                        addImg(file);
                    }
                    if (presexts.includes(ext))
                    {
                        addPres(file);
                        return;
                    }
                }
            }
        }

        Rectangle {
            id: fileDropOverlay
            color: overlay ? Kirigami.Theme.highlightColor : "#00000000"
            anchors.fill: parent
            border.width: 8
            border.color: overlay ? Kirigami.Theme.hoverColor : "#00000000"
        }

        MpvObject {
            id: thumbnailer
            useHwdec: true
            enableAudio: false
            width: 0
            height: 0
            Component.onCompleted: print("ready")
            onFileLoaded: {
                thumbnailer.pause();
                print("FILE: " + thumbnailer.mediaTitle);
                thumbnailer.screenshotToFile(thumbnailFile(thumbnailer.mediaTitle));
                showPassiveNotification("Screenshot Taken to: " + thumbnailFile(thumbnailer.mediaTitle));
                thumbnailer.stop();
            }
            function thumbnailFile(title) {
                const thumbnailFolder = Labs.StandardPaths.writableLocation(Labs.StandardPaths.AppDataLocation) + "/thumbnails/";
                return Qt.resolvedUrl(thumbnailFolder + title);
            }
        }

    }
}
