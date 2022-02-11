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
        columns: 2
        rowSpacing: 5
        columnSpacing: 20

        Controls.ToolBar {
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
                Controls.ToolButton {
                    text: "Effects"
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
            implicitWidth: 300
            Layout.leftMargin: 20
            placeholderText: "Song Title..."
            text: songTitle
        }

        Rectangle {
            color: "red"
            implicitWidth: 400
            implicitHeight: 10
            Layout.rightMargin: 20
        }

        Controls.TextArea {
            implicitWidth: 300
            implicitHeight: 500
            Layout.bottomMargin: 30
            Layout.leftMargin: 20
            placeholderText: "Put lyrics here..."
            persistentSelection: true
            text: songLyrics
            textFormat: TextEdit.MarkdownText
        }

        Rectangle {
            color: "red"
            implicitWidth: 400
            implicitHeight: 500
            Layout.bottomMargin: 30
            Layout.rightMargin: 20
        }
    }
}
