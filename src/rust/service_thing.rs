#[cxx_qt::bridge]
mod service_thing {
    use cxx_qt_lib::QVariantValue;

    unsafe extern "C++" {
        include!("cxx-qt-lib/qstring.h");
        type QString = cxx_qt_lib::QString;
        include!("cxx-qt-lib/qvariant.h");
        type QVariant = cxx_qt_lib::QVariant;
    }

    #[derive(Clone)]
    #[cxx_qt::qobject]
    pub struct ServiceThing {
        #[qproperty]
        name: QString,
        #[qproperty]
        kind: QString,
        #[qproperty]
        background: QString,
        #[qproperty]
        background_type: QString,
        #[qproperty]
        text: QString,
        #[qproperty]
        audio: QString,
        #[qproperty]
        font: QString,
        #[qproperty]
        font_size: QString,
        #[qproperty]
        active: bool,
        #[qproperty]
        selected: bool,
    }

    impl Default for ServiceThing {
        fn default() -> Self {
            Self {
                name: QString::from(""),
                kind: QString::from(""),
                background: QString::from(""),
                background_type: QString::from(""),
                text: QString::from(""),
                audio: QString::from(""),
                font: QString::from(""),
                font_size: QString::from(""),
                active: false,
                selected: false,
            }
        }
    }

    impl qobject::ServiceThing {
        #[qinvokable]
        pub fn activate(self: Pin<&mut Self>) {
            println!("{}", self.active());
            let active: bool = *self.active();
            self.set_active(!active);
            println!("{}", !active);
        }

        #[qinvokable]
        pub fn check_active(self: Pin<&mut Self>) {
            println!("Are we active?: {}", self.active());
        }

        #[qinvokable]
        pub fn slap_variant_around(self: Pin<&mut Self>, variant: &QVariant) {
            println!("wow!");
            let sname: String;
            match variant.value() {
                QVariantValue::QString(string) => {
                    let nstr = string.to_string();
                    self.set_name(QString::from(nstr.as_str()));
                    sname = nstr;
                    println!("New name is: {}", sname);
                }
                _ => println!("Unknown QVariant type"),
            };
        }
    }
}
