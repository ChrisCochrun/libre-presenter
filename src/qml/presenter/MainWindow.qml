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
    property int currentServiceItem
    property url imageBackground: presentation.imageBackground
    property url videoBackground: presentation.vidBackground
    property string currentText: presentation.text
    property int blurRadius: 0

    /* property var video */

    property int dragItemIndex
    property string dragItemTitle: ""
    property string dragItemType: ""
    property string dragItemText: ""
    property string dragItemBackgroundType: ""
    property string dragItemBackground: ""

    property bool editing: true

    property Item slideItem
    property var song
    property var draggedLibraryItem

    property string editType

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
                Controls.SplitView.preferredWidth: 200
                Controls.SplitView.maximumWidth: 300
            }
            
            Item {
                id: mainPageArea
                Controls.SplitView.fillWidth: true
                Controls.SplitView.minimumWidth: 100
                
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

                Presenter.ImageEditor {
                    id: imageEditor
                    visible: false
                    anchors.fill: parent
                }
            }

            Presenter.Library {
                id: library
                Controls.SplitView.preferredWidth: libraryOpen ? 200 : 0
                Controls.SplitView.maximumWidth: 350
            }
 
        }
    }

    Loader {
        id: presentLoader
        active: presenting
        source: "PresentationWindow.qml"
    }

    SongSqlModel {
        id: songsqlmodel
    }

    VideoSqlModel {
        id: videosqlmodel
    }

    ImageSqlModel {
        id: imagesqlmodel
    }

    ServiceItemModel {
        id: serviceItemModel
    }

    function changeServiceItem(index) {
        const item = serviceItemModel.getItem(index);
        print("index grabbed: " + index);


        presentation.stopVideo()
        presentation.itemType = item.type;
        print("Time to start changing");
        
        if (item.backgroundType === "image") {
            print("The slides backgorund is: " + SlideObject.imageBackground);
            SlideObject.setVideoBackground("");
            SlideObject.setImageBackground(item.background);
        } else {
            print("The slides backgorund is: " + SlideObject.videoBackground);
            SlideObject.setImageBackground("");
            SlideObject.setVideoBackground(item.background);
            presentation.loadVideo()
        }

        print("text length: " + item.text.length);
        print("text: " + item.text);
        if (item.text.length === 0) {
            SlideObject.setText("");
        }
        else
            SlideObject.setText(item.text[0]);
        presentation.textIndex = 0;
        presentation.changeSlide();

        print("Slide changed to: " + item.name);
    }

    function editSwitch(item) {
        if (editMode) {
            switch (editType) {
            case "song" :
                presentation.visible = false;
                videoEditor.visible = false;
                videoEditor.stop();
                imageEditor.visible = false;
                songEditor.visible = true;
                songEditor.changeSong(item);
                break;
            case "video" :
                presentation.visible = false;
                songEditor.visible = false;
                imageEditor.visible = false;
                videoEditor.visible = true;
                videoEditor.changeVideo(item);
                break;
            case "image" :
                presentation.visible = false;
                videoEditor.visible = false;
                videoEditor.stop();
                songEditor.visible = false;
                imageEditor.visible = true;
                imageEditor.changeImage(item);
                break;
            default:
                videoEditor.visible = false;
                videoEditor.stop();
                songEditor.visible = false;
                imageEditor.visible = false;
                presentation.visible = true;
                editMode = false;
            }
        } else {
            videoEditor.visible = false;
            videoEditor.stop();
            songEditor.visible = false;
            imageEditor.visible = false;
            presentation.visible = true;
            editMode = false;
            presenting = true;
        }
    }

    function present(present) {
        if (present)
            presentationWindow.showFullScreen();
        else
            presentationWindow.close();
    }
}
