import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import QtMultimedia 5.15
import QtAudioEngine 1.15
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
                    text: "Background"
                    icon.name: "fileopen"
                    onClicked: {
                        print("Action button in buttons page clicked");
                        fileDialog.open()
                    }
                }
            }
        }

        Controls.TextField {
            id: songTitleField

            Layout.preferredWidth: 300
            Layout.fillWidth: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20

            placeholderText: "Song Title..."
            text: songTitle
            padding: 10
        }

        Rectangle {
            id: slideBar
            color: Kirigami.Theme.highlightColor

            Layout.preferredWidth: 400
            Layout.preferredHeight: songTitleField.height
            Layout.fillWidth: true
            Layout.rightMargin: 20
        }

        Controls.ScrollView {
            id: songLyricsField

            Layout.preferredHeight: 3000
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 20

            rightPadding: 20

            Controls.TextArea {
                width: parent.width

                placeholderText: "Put lyrics here..."
                persistentSelection: true
                text: songLyrics
                textFormat: TextEdit.MarkdownText
                padding: 10
                onEditingFinished: editorTimer.running = false
                onPressed: editorTimer.running = true
            }
        }

        Presenter.SlideEditor {
            id: slideEditor
            Layout.preferredHeight: 800
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.bottomMargin: 30
            Layout.rightMargin: 20
            Layout.rowSpan: 15
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
        }
    }

    Timer {
        id: editorTimer
        interval: 2000
        repeat: true
        running: false
        onTriggered: showPassiveNotification("updating song...")
    }
}
