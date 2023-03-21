#[cxx_qt::bridge]
mod slide_obj {
    // use cxx_qt_lib::QVariantValue;
    // use std::path::Path;

    unsafe extern "C++" {
        include!("cxx-qt-lib/qstring.h");
        type QString = cxx_qt_lib::QString;
        include!("cxx-qt-lib/qmap.h");
        type QMap_QString_QVariant = cxx_qt_lib::QMap<cxx_qt_lib::QMapPair_QString_QVariant>;
        include!("cxx-qt-lib/qvariant.h");
        type QVariant = cxx_qt_lib::QVariant;
    }

    // pub trait Slide {
    //     fn set_text(text: String) -> bool;
    //     fn set_type(ty: String) -> bool;
    //     fn set_audio(audio: String) -> bool;
    //     fn set_image_background(ib: String) -> bool;
    //     fn set_video_background(vb: String) -> bool;
    //     fn set_vtext_align(vta: String) -> bool;
    //     fn set_htext_align(hta: String) -> bool;
    //     fn set_font(font: String) -> bool;
    //     fn set_font_size(font_size: i32) -> bool;
    //     fn set_looping(lp: bool) -> bool;
    // }

    #[cxx_qt::qsignals(SlideObj)]
    pub enum Signals<'a> {
        PlayingChanged { isPlaying: &'a bool },
        SlideIndexChanged { slideIndex: &'a i32 },
        SlideSizeChanged { slideSize: &'a i32 },
        SlideChanged { slide: &'a i32 },
        LoopChanged { looping: &'a bool },
    }

    #[derive(Clone)]
    #[cxx_qt::qobject]
    pub struct SlideObj {
        #[qproperty]
        slide_index: i32,
        #[qproperty]
        slide_size: i32,
        #[qproperty]
        image_count: i32,
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

    impl Default for SlideObj {
        fn default() -> Self {
            Self {
                slide_index: 0,
                slide_size: 0,
                is_playing: false,
                looping: false,
                text: QString::from(""),
                ty: QString::from(""),
                audio: QString::from(""),
                image_background: QString::from(""),
                video_background: QString::from(""),
                vtext_alignment: QString::from(""),
                htext_alignment: QString::from(""),
                font: QString::from(""),
                font_size: 50,
                image_count: 0,
            }
        }
    }

    // impl Slide for SlideObj {
    //     fn set_text(&self, text: String) -> bool {
    //         text = QString::from(text);
    //         true
    //     }
    // }

    impl qobject::SlideObj {
        // #[qinvokable]
        // pub fn load(self: Pin<&mut Self>, file: i32) -> Vec<String> {
        //     println!("{file}");
        //     vec!["hi".to_string()]
        // }

        #[qinvokable]
        pub fn change_slide(mut self: Pin<&mut Self>, item: QMap_QString_QVariant, index: i32) {
            let text = item.get(&QString::from("text")).unwrap();
            if let Some(txt) = text.value::<QString>() {
                if &txt != self.as_ref().text() {
                    self.as_mut().set_text(txt);
                };
            }
            let audio = item.get(&QString::from("audio")).unwrap();
            if let Some(audio) = audio.value::<QString>() {
                if &audio != self.as_ref().audio() {
                    self.as_mut().set_audio(audio);
                }
            }
            let ty = item.get(&QString::from("ty")).unwrap();
            if let Some(ty) = ty.value::<QString>() {
                if &ty != self.as_ref().ty() {
                    self.as_mut().set_ty(ty);
                }
            }
            let image_background = item.get(&QString::from("image_background")).unwrap();
            if let Some(image_background) = image_background.value::<QString>() {
                if &image_background != self.as_ref().image_background() {
                    self.as_mut().set_image_background(image_background);
                }
            }
            let video_background = item
                .get(&QString::from("video_background"))
                .unwrap_or(QVariant::from(&QString::from("")));
            if let Some(video_background) = video_background.value::<QString>() {
                if &video_background != self.as_ref().video_background() {
                    self.as_mut().set_video_background(video_background);
                }
            }
            let font = item
                .get(&QString::from("font"))
                .unwrap_or(QVariant::from(&QString::from("Quicksand")));
            if let Some(font) = font.value::<QString>() {
                if &font != self.as_ref().font() {
                    self.as_mut().set_font(font);
                }
            }
            let vtext_alignment = item.get(&QString::from("vtext_alignment")).unwrap();
            if let Some(vtext_alignment) = vtext_alignment.value::<QString>() {
                if &vtext_alignment != self.as_ref().vtext_alignment() {
                    self.as_mut().set_vtext_alignment(vtext_alignment);
                }
            }
            let htext_alignment = item.get(&QString::from("htext_alignment")).unwrap();
            if let Some(htext_alignment) = htext_alignment.value::<QString>() {
                if &htext_alignment != self.as_ref().htext_alignment() {
                    self.as_mut().set_htext_alignment(htext_alignment);
                }
            }
            let font_size = item.get(&QString::from("font_size")).unwrap();
            if let Some(font_size) = font_size.value::<i32>() {
                if &font_size != self.as_ref().font_size() {
                    self.as_mut().set_font_size(font_size);
                }
            }
            let looping = item.get(&QString::from("looping")).unwrap();
            if let Some(looping) = looping.value::<bool>() {
                if &looping != self.as_ref().looping() {
                    self.as_mut().set_looping(looping);
                    let lp = looping;
                    self.as_mut().emit(Signals::LoopChanged { looping: &lp });
                }
            }
            let slide_size = item.get(&QString::from("slide_size")).unwrap();
            if let Some(slide_size) = slide_size.value::<i32>() {
                if &slide_size != self.as_ref().slide_size() {
                    self.as_mut().set_slide_size(slide_size);
                }
            }
            let icount = item.get(&QString::from("imageCount")).unwrap();
            if let Some(int) = icount.value::<i32>() {
                self.as_mut().set_image_count(int);
            }
            let slindex = item.get(&QString::from("slide_index")).unwrap();
            if let Some(int) = slindex.value::<i32>() {
                self.as_mut().set_slide_index(int);
                let si = int;
                self.as_mut().emit(Signals::SlideChanged { slide: &si });
            };
        }

        // #[qinvokable]
        // pub fn next(self: Pin<&mut Self>, next_item: QVariant, slide_model: slide_model) {}
    }
}
