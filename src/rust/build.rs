use cxx_qt_build::CxxQtBuilder;

fn main() {
    CxxQtBuilder::new().file("src/cxxqt_object.rs").build();
    CxxQtBuilder::new().file("src/service_thing.rs").build();
}
