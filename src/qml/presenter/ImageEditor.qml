import QtQuick 2.13
import QtQuick.Controls 2.15 as Controls
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

Item {
    id: root

    property string type: "image"
    property var image

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

                Controls.TextField {
                    id: imageTitleField

                    Layout.preferredWidth: 300

                    placeholderText: "Image Title..."
                    text: image.title
                    padding: 10
                    onEditingFinished: updateTitle(text);
                }

                Controls.ComboBox {
                    model: ["Fill", "Crop", "Height", "Width"]
                    implicitWidth: 100
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
                    text: "Select Image"
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
                            text: "Image"
                            icon.name: "emblem-images-symbolic"
                            onClicked: imageFileDialog.open() & backgroundType.close()
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

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            /* Layout.minimumWidth: 300 */
            Layout.alignment: Qt.AlignCenter
            Layout.columnSpan: 2
            spacing: 5

            Item {
                id: topEmpty
                Layout.preferredHeight: 30
            }

            Controls.Label {
                id: filePathLabel
                Layout.preferredWidth: 600
                Layout.alignment: Qt.AlignCenter
                text: image.filePath
            }

            Image {
                id: imagePreview
                Layout.preferredWidth: 600
                Layout.preferredHeight: Layout.preferredWidth / 16 * 9
                Layout.alignment: Qt.AlignCenter
                fillMode: Image.PreserveAspectFit
                source: image.filePath
            }
            Item {
                id: botEmpty
                Layout.fillHeight: true
            }

        }
    }

    function changeImage(index) {
        let img = imageProxyModel.getImage(index);
        root.image = img;
        console.log(img.filePath.toString());
    }

    function updateTitle(text) {
        changeTitle(text, false);
        imagesqlmodel.updateTitle(image.id, text);
        showPassiveNotification(image.title);
    }

    function changeTitle(text, updateBox) {
        if (updateBox)
            imageTitleField.text = text;
        image.title = text;
    }
}
