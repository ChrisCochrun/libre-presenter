import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import QtQuick.Window 2.13
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0

Controls.Page {
    id: mainPage
    padding: 0

    // properties passed around for the slides
    property url imageBackground: ""
    property url videoBackground: ""
    property string songTitle: ""
    property string songLyrics: ""
    property string songAuthor: ""
    property string songVorder: ""
    property int blurRadius: 0

    /* property var video */

    property string dragSongTitle: ""

    property bool editing: true

    property Item slideItem
    property var song
    property var draggedLibraryItem

    property Item editStackItem

    Item {
        id: mainItem
        anchors.fill: parent

        Controls.SplitView {
            id: splitMainView
            anchors.fill: parent
            handle: Item{
                implicitWidth: 6
                Rectangle {
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 1
                    color: Controls.SplitHandle.hovered ? Kirigami.Theme.hoverColor : Kirigami.Theme.backgroundColor
                }
            }

            Presenter.LeftDock {
                id: leftDock
                Controls.SplitView.fillHeight: true
                Controls.SplitView.preferredWidth: 200
                Controls.SplitView.maximumWidth: 300
            }
            
            Item {
                id: mainPageArea
                Controls.SplitView.fillHeight: true
                Controls.SplitView.fillWidth: true
                Controls.SplitView.preferredWidth: 500
                Controls.SplitView.minimumWidth: 200
                
                Presenter.Presentation { 
                  id: presentation
                  anchors.fill: parent
                }
                Presenter.SongEditor {
                  id: songEditor
                  visible: false
                  anchors.fill: parent
                }
                
                Presenter.VideoEditor {
                  id: videoEditor
                  visible: false
                  anchors.fill: parent
                }
            }

            Presenter.Library {
                id: library
                Controls.SplitView.fillHeight: true
                Controls.SplitView.preferredWidth: libraryOpen ? 200 : 0
                Controls.SplitView.maximumWidth: 350
            }
 
        }
    }

    Loader {
        id: presentLoader
        active: presenting
        sourceComponent: presentWindowComp
    }

    Component {
        id: presentWindowComp
        Window {
            id: presentationWindow
            title: "presentation-window"
            height: maximumHeight
            width: maximumWidth
            screen: presentationScreen
            flags: Qt.X11BypassWindowManagerHint
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
    }

    FileDialog {
        id: videoFileDialog
        title: "Please choose a background"
        folder: shortcuts.home
        selectMultiple: false
        nameFilters: ["Video files (*.mp4 *.mkv *.mov *.wmv *.avi *.MP4 *.MOV *.MKV)"]
        onAccepted: {
            imageBackground = ""
            videoBackground = videoFileDialog.fileUrls[0]
            print("video background = " + videoFileDialog.fileUrl)
        }
        onRejected: {
            print("Canceled")
            /* Qt.quit() */
        }

    }

    FileDialog {
        id: imageFileDialog
        title: "Please choose a background"
        folder: shortcuts.home
        selectMultiple: false
        nameFilters: ["Image files (*.jpg *.jpeg *.png *.JPG *.JPEG *.PNG)"]
        onAccepted: {
            videoBackground = ""
            imageBackground = imageFileDialog.fileUrls[0]
        }
        onRejected: {
            print("Canceled")
            /* Qt.quit() */
        }

    }

    SongSqlModel {
        id: songsqlmodel
    }

    VideoSqlModel {
        id: videosqlmodel
    }

    function changeSlideType(type) {
        /* showPassiveNotification("used to be: " + presentation.text); */
        presentation.itemType = type;
        /* showPassiveNotification("next"); */
        if (slideItem)
            slideItem.itemType = type;
        /* showPassiveNotification("last"); */
    }

    function changeSlideText(text) {
        /* showPassiveNotification("used to be: " + presentation.text); */
        presentation.text = text;
        /* showPassiveNotification("next"); */
        if (slideItem)
            slideItem.text = text;
        /* showPassiveNotification("last"); */
    }

    function changeSlideBackground(background, type) {
        showPassiveNotification("starting background change..");
        showPassiveNotification(background);
        showPassiveNotification(type);
        if (type == "image") {
            presentation.vidbackground = "";
            presentation.imagebackground = background;
            if (slideItem) {
                slideItem.videoSource = "";
                slideItem.stopVideo();
                slideItem.imageSource = background;
            }
        } else {
            presentation.imagebackground = "";
            presentation.vidbackground = background;
            presentation.loadVideo()
            if (slideItem) {
                slideItem.imageSource = "";
                slideItem.videoSource = background;
                slideItem.loadVideo()
            }
        }
    }

    function changeSlideNext() {
        showPassiveNotification("next slide please")
    }

    function changeSlidePrevious() {
        showPassiveNotification("previous slide please")
    }

    function editSwitch(editType, item) {
        if (editMode) {
            switch (editType) {
            case "song" :
                presentation.visible = false;
                videoEditor.visible = false;
                songEditor.visible = true;
                break;
            case "video" :
                presentation.visible = false;
                songEditor.visible = false;
                videoEditor.visible = true;
                break;
            case "image" :
                mainPageArea.pop(Controls.StackView.Immediate);
                mainPageArea.push(imageEditorComp, Controls.StackView.Immediate);
                break;
            default:
videoEditor
            }
        } else {
              videoEditor.visible = false;
              songEditor.visible = false;
              presentation.visible = true;
              editMode = false;
        }
    }

    function present(present) {
        if (present)
            presentationWindow.showFullScreen();
        else
            presentationWindow.close();
    }

    function updateLyrics(lyrics) {
        songsqlmodel.updateLyrics(song, lyrics);
    }

    function updateTitle(title) {
        songsqlmodel.updateTitle(song, title)
    }

    function updateAuthor(author) {
        songsqlmodel.updateAuthor(song, author)
    }

    function updateAudio(audio) {
        songsqlmodel.updateAudio(song, audio)
    }

    function updateCcli(ccli) {
        songsqlmodel.updateCcli(song, ccli)
    }

    function updateVerseOrder(vorder) {
        songsqlmodel.updateVerseOrder(song, vorder)
    }
}
