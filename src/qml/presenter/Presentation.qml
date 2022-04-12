import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import QtAudioEngine 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

Item {
    id: root

    property var text
    property int textIndex: 0
    property string itemType
    property url imagebackground
    property url vidbackground

    Component.onCompleted: nextSlideAction()

    GridLayout {
        anchors.fill: parent
        columns: 3
        rowSpacing: 5
        columnSpacing: 0

        Controls.ToolBar {
            Layout.fillWidth: true
            Layout.columnSpan: 3
            id: toolbar
            RowLayout {
                anchors.fill: parent 

                Controls.ToolButton {
                    text: "Solo"
                    icon.name: "viewimage"
                    hoverEnabled: true
                }
                Controls.ToolButton {
                    text: "Grid"
                    icon.name: "view-app-grid-symbolic"
                    hoverEnabled: true
                }
                Controls.ToolButton {
                    text: "Details"
                    icon.name: "view-list-details"
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
            }
        }

        Item {
            /* Layout.preferredHeight: 200 */
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 3
        }

        Kirigami.Icon {
            source: "arrow-left"
            Layout.preferredWidth: 100
            Layout.preferredHeight: 200
            Layout.alignment: Qt.AlignRight
            MouseArea {
                anchors.fill: parent
                onPressed: previousSlideAction()
                cursorShape: Qt.PointingHandCursor
            }
        }

        Presenter.Slide {
            id: previewSlide
            Layout.preferredWidth: 700
            Layout.preferredHeight: width / 16 * 9
            Layout.minimumWidth: 300
            Layout.alignment: Qt.AlignCenter
            textSize: width / 15
            itemType: root.itemType
            imageSource: imagebackground
            videoSource: vidbackground
            preview: true 
        }

        Kirigami.Icon {
            source: "arrow-right"
            Layout.preferredWidth: 100
            Layout.preferredHeight: 200
            Layout.alignment: Qt.AlignLeft
            MouseArea {
                anchors.fill: parent
                onPressed: nextSlideAction()
                cursorShape: Qt.PointingHandCursor
            }
        }

        Item {
            /* Layout.preferredHeight: 200 */
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 3
        }

    }

    function loadVideo() {
        previewSlide.loadVideo();
    }

    function stopVideo() {
        previewSlide.stopVideo()
    }

    function nextSlideAction() {
        print(textIndex);
        if (itemType === "song") {
            if (textIndex === 0) {
                previewSlide.text = root.text[textIndex];
                print(root.text[textIndex]);
                textIndex++;
            } else if (textIndex < root.text.length) {
                previewSlide.text = root.text[textIndex];
                print(root.text[textIndex]);
                textIndex++;
            } else {
                print("Next slide time");
                textIndex = 0;
                clearText();
                nextSlide();
            }
        } else if (itemType === "video") {
            clearText();
            nextSlide();
        }
        else if (itemType === "image") {
            clearText();
            nextSlide();
        }
    }

    function nextSlide() {
        changeServiceItem(currentServiceItem++);
        print(slideItem);
    }

    function previousSlideAction() {
        print(textIndex);
        if (itemType === "song") {
            if (textIndex === 0) {
                clearText();
                nextSlide();
            } else if (textIndex <= root.text.length) {
                previewSlide.text = root.text[textIndex];
                print(root.text[textIndex]);
                --textIndex;
            }
        } else if (itemType === "video") {
            clearText();
            previousSlide();
        }
        else if (itemType === "image") {
            clearText();
            previousSlide();
        }
    }

    function previousSlide() {
        changeServiceItem(--currentServiceItem);
        print(slideItem);
    }

    function changeSlide() {
        if (itemType === "song") {
            previewSlide.text = root.text[textIndex];
            print(root.text[textIndex]);
            textIndex++;
        } else if (itemType === "video") {
            clearText();
        }
        else if (itemType === "image") {
            clearText();
        }
    }

    function clearText() {
        previewSlide.text = "";
    }
}
