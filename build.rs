use cxx_qt_build::CxxQtBuilder;

fn main() {
    CxxQtBuilder::new().file("src/rust/cxxqt_object.rs").build();
    CxxQtBuilder::new().file("src/rust/service_thing.rs").build();
}
