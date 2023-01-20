import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0

Item {
    id: root
    // Lets set the outerModelData so we can access that data here.

    implicitHeight: Kirigami.Units.gridUnit * 6.5
    implicitWidth: Kirigami.Units.gridUnit * 10
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
            textSize: width / 4
            itemType: type
            imageSource: imageBackground
            videoSource: videoBackground
            audioSource: ""
            chosenFont: font
            text: text
            pdfIndex: slideIndex
            preview: true
            editMode: true

        }
    }

    Controls.Label {
        id: slidesTitle
        width: parent.width * 7
        anchors.top: previewHighlight.bottom
        /* anchors.leftMargin: Kirigami.Units.smallSpacing * 8 */
        anchors.topMargin: 5
        elide: Text.ElideRight
        text: ServiceItemModel.getItem(serviceItemId).name
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
        target: SlideModel
        onDataChanged: if (active)
            previewSlidesList.positionViewAtIndex(index, ListView.Contain)
    }

    function changeSlideAndIndex(serviceItem, index) {
        // TODO
        console.log("Item: " + serviceItem.index + " is " + serviceItem.active);
        if (!serviceItem.active) {
            changeServiceItem(serviceItem.index)
            previewSlidesList.currentIndex = serviceItem.index;
        }
        console.log("Slide Index is: " + index);
        if (outerModelData.slideNumber === 0)
            return;
        SlideObject.changeSlideIndex(index);
        console.log("New slide index is: " + SlideObject.slideIndex);
    }
}
