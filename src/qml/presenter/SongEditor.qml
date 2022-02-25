import QtQuick 2.13
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

Item {
    id: root

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
                    model: ["VictorMono", "Calibri", "Arial", "Quicksand"]
                }
                Controls.SpinBox {
                    editable: true
                    from: 5
                    to: 72
                }
                Controls.ComboBox {
                    model: ["Left", "Center", "Right", "Justify"]
                    implicitWidth: 100
                }
                Controls.ToolButton {
                    text: "B"
                }
                Controls.ToolButton {
                    text: "I"
                }
                Controls.ToolButton {
                    text: "U"
                }
                Controls.ToolSeparator {}
                Item { Layout.fillWidth: true }
                Controls.ToolSeparator {}
                Controls.ToolButton {
                    text: "Effects"
                    icon.name: "image-auto-adjust"
                    onClicked: {}
                }
                Controls.ToolButton {
                    id: backgroundButton
                    text: "Background"
                    icon.name: "fileopen"
                    onClicked: backgroundType.open()
                }

                Controls.Popup {
                    id: backgroundType
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
                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                    ColumnLayout {
                        anchors.fill: parent
                        Controls.ToolButton {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: "Video"
                            icon.name: "emblem-videos-symbolic"
                            onClicked: videoFileDialog.open() & backgroundType.close()
                        }
                        Controls.ToolButton {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            text: "Image"
                            icon.name: "folder-pictures-symbolic"
                            onClicked: imageFileDialog.open() & backgroundType.close()
                        }
                    }
                }
            }
        }

        Controls.SplitView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 2

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
                        textFormat: TextEdit.MarkdownText
                        padding: 10
                        onEditingFinished: {
                            updateLyrics(text);
                            editorTimer.running = false;
                        }
                        onPressed: editorTimer.running = true
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
                Controls.SplitView.preferredWidth: 500
                Controls.SplitView.minimumWidth: 300

                Rectangle {
                    id: slideBar
                    color: Kirigami.Theme.highlightColor

                    Layout.preferredWidth: 500
                    Layout.preferredHeight: songTitleField.height
                    Layout.rightMargin: 20
                    Layout.leftMargin: 20
                }

                Presenter.SlideEditor {
                    id: slideEditor
                    Layout.preferredWidth: 500
                    Layout.fillWidth: true
                    Layout.preferredHeight: slideEditor.width / 16 * 9
                    Layout.bottomMargin: 30
                    Layout.rightMargin: 20
                    Layout.leftMargin: 20
                }

            }
    }

    }
        Timer {
            id: editorTimer
            interval: 1000
            repeat: true
            running: false
            onTriggered: updateLyrics(lyricsEditor.text)
        }
}
