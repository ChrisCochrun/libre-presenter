import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.0 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import QtMultimedia 5.15
import QtAudioEngine 1.15
import org.kde.kirigami 2.13 as Kirigami

ColumnLayout {
    id: root

    Rectangle {
        id: headerBackground
        color: Kirigami.Theme.backgroundColor
        height: 40
        opacity: 1.0
        Layout.fillWidth: true

        Kirigami.Heading {
            id: serviceTitle
            text: "Service List"
            anchors.centerIn: headerBackground 
            padding: 5
            level: 3
        }
    }

    ListView {
        id: serviceItemList
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: listModel
        delegate: itemDelegate
        clip: true
        spacing: 2
        
        Component {
            id: itemDelegate
            Kirigami.BasicListItem {
                width: serviceItemList.width
                height:50
                label: itemName
                subtitle: type
                hoverEnabled: true
                onClicked: serviceItemList.currentIndex = index

            }
        }

        Kirigami.WheelHandler {
            id: wheelHandler
            target: serviceItemList
            filterMouseEvents: true
            keyNavigationEnabled: true
        }

        Controls.ScrollBar.vertical: Controls.ScrollBar {
            anchors.right: serviceItemList.right
            anchors.leftMargin: 10
            active: hovered || pressed
        }
        ListModel {
            id: listModel
            ListElement {
                itemName: "10,000 Reason"
                type: "song"
            }
            ListElement {
                itemName: "Marvelous Light"
                type: "song"
            }
            ListElement {
                itemName: "10 reason to use church presenter"
                type: "video"
            }
            ListElement {
                itemName: "10,000 Reason"
                type: "song"
            }
            ListElement {
                itemName: "Marvelous Light"
                type: "song"
            }
            ListElement {
                itemName: "10 reason to use church presenter"
                type: "video"
            }
            ListElement {
                itemName: "10,000 Reason"
                type: "song"
            }
            ListElement {
                itemName: "Marvelous Light"
                type: "song"
            }
            ListElement {
                itemName: "10 reason to use church presenter"
                type: "video"
            }
            ListElement {
                itemName: "10,000 Reason"
                type: "song"
            }
            ListElement {
                itemName: "Marvelous Light"
                type: "song"
            }
            ListElement {
                itemName: "10 reason to use church presenter"
                type: "video"
            }
            ListElement {
                itemName: "10,000 Reason"
                type: "song"
            }
            ListElement {
                itemName: "Marvelous Light"
                type: "song"
            }
            ListElement {
                itemName: "10 reason to use church presenter"
                type: "video"
            }
            ListElement {
                itemName: "10,000 Reason"
                type: "song"
            }
             ListElement {
                 itemName: "Marvelous Light"
                 type: "song"
             }
             ListElement {
                 itemName: "10 reason to use church presenter"
                 type: "video"
             }
         }
     }
}

