import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0

Item {
    id: root
    implicitHeight: Kirigami.Units.gridUnit * 6.5
    implicitWidth: Kirigami.Units.gridUnit * 10
    property bool showVidBG
    Rectangle {
        id: previewHighlight
        anchors.centerIn: parent
        width: parent.width
        height: parent.height - slidesTitle.height - 5
        border.color: Kirigami.Theme.highlightColor
        radius: 5
        color: {
            if (active || previewerMouse.containsMouse)
                Kirigami.Theme.highlightColor
            else
                Kirigami.Theme.backgroundColor
        }

        Presenter.Slide {
            id: previewSlideItem
            anchors.centerIn: parent
            implicitWidth: height / 9 * 16
            implicitHeight: parent.height - Kirigami.Units.smallSpacing * 2
            textSize: model.fontSize
            itemType: model.type
            imageSource: model.imageBackground
            videoSource: showVidBG ? model.videoBackground : ""
            audioSource: ""
            chosenFont: model.font
            text: model.text
            pdfIndex: slideIndex
            preview: true
            editMode: true

        }
    }

    Controls.Label {
        id: slidesTitle
        width: previewHighlight.width
        anchors.top: previewHighlight.bottom
        /* anchors.leftMargin: Kirigami.Units.smallSpacing * 8 */
        anchors.topMargin: Kirigami.Units.smallSpacing * 3
        elide: Text.ElideRight
        text: serviceItemId //ServiceItemModel.getItem(serviceItemId).name
        /* font.family: "Quicksand Bold" */
    }

    MouseArea {
        id: previewerMouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            changeSlide(index);
        }
        cursorShape: Qt.PointingHandCursor
        propagateComposedEvents: true
    }


    Connections {
        target: SlideModel
        onDataChanged: {
            if (active) {
                previewSlidesList.currentIndex = index;
                previewSlidesList.positionViewAtIndex(index, ListView.Contain);
            }
        }
    }
}
