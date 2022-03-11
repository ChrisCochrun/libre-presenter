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
                    anchors.centerIn: parent
                    width: parent.width / 3
                    onAccepted: showPassiveNotification(searchField.text, 3000)
                }
            }
        },

        Kirigami.Action {
            icon.name: editMode ? "view-preview" : "edit"
            text: editMode ? "Preview" : "Edit"
            onTriggered: toggleEditMode()
        },
        
        Kirigami.Action {
            icon.name: "view-presentation"
            text: presenting ? "Presenting" : "Go Live" 
            onTriggered: {
                print("Window is loading")
                presenting = true
            }
        },

        Kirigami.Action {
            icon.name: libraryOpen ? "sidebar-collapse-right" : "sidebar-expand-right"
            text: libraryOpen ? "Close Library" : "Open Library"
            onTriggered: toggleLibrary()
        }

    ]
}
