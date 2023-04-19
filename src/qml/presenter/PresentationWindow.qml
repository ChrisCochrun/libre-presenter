import QtQuick 2.15
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0

Window {
    id: presentationWindow

    property Item slide: presentationSlide

    title: "presentation-window"
    height: maximumHeight
    width: maximumWidth
    screen: presentationScreen
    opacity: 1.0
    /* transientParent: null */
    /* modality: Qt.NonModal */
    flags: Qt.FramelessWindowHint
    onClosing: {
        presentationSlide.stopVideo();
        SlideObject.pause();
        presentationSlide.stopAudio();
        presenting = false;
    }

    Component.onCompleted: {
        console.log(screen.name);
    }

    Presenter.Slide {
        id: presentationSlide
        anchors.fill: parent
        imageSource: SlideObject.imageBackground
        videoSource: presentationWindow.visible ? SlideObject.videoBackground : ""
        audioSource: SlideObject.audio
        text: SlideObject.text
        chosenFont: SlideObject.font
        textSize: SlideObject.fontSize
        pdfIndex: SlideObject.pdfIndex
        itemType: SlideObject.ty
        vidLoop: SlideObject.looping
    }

    Connections {
        target: SlideObject
        function onVideoBackgroundChanged() {
            if (SlideObject.videoBackground === "")
                stopVideo();
            else {
                loadVideo();
                playVideo();
            }
        }
        function onIsPlayingChanged() {
            if(SlideObject.isPlaying)
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
