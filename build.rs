use cxx_qt_build::CxxQtBuilder;

fn main() {
    CxxQtBuilder::new()
        .file("src/rust/service_thing.rs")
        .file("src/rust/settings.rs")
        .file("src/rust/file_helper.rs")
        .file("src/rust/slide_obj.rs")
        .build();
}
