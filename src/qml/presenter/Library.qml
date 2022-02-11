import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter

Item {
    id: root
    Presenter.PanelItem {
        anchors.fill: parent
        title: "Songs"

        ListView {
            anchors.fill: parent
            id: libraryListView
            model: _songListModel
            delegate: itemDelegate

            Component {
                id: itemDelegate
                Kirigami.BasicListItem {
                    width: ListView.view.width
                    height:40
                    label: title
                    subtitle: author
                    hoverEnabled: true
                    onClicked: {
                        ListView.view.currentIndex = index
                        songTitle = title
                        songLyrics = lyrics
                        songAuthor = author
                        showPassiveNotification(songLyrics, 3000)
                    }
                }
            }

            Kirigami.WheelHandler {
                id: wheelHandler
                target: libraryListView
                filterMouseEvents: true
                keyNavigationEnabled: true
            }

            Controls.ScrollBar.vertical: Controls.ScrollBar {
                anchors.right: libraryListView.right
                anchors.leftMargin: 10
                active: hovered || pressed
            }
        }
    }
}
