import QtQuick 2.13
import QtQuick.Controls 2.15 as Controls
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

Item {
    id: root

    property int songIndex
    property string songTitle
    property string songLyrics
    property string songAuthor
    property string songCcli
    property string songAudio
    property string songVorder
    property string songBackground
    property string songBackgroundType

    GridLayout {
        id: mainLayout
        anchors.fill: parent
        columns: 2
        rowSpacing: 5
        columnSpacing: 0

        Controls.ToolBar {
            Layout.fillWidth: true
            Layout.columnSpan: 2
            id: toolbar
            RowLayout {
                anchors.fill: parent 

                Controls.ComboBox {
                    model: Qt.fontFamilies()
                    implicitWidth: 300
                    editable: true
                    hoverEnabled: true
                    onCurrentTextChanged: showPassiveNotification(currentText)
                }
                Controls.SpinBox {
                    editable: true
                    from: 5
                    to: 72
                    hoverEnabled: true
                }
                Controls.ComboBox {
                    model: ["Left", "Center", "Right", "Justify"]
                    implicitWidth: 100
                    hoverEnabled: true
                }
                Controls.ToolButton {
                    text: "B"
                    hoverEnabled: true
                }
                Controls.ToolButton {
                    text: "I"
                    hoverEnabled: true
                }
                Controls.ToolButton {
                    text: "U"
                    hoverEnabled: true
                }
                Controls.ToolSeparator {}
                Item { Layout.fillWidth: true }
                Controls.ToolSeparator {}
                Controls.ToolButton {
                    text: "Effects"
                    icon.name: "image-auto-adjust"
                    hoverEnabled: true
                    onClicked: {}
                }
                Controls.ToolButton {
                    id: backgroundButton
                    text: "Background"
                    icon.name: "fileopen"
                    hoverEnabled: true
                    onClicked: backgroundTypePopup.open()
                }

                Controls.Popup {
                    id: backgroundTypePopup
                    x: backgroundButton.x
                    y: backgroundButton.y + backgroundButton.height + 20
                    modal: true
                    focus: true
                    dim: false
                    background: Rectangle {
                        Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip
                        color: Kirigami.Theme.backgroundColor
                        radius: 10
                        border.color: Kirigami.Theme.activeBackgroundColor
                        border.width: 2
                    }
                    closePolicy: Controls.Popup.CloseOnEscape | Controls.Popup.CloseOnPressOutsideParent
                    ColumnLayout {
                        anchors.fill: parent
                        Controls.ToolButton {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: "Video"
                            icon.name: "emblem-videos-symbolic"
                            onClicked: videoFileDialog.open() & backgroundTypePopup.close()
                        }
                        Controls.ToolButton {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            text: "Image"
                            icon.name: "folder-pictures-symbolic"
                            onClicked: imageFileDialog.open() & backgroundTypePopup.close()
                        }
                    }
                }
            }
        }

        Controls.SplitView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 2
            handle: Item{
                implicitWidth: 6
                Rectangle {
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 1
                    color: Controls.SplitHandle.hovered ? Kirigami.Theme.hoverColor : Kirigami.Theme.backgroundColor
                }
            }
            
            ColumnLayout {
                Controls.SplitView.fillHeight: true
                Controls.SplitView.preferredWidth: 500
                Controls.SplitView.minimumWidth: 500

                Controls.TextField {
                    id: songTitleField

                    Layout.preferredWidth: 300
                    Layout.fillWidth: true
                    Layout.leftMargin: 20
                    Layout.rightMargin: 20

                    placeholderText: "Song Title..."
                    text: songTitle
                    padding: 10
                    onEditingFinished: updateTitle(text);
                }
                Controls.TextField {
                    id: songVorderField

                    Layout.preferredWidth: 300
                    Layout.fillWidth: true
                    Layout.leftMargin: 20
                    Layout.rightMargin: 20

                    placeholderText: "verse order..."
                    text: songVorder
                    padding: 10
                    onEditingFinished: updateVerseOrder(text);
                }

                Controls.ScrollView {
                    id: songLyricsField

                    Layout.preferredHeight: 3000
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: 20

                    rightPadding: 20

                    Controls.TextArea {
                        id: lyricsEditor
                        width: parent.width
                        placeholderText: "Put lyrics here..."
                        persistentSelection: true
                        text: songLyrics
                        textFormat: TextEdit.PlainText
                        padding: 10
                        onEditingFinished: {
                            updateLyrics(lyricsEditor.getText(0,lyricsEditor.length));
                            editorTimer.running = false;
                        }
                        onPressed: editorTimer.running = true
                        /* Component.onCompleted: text = songsqlmodel.getLyrics(songIndex); */
                    }
                }
                Controls.TextField {
                    id: songAuthorField

                    Layout.fillWidth: true
                    Layout.preferredWidth: 300
                    Layout.leftMargin: 20
                    Layout.rightMargin: 20

                    placeholderText: "Author..."
                    text: songAuthor
                    padding: 10
                    onEditingFinished: updateAuthor(text)
                }

            }
            ColumnLayout {
                Controls.SplitView.fillHeight: true
                Controls.SplitView.preferredWidth: 700
                Controls.SplitView.minimumWidth: 300

                Presenter.SlideEditor {
                    id: slideEditor
                    Layout.preferredWidth: 500
                    Layout.fillWidth: true
                    Layout.preferredHeight: slideEditor.width / 16 * 9
                    Layout.bottomMargin: 30
                    Layout.rightMargin: 20
                    Layout.leftMargin: 20
                }
                Controls.Button {
                    text: "update lyrics"
                    onClicked: {
                        print(lyricsEditor.getText(0,lyricsEditor.length));
                    }
                }
            }
        }
    }

    Timer {
        id: editorTimer
        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            updateLyrics(lyricsEditor.getText(0,lyricsEditor.length));
        }
    }

    FileDialog {
        id: videoFileDialog
        title: "Please choose a background"
        folder: shortcuts.home
        selectMultiple: false
        nameFilters: ["Video files (*.mp4 *.mkv *.mov *.wmv *.avi *.MP4 *.MOV *.MKV)"]
        onAccepted: {
            updateBackground(videoFileDialog.fileUrls[0], "video");
            print("video background = " + videoFileDialog.fileUrls[0]);
        }
        onRejected: {
            print("Canceled")
        }

    }

    FileDialog {
        id: imageFileDialog
        title: "Please choose a background"
        folder: shortcuts.home
        selectMultiple: false
        nameFilters: ["Image files (*.jpg *.jpeg *.png *.JPG *.JPEG *.PNG)"]
        onAccepted: {
            updateBackground(imageFileDialog.fileUrls[0], "image");
            print("image background = " + imageFileDialog.fileUrls[0]);
        }
        onRejected: {
            print("Canceled")
        }

    }

    function changeSong(index) {
        const song = songsqlmodel.getSong(index);
        songIndex = index;
        songTitle = song[0];
        songLyrics = song[1];
        songAuthor = song[2];
        songCcli = song[3];
        songAudio = song[4];
        songVorder = song[5];
        songBackground = song[6];
        songBackgroundType = song[7];
        if (songBackgroundType == "image") {
            slideEditor.videoBackground = "";
            slideEditor.imageBackground = songBackground;
        } else {
            slideEditor.imageBackground = "";
            slideEditor.videoBackground = songBackground;
        }
        print(song);
    }

    function updateLyrics(lyrics) {
        songsqlmodel.updateLyrics(songIndex, lyrics);
        print(lyrics);
    }

    function updateTitle(title) {
        songsqlmodel.updateTitle(songIndex, title)
    }

    function updateAuthor(author) {
        songsqlmodel.updateAuthor(songIndex, author)
    }

    function updateAudio(audio) {
        songsqlmodel.updateAudio(songIndex, audio)
    }

    function updateCcli(ccli) {
        songsqlmodel.updateCcli(songIndex, ccli)
    }

    function updateVerseOrder(vorder) {
        songsqlmodel.updateVerseOrder(songIndex, vorder)
    }

    function updateBackground(background, backgroundType) {
        songsqlmodel.updateBackground(songIndex, background);
        songsqlmodel.updateBackgroundType(songIndex, backgroundType);
        print("changed background");
    }
}
