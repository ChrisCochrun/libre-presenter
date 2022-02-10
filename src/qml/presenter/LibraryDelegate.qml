import QtQuick 2.13
import org.kde.kirigami 2.13 as Kirigami

Kirigami.BasicListItem {
    width: ListView.view.width
    height:20
    label: model.itemName
    subtitle: model.type
    hoverEnabled: true
    onClicked: ListView.view.currentIndex = index
}
