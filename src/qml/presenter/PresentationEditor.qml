import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

Item {
    id: root

    property string type: "presentation"
    property var presentation

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
                    /* onCurrentTextChanged: showPassiveNotification(currentText) */
                }
                Controls.SpinBox {
                    editable: true
                    from: 5
                    to: 72
                    hoverEnabled: true
                }
                Controls.ComboBox {
                    model: ["PRESENTATIONS", "Center", "Right", "Justify"]
                    implicitWidth: 100
                    hoverEnabled: true
                }
                Controls.ToolSeparator {}
                Item { Layout.fillWidth: true }
                Controls.ToolSeparator {}
                Controls.ToolButton {
                    text: "Effects"
                    icon.name: "presentation-auto-adjust"
                    hoverEnabled: true
                    onClicked: {}
                }
                Controls.ToolButton {
                    id: backgroundButton
                    text: "Select Presentation"
                    icon.name: "fileopen"
                    hoverEnabled: true
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
                    closePolicy: Controls.Popup.CloseOnEscape | Controls.Popup.CloseOnPressOutsideParent
                    ColumnLayout {
                        anchors.fill: parent
                        Controls.ToolButton {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: "Presentation"
                            icon.name: "emblem-presentations-symbolic"
                            onClicked: presentationFileDialog.open() & backgroundType.close()
                        }
                        Controls.ToolButton {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            text: "Presentation"
                            icon.name: "folder-pictures-symbolic"
                            onClicked: presentationFileDialog.open() & backgroundType.close()
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
                Controls.SplitView.preferredWidth: 300
                Controls.SplitView.minimumWidth: 100

                Controls.TextField {
                    id: presentationTitleField

                    Layout.preferredWidth: 300
                    Layout.fillWidth: true
                    Layout.leftMargin: 20
                    Layout.rightMargin: 20

                    placeholderText: "Title..."
                    text: presentation.title
                    padding: 10
                    /* onEditingFinished: updateTitle(text); */
                }

                Item {
                    id: empty
                    Layout.fillHeight: true
                }
            }
            ColumnLayout {
                Controls.SplitView.fillHeight: true
                Controls.SplitView.preferredWidth: 700
                Controls.SplitView.minimumWidth: 300
                spacing: 5

                Item {
                    id: topEmpty
                    Layout.fillHeight: true
                }

                Image {
                    id: presentationPreview
                    Layout.preferredWidth: 600
                    Layout.preferredHeight: Layout.preferredWidth / 16 * 9
                    Layout.alignment: Qt.AlignCenter
                    fillMode: Image.PreserveAspectFit
                    source: presentation.filePath
                }
                RowLayout {
                    Layout.fillWidth: true;
                    Layout.alignment: Qt.AlignCenter
                    Layout.leftMargin: 50
                    Layout.rightMargin: 50
                    Controls.ToolButton {
                        id: leftArrow
                        text: "Back"
                        icon.name: "back"
                        onClicked: presentationPreview.currentFrame = presentationPreview.currentFrame - 1
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Controls.ToolButton {
                        id: rightArrow
                        text: "Next"
                        icon.name: "next"
                        onClicked: presentationPreview.currentFrame = presentationPreview.currentFrame + 1
                    }
                }
                Item {
                    id: botEmpty
                    Layout.fillHeight: true
                }

            }
        }
    }

    function changePresentation(presentation) {
        root.presentation = presentation;
        print(presentation.filePath.toString());
    }
}
