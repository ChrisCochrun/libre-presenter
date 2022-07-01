import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0

Window {
    id: presentationWindow
    title: "presentation-window"
    height: maximumHeight
    width: maximumWidth
    screen: presentationScreen
    /* flags: Qt.X11BypassWindowManagerHint */
    onClosing: presenting = false

    Component.onCompleted: {
        presentationWindow.showFullScreen();
        print(screen.name);
    }

    Presenter.Slide {
        id: presentationSlide
        anchors.fill: parent
        imageSource: imageBackground
        videoSource: videoBackground
        text: ""

        Component.onCompleted: slideItem = presentationSlide
    }
}