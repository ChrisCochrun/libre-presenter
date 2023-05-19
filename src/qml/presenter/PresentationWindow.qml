import QtQuick 2.15
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0

Item {
    id: presentationWindow

    property Item slide: presentationSlide
    /* property var slideObj */
    property var pWin
    anchors.fill: parent

    /* title: "presentation-window" */
    /* height: maximumHeight */
    /* width: maximumWidth */
    /* screen: presentationScreen */
    /* opacity: 1.0 */
    /* transientParent: null */
    /* modality: Qt.NonModal */
    /* flags: Qt.FramelessWindowHint */

    /* onClosing: { */
    /*     presentationSlide.stopVideo(); */
    /*     SlideObj.pause(); */
    /*     presentationSlide.stopAudio(); */
    /*     presenting = false; */
    /* } */

    Connections {
        target: PresWindow
        function onClosing() {
            presentationSlide.stopVideo();
            SlideObj.pause();
            presentationSlide.stopAudio();
            presenting = false;
        }
    }

    Component.onCompleted: {
        /* console.log(screen.name); */
        /* presentationWindow.showFullScreen(); */
    }

    Presenter.Slide {
        id: presentationSlide
        anchors.fill: parent
        imageSource: SlideObj.imageBackground
        webSource: SlideObj.html
        videoSource: presentationWindow.visible ? SlideObj.videoBackground : ""
        audioSource: SlideObj.audio
        text: SlideObj.text
        chosenFont: SlideObj.font
        textSize: SlideObj.fontSize
        pdfIndex: SlideObj.slideIndex
        itemType: SlideObj.ty
        vidLoop: SlideObj.looping
    }

    Connections {
        target: SlideObj
        function onVideoBackgroundChanged() {
            if (SlideObj.videoBackground === "")
                stopVideo();
            else {
                loadVideo();
                playVideo();
            }
        }
        function onIsPlayingChanged() {
            if(SlideObj.isPlaying)
                presentationSlide.playVideo();
            pauseVideo();
        }
        function onAudioChanged() {
            if (presentationWindow.visible)
                presentationSlide.playAudio();
            else
                presentationSlide.stopAudio();
        }
    }

    function loadVideo() {
        presentationSlide.loadVideo();
    }

    function stopVideo() {
        console.log("####I STOPPING####");
        presentationSlide.stopVideo()
    }

    function pauseVideo() {
        presentationSlide.pauseVideo();
    }

    function loopVideo() {
        presentationSlide.loopVideo();
    }
}
