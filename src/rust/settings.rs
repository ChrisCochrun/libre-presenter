#[cxx_qt::bridge]
mod settings {

    use configparser::ini::Ini;
    // use std::error::Error;

    unsafe extern "C++" {
        include!("cxx-qt-lib/qstring.h");
        type QString = cxx_qt_lib::QString;
    }

    #[derive(Clone)]
    #[cxx_qt::qobject]
    pub struct Settings {
        #[qproperty]
        screen: QString,
        #[qproperty]
        sound_effect: QString,
    }

    impl Default for Settings {
        fn default() -> Self {
            Self {
                screen: QString::from(""),
                sound_effect: QString::from(""),
            }
        }
    }

    impl qobject::Settings {
        #[qinvokable]
        pub fn print_sound(self: Pin<&mut Self>) {
            let mut config = Ini::new();
            let _map = config.load("~/.config/librepresenter/Libre Presenter.conf");

            println!("{}", self.sound_effect());
        }
    }
}
