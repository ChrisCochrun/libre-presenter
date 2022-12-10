#[cxx_qt::bridge]
mod my_object {
    use cxx_qt_lib::QVariantValue;

    unsafe extern "C++" {
        include!("cxx-qt-lib/qstring.h");
        type QString = cxx_qt_lib::QString;
        include!("cxx-qt-lib/qvariant.h");
        type QVariant = cxx_qt_lib::QVariant;
    }

    #[cxx_qt::qobject]
    pub struct MyObject {
        #[qproperty]
        number: i32,
        #[qproperty]
        string: QString,
    }

    impl Default for MyObject {
        fn default() -> Self {
            Self {
                number: 0,
                string: QString::from(""),
            }
        }
    }

    impl qobject::MyObject {
        #[qinvokable]
        pub fn increment_number(self: Pin<&mut Self>) {
            let previous = *self.as_ref().number();
            self.set_number(previous + 1);
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
            self.set_string(QString::from(nstr.as_str()));
        }

        #[qinvokable]
        pub fn slap_variant_around(self: Pin<&mut Self>, variant: &QVariant) {
            println!("wow!");
            match variant.value() {
                QVariantValue::QString(string) => self.set_string(string),
                _ => println!("Unknown QVariant type"),
            }
        }
    }
}
