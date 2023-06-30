use cxx_qt_build::CxxQtBuilder;
use std::env;

fn main() {
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
        .cc_builder (|cc| {
            println!("{:?}", env::var ("GUIX_ENVIRONMENT").unwrap_or_default());
            cc.include( env::var("GUIX_ENVIRONMENT").unwrap_or_default() + "/include");
            })
        .build();
}
