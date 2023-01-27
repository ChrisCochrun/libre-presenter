#[cxx_qt::bridge]
mod settings {

    unsafe extern "C++" {
        include!("qsettingscxx.h");
        include!("cxx-qt-lib/qstring.h");
        type QString = cxx_qt_lib::QString;
    }

    #[derive(Clone)]
    #[cxx_qt::qobject(base = "QSettingsCXX")]
    pub struct Settings {
        #[qproperty]
        name: QString,
        #[qproperty]
        kind: QString,
    }

    impl Default for Settings {
        fn default() -> Self {
            Self {
                name: QString::from(""),
                kind: QString::from(""),
            }
        }
    }

    impl qobject::Settings {
        #[qinvokable]
        pub fn activate(self: Pin<&mut Self>) {
            println!("{}", self.name());
        }
    }
}
