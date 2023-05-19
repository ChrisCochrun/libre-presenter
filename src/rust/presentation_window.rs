#[cxx_qt::bridge]
mod image_model {

    unsafe extern "C++" {
        include!(< QQuickWindow >);
        include!("cxx-qt-lib/qhash.h");
        type QHash_i32_QByteArray = cxx_qt_lib::QHash<cxx_qt_lib::QHashPair_i32_QByteArray>;
        include!("cxx-qt-lib/qmap.h");
        type QMap_QString_QVariant = cxx_qt_lib::QMap<cxx_qt_lib::QMapPair_QString_QVariant>;
        include!("cxx-qt-lib/qvariant.h");
        type QVariant = cxx_qt_lib::QVariant;
        include!("cxx-qt-lib/qstring.h");
        type QString = cxx_qt_lib::QString;
        include!("cxx-qt-lib/qurl.h");
        type QUrl = cxx_qt_lib::QUrl;
        include!("cxx-qt-lib/qmodelindex.h");
        type QModelIndex = cxx_qt_lib::QModelIndex;
        include!("cxx-qt-lib/qvector.h");
        type QVector_i32 = cxx_qt_lib::QVector<i32>;
        include!("cxx-qt-lib/qstringlist.h");
        type QStringList = cxx_qt_lib::QStringList;
        include!("cxx-qt-lib/qlist.h");
        type QList_QString = cxx_qt_lib::QList<QString>;
    }

    #[cxx_qt::qobject(base = "QQuickView")]
    #[derive(Default, Debug)]
    pub struct PresentationWindow {
        highest_id: i32,
    }

    impl qobject::PresentationWindow {
        #[qinvokable]
        pub fn show(mut self: Pin<&mut Self>, url: &QUrl) {
            self.set_source(url);
            self.base_show();
        }
    }

    // Create Rust bindings for C++ functions of the base class (QAbstractItemModel)
    #[cxx_qt::inherit]
    extern "C++" {}

    #[cxx_qt::inherit]
    unsafe extern "C++" {
        #[cxx_name = "setSource"]
        fn set_source(self: &qobject::PresentationWindow, url: &QUrl);
        #[cxx_name = "showFullscreen"]
        fn show_fullscreen(self: &qobject::PresentationWindow);
    }
}
