import QtQuick 2.15
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
                    onClicked: fileDialog.open()
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

            Controls.TextArea {
                id: filePathLabel
                Layout.alignment: Qt.AlignBottom
                Layout.fillWidth: true
                text: image.filePath
                background: Item{}
                readOnly: true
                HoverHandler {
                    id: hoverHandler
                    enabled: false
                    cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.IBeamCursor
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a background"
        folder: shortcuts.home
        selectMultiple: false
        nameFilters: ["Image files (*.jpg *.jpeg *.png *.JPG *.JPEG *.PNG *.webp *.gif)", "All files (*)"]
        onAccepted: {
            updateImage(fileDialog.fileUrls[0]);
            console.log("image background = " + fileDialog.fileUrls[0]);
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    function changeImage(index) {
        let img = imageProxyModel.getImage(index);
        root.image = img;
        console.log(img.filePath.toString());
    }

    function updateTitle(text) {
        changeTitle(text, false);
        imageProxyModel.imageModel.updateTitle(root.image.id, text);
        showPassiveNotification(root.image.title);
    }

    function changeTitle(text, updateBox) {
        if (updateBox)
            imageTitleField.text = text;
        image.title = text;
    }

    function updateImage(image) {
        imageProxyModel.imageModel.updateFilePath(root.image.id, image);
        root.image.filePath = image;
        console.log(image);
    }
}
