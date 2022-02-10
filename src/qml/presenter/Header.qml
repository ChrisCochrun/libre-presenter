import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami

Kirigami.ActionToolBar {
    id: root
    alignment: Qt.AlignRight

    Kirigami.Heading {
        text: "Presenter"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
    }

    actions: [

        Kirigami.Action {
            displayComponent: Component {
                Kirigami.SearchField {
                    id: searchField
                    onAccepted: showPassiveNotification(searchField.text, 3000)
                }
            }
        },

        Kirigami.Action {
            icon.name: "fileopen"
            text: "VideoBG"
            onTriggered: {
                print("Action button in buttons page clicked");
                fileDialog.open()
            }
        },
        Kirigami.Action {
            icon.name: "view-presentation"
            text: "Go Live"
            onTriggered: {
                print("Window is loading")
                presentLoader.active = true
            }
        },

        Kirigami.Action {
            icon.name: "sidebar-collapse-right"
            text: "Close Library"
            onTriggered: toggleLibrary()
        }

    ]
}
