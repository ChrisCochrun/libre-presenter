#[cxx_qt::bridge]
mod service_thing {
    use cxx_qt_lib::QVariantValue;

    unsafe extern "C++" {
        include!("cxx-qt-lib/qstring.h");
        type QString = cxx_qt_lib::QString;
        include!("cxx-qt-lib/qvariant.h");
        type QVariant = cxx_qt_lib::QVariant;
    }

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
            self.set_active(true);
        }

        #[qinvokable]
        pub fn say_hi(self: Pin<&mut Self>, string: &QString, number: i32) {
            println!(
                "Hi from Rust! String is '{}' and number is {}",
                string, number
            );
            println!("length is: {}", string.to_string().len());
            let mut nstr: String = string.to_string();
            nstr.push_str(" hi");
            self.set_name(QString::from(nstr.as_str()));
        }

        #[qinvokable]
        pub fn slap_variant_around(self: Pin<&mut Self>, variant: &QVariant) {
            println!("wow!");
            match variant.value() {
                QVariantValue::QString(string) => self.set_name(string),
                _ => println!("Unknown QVariant type"),
            }
        }
    }
}
