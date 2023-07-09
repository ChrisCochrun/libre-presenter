use cxx_qt_build::CxxQtBuilder;
use std::env;
use std::path::{Path, PathBuf};

fn main() {
    // let guix_profile_dir = env::var("GUIX_ENVIRONMENT").is_ok();
    // println!("{}", guix_profile_dir);
    // let qt_include = PathBuf::from(guix_profile_dir).push("include").push("qt5");
    CxxQtBuilder::new()
        .file("src/rust/service_thing.rs")
        .file("src/rust/settings.rs")
        .file("src/rust/file_helper.rs")
        .file("src/rust/slide_obj.rs")
        .file("src/rust/slide_model.rs")
        .file("src/rust/service_item_model.rs")
        .file("src/rust/image_model.rs")
        .file("src/rust/video_model.rs")
        .file("src/rust/presentation_model.rs")
        .file("src/rust/song_model.rs")
        .file("src/rust/ytdl.rs")
        //         .cc_builder(|cc| {
        //             cc.include("/gnu/store/pkjvij1f6rvx42xv2kygicr7fsch41dl-profile/include/qt5/QtQml/QQmlApplicationEngine");
        //             cc.include("/gnu/store/pkjvij1f6rvx42xv2kygicr7fsch41dl-profile/include/qt5/QtQml/qqmlapplicationengine.h");
        // cc.include("/gnu/store/pkjvij1f6rvx42xv2kygicr7fsch41dl-profile/include/qt5/QtQml/qqmlengine.h");
        // cc.include("/gnu/store/pkjvij1f6rvx42xv2kygicr7fsch41dl-profile/include/qt5/QtQml/QQmlEngine");
        // cc.include("include/qt5");
        //         })
        .build();
}
