import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0

Item {
    id: root
    // Lets set the outerModelData so we can access that data here.
    property var outerModelData: model;

    implicitHeight: Kirigami.Units.gridUnit * 6.25
    implicitWidth: {
        let slides = outerModelData.slideNumber === 0 ? 1 : outerModelData.slideNumber
        return Kirigami.Units.gridUnit * 10 * slides + Kirigami.Units.smallSpacing * 2;
    }

    Rectangle {
        id: previewHighlight
        width: parent.width
        height: parent.height
        border.color: Kirigami.Theme.highlightColor
        radius: 5
        color: {
            if (active || previewerMouse.containsMouse)
                Kirigami.Theme.highlightColor
            else
                Kirigami.Theme.backgroundColor
        }

        Row {
            id: slidesList
            spacing: Kirigami.Units.smallSpacing * 2
            anchors.fill: parent
            padding: Kirigami.Units.smallSpacing * 2
            Repeater {
                id: slidesListRepeater
                model: outerModelData.slideNumber === 0 ? 1 : outerModelData.slideNumber
                Component.onCompleted: {
                    if (name === "Death Was Arrested") {
                        showPassiveNotification("Number of slides: " + outerModelData.slideNumber);
                        showPassiveNotification("model number: " + model);
                    }
                }
                /* Rectangle { width: 20; height: 20; radius: 10; color: "green" } */
                Presenter.Slide {
                    id: previewSlideItem
                    implicitWidth: Kirigami.Units.gridUnit * 10 - Kirigami.Units.smallSpacing * 2
                    implicitHeight: width / 16 * 9
                    textSize: width / 4
                    itemType: outerModelData.type
                    imageSource: outerModelData.backgroundType === "image" ? background : ""
                    videoSource: outerModelData.backgroundType === "video" ? background : ""
                    audioSource: ""
                    chosenFont: outerModelData.font
                    text: outerModelData.text[index] === "This is demo text" ? "" : outerModelData.text[index]
                    pdfIndex: outerModelData.type != "presentation" ? 0 : index
                    preview: true
                    editMode: true
                    /* Component.onCompleted: { */
                    /*     if (outerModelData.name === "Death Was Arrested") { */
                    /*         showPassiveNotification("Index of slide: " + index); */
                    /*         showPassiveNotification("width: " + width) */
                    /*     } */
                    /* } */

                    MouseArea {
                        id: innerMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: changeServiceItem(outerModelData.index)
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }

        Controls.Label {
            id: slidesTitle
            width: parent.width * 7
            anchors.top: slidesList.bottom
            anchors.leftMargin: Kirigami.Units.smallSpacing * 8
            anchors.topMargin: 5
            elide: Text.ElideRight
            text: name + " " + slidesListRepeater.model
            /* font.family: "Quicksand Bold" */
        }

        MouseArea {
            id: previewerMouse
            anchors.fill: parent
            hoverEnabled: true
            /* onClicked: changeServiceItem(index) */
            cursorShape: Qt.PointingHandCursor
            propagateComposedEvents: true
        }


        Connections {
            target: serviceItemModel
            onDataChanged: if (active)
                previewSlidesList.positionViewAtIndex(index, ListView.Center)
        }
    }
}
