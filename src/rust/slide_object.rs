#[cxx_qt::bridge]
mod slide_object {
    // use cxx_qt_lib::QVariantValue;
    use std::path::Path;

    unsafe extern "C++" {
        // include!("cxx-qt-lib/qstring.h");
        // type QString = cxx_qt_lib::QString;
        // include!("cxx-qt-lib/qurl.h");
        // type QUrl = cxx_qt_lib::QUrl;
        include!("cxx-qt-lib/qvariant.h");
        type QVariant = cxx_qt_lib::QVariant;
    }

    pub trait Slide {
        fn set_text(text: String) -> bool;
        fn set_type(ty: String) -> bool;
        fn set_audio(audio: String) -> bool;
        fn set_image_background(ib: String) -> bool;
        fn set_video_background(vb: String) -> bool;
        fn set_vtext_align(vta: String) -> bool;
        fn set_htext_align(hta: String) -> bool;
        fn set_font(font: String) -> bool;
        fn set_font_size(font_size: i32) -> bool;
        fn set_looping(lp: bool) -> bool;
    }

    #[derive(Clone)]
    #[cxx_qt::qobject]
    pub struct SlideObject {
        #[qproperty]
        slide_index: i32,
        #[qproperty]
        slide_size: i32,
        #[qproperty]
        is_playing: bool,
        #[qproperty]
        looping: bool,
        #[qproperty]
        text: QString,
        #[qproperty]
        ty: QString,
        #[qproperty]
        audio: QString,
        #[qproperty]
        image_background: QString,
        #[qproperty]
        video_background: QString,
        #[qproperty]
        vtext_alignment: QString,
        #[qproperty]
        htext_alignment: QString,
        #[qproperty]
        font: QString,
        #[qproperty]
        font_size: i32,
    }

    impl Default for SlideObject {
        fn default() -> Self {
            Self {
                slide_index: 0,
                slide_size: 0,
                is_playing: false,
                looping: false,
            }
        }
    }

    impl Slide for SlideObject {
        fn set_text(&self, text: String) -> bool {
            text = QString::from(text);
            true
        }
    }

    impl qobject::SlideObject {
        #[qinvokable]
        pub fn load(self: Pin<&mut Self>, file: i32) -> Vec<String> {
            println!("{file}");
            vec!["hi".to_string()]
        }

        #[qinvokable]
        pub fn change_slide(self: Pin<&mut Self>, item: QMapPair_QString_QVariant, index: i32) {
            if item.get("text").to_string() != text {
                set_text(item.get("text").to_string());
            };
            let file_string = file.to_string();
            let _file_string = file_string.strip_prefix("file://");
            match _file_string {
                None => {
                    let _exists = Path::new(&file.to_string()).exists();
                    println!("{file} exists? {_exists}");
                    _exists
                }
                Some(file) => {
                    let _exists = Path::new(&file).exists();
                    println!("{file} exists? {_exists}");
                    _exists
                }
            }
        }
    }
}
