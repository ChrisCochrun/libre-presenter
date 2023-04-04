#[cxx_qt::bridge]
mod image_model {
    unsafe extern "C++" {
        include!(< QAbstractListModel >);
        include!("cxx-qt-lib/qhash.h");
        type QHash_i32_QByteArray = cxx_qt_lib::QHash<cxx_qt_lib::QHashPair_i32_QByteArray>;
        include!("cxx-qt-lib/qmap.h");
        type QMap_QString_QVariant = cxx_qt_lib::QMap<cxx_qt_lib::QMapPair_QString_QVariant>;
        include!("cxx-qt-lib/qvariant.h");
        type QVariant = cxx_qt_lib::QVariant;
        include!("cxx-qt-lib/qstring.h");
        type QString = cxx_qt_lib::QString;
        include!("cxx-qt-lib/qmodelindex.h");
        type QModelIndex = cxx_qt_lib::QModelIndex;
        include!("cxx-qt-lib/qvector.h");
        type QVector_i32 = cxx_qt_lib::QVector<i32>;
        include!("cxx-qt-lib/qstringlist.h");
        type QStringList = cxx_qt_lib::QStringList;
        include!("cxx-qt-lib/qlist.h");
        type QList_QString = cxx_qt_lib::QList<QString>;
    }

    #[cxx_qt::qobject(base = "QAbstractListModel")]
    #[derive(Default, Debug)]
    pub struct ImageModel {
        images: Vec<Image>,
    }

    #[derive(Default, Clone, Debug)]
    pub struct Image {
        id: i32,
        title: QString,
        path: QString,
    }

    #[cxx_qt::qsignals(ImageModel)]
    pub enum Signals<'a> {
        #[inherit]
        DataChanged {
            top_left: &'a QModelIndex,
            bottom_right: &'a QModelIndex,
            roles: &'a QVector_i32,
        },
    }

    enum Role {
        IdRole,
        PathRole,
        TitleRole,
    }

    use crate::entities::{images, prelude::Images};
    use sea_orm::{ConnectionTrait, Database, DbBackend, DbErr, Statement, ActiveValue};
    use std::path::PathBuf;
    impl qobject::ImageModel {
        #[qinvokable]
        pub fn clear(mut self: Pin<&mut Self>) {
            unsafe {
                self.as_mut().begin_reset_model();
                self.as_mut().images_mut().clear();
                self.as_mut().end_reset_model();
            }
        }

        #[qinvokable]
        pub fn remove_item(mut self: Pin<&mut Self>, index: i32) {
            if index < 0 || (index as usize) >= self.images().len() {
                return;
            }

            unsafe {
                self.as_mut()
                    .begin_remove_rows(&QModelIndex::default(), index, index);
                self.as_mut().images_mut().remove(index as usize);
                self.as_mut().end_remove_rows();
            }
        }

        #[qinvokable]
        pub async fn add_item(mut self: Pin<&mut Self>, id: i32, title: QString, path: QString) -> Result<(), DBErr> {
            const DATABASE_URL: &str = "sqlite://library-db.sqlite3";
            const DB_NAME: &str = "library_db";

            let db = Database::connect(DATABASE_URL).await?;
            let image = Image { id, title, path };
            let model = images::ActiveModel {
                id: ActiveValue::set(id),
                title: ActiveValue::set(title.to_string()),
                path: ActiveValue::set(path.to_string()),
                ..Default::default()
            };
            let res = Images::insert(model).exec(db).await?;

            self.as_mut().add_image(image);

            Ok(())
        }

        fn add_image(mut self: Pin<&mut Self>, image: Image) {
            let index = self.as_ref().images().len() as i32;
            println!("{:?}", image);
            unsafe {
                self.as_mut()
                    .begin_insert_rows(&QModelIndex::default(), index, index);
                self.as_mut().images_mut().push(image);
                self.as_mut().end_insert_rows();
            }
        }

        #[qinvokable]
        pub fn insert_item(
            mut self: Pin<&mut Self>,
            id: i32,
            title: QString,
            path: QString,
            index: i32,
        ) {
            let image = Image { id, title, path };

            self.as_mut().insert_image(image, index);
        }

        fn insert_image(mut self: Pin<&mut Self>, image: Image, id: i32) {
            unsafe {
                self.as_mut()
                    .begin_insert_rows(&QModelIndex::default(), id, id);
                self.as_mut().images_mut().insert(id as usize, image);
                self.as_mut().end_insert_rows();
            }
        }

        // #[qinvokable]
        // pub fn insert_item_from_service(
        //     mut self: Pin<&mut Self>,
        //     index: i32,
        //     service_item: &QMap_QString_QVariant,
        // ) {
        //     let ty = service_item
        //         .get(&QString::from("type"))
        //         .unwrap_or(QVariant::from(&QString::from("")))
        //         .value::<QString>();

        //     let background = service_item
        //         .get(&QString::from("background"))
        //         .unwrap_or(QVariant::from(&QString::from("")))
        //         .value::<QString>()
        //         .unwrap_or_default();

        //     let background_type = service_item
        //         .get(&QString::from("backgroundType"))
        //         .unwrap_or(QVariant::from(&QString::from("")))
        //         .value::<QString>()
        //         .unwrap_or_default();

        //     let mut image = Image::default();

        //     self.as_mut().insert_image(&image, index);

        //     println!("Item added in rust model!");
        // }

        // #[qinvokable]
        // pub fn add_item_from_service(
        //     mut self: Pin<&mut Self>,
        //     index: i32,
        //     service_item: &QMap_QString_QVariant,
        // ) {
        //     println!("add rust image {:?}", index);
        //     let ty = service_item
        //         .get(&QString::from("type"))
        //         .unwrap_or(QVariant::from(&QString::from("")))
        //         .value::<QString>();

        //     let background = service_item
        //         .get(&QString::from("background"))
        //         .unwrap_or(QVariant::from(&QString::from("")))
        //         .value::<QString>()
        //         .unwrap_or_default();

        //     let background_type = service_item
        //         .get(&QString::from("backgroundType"))
        //         .unwrap_or(QVariant::from(&QString::from("")))
        //         .value::<QString>()
        //         .unwrap_or_default();

        //     let mut image = Image::default();

        //     self.as_mut().add_image(&image);

        //     println!("Item added in rust model!");
        // }

        #[qinvokable]
        pub fn get_item(self: Pin<&mut Self>, index: i32) -> QMap_QString_QVariant {
            println!("{index}");
            let mut qvariantmap = QMap_QString_QVariant::default();
            let idx = self.index(index, 0, &QModelIndex::default());
            if !idx.is_valid() {
                return qvariantmap;
            }
            let rn = self.as_ref().role_names();
            let rn_iter = rn.iter();
            if let Some(image) = self.rust().images.get(index as usize) {
                for i in rn_iter {
                    qvariantmap.insert(
                        QString::from(&i.1.to_string()),
                        self.as_ref().data(&idx, *i.0),
                    );
                }
            };
            qvariantmap
        }

        fn get_role(&self, role: Role) -> i32 {
            match role {
                Role::IdRole => 0,
                Role::TitleRole => 1,
                Role::PathRole => 2,
                _ => 0,
            }
        }
    }

    // Create Rust bindings for C++ functions of the base class (QAbstractItemModel)
    #[cxx_qt::inherit]
    extern "C++" {
        unsafe fn begin_insert_rows(
            self: Pin<&mut qobject::ImageModel>,
            parent: &QModelIndex,
            first: i32,
            last: i32,
        );
        unsafe fn end_insert_rows(self: Pin<&mut qobject::ImageModel>);

        unsafe fn begin_remove_rows(
            self: Pin<&mut qobject::ImageModel>,
            parent: &QModelIndex,
            first: i32,
            last: i32,
        );
        unsafe fn end_remove_rows(self: Pin<&mut qobject::ImageModel>);

        unsafe fn begin_reset_model(self: Pin<&mut qobject::ImageModel>);
        unsafe fn end_reset_model(self: Pin<&mut qobject::ImageModel>);
    }

    #[cxx_qt::inherit]
    unsafe extern "C++" {
        #[cxx_name = "canFetchMore"]
        fn base_can_fetch_more(self: &qobject::ImageModel, parent: &QModelIndex) -> bool;

        fn index(
            self: &qobject::ImageModel,
            row: i32,
            column: i32,
            parent: &QModelIndex,
        ) -> QModelIndex;
    }

    // QAbstractListModel implementation
    impl qobject::ImageModel {
        #[qinvokable(cxx_override)]
        fn data(&self, index: &QModelIndex, role: i32) -> QVariant {
            if let Some(image) = self.images().get(index.row() as usize) {
                return match role {
                    0 => QVariant::from(&image.id),
                    1 => QVariant::from(&image.title),
                    2 => QVariant::from(&image.path),
                    _ => QVariant::default(),
                };
            }

            QVariant::default()
        }

        // Example of overriding a C++ virtual method and calling the base class implementation.
        #[qinvokable(cxx_override)]
        pub fn can_fetch_more(&self, parent: &QModelIndex) -> bool {
            self.base_can_fetch_more(parent)
        }

        #[qinvokable(cxx_override)]
        pub fn role_names(&self) -> QHash_i32_QByteArray {
            let mut roles = QHash_i32_QByteArray::default();
            roles.insert(0, cxx_qt_lib::QByteArray::from("id"));
            roles.insert(1, cxx_qt_lib::QByteArray::from("title"));
            roles.insert(2, cxx_qt_lib::QByteArray::from("path"));
            roles
        }

        #[qinvokable(cxx_override)]
        pub fn row_count(&self, _parent: &QModelIndex) -> i32 {
            let cnt = self.rust().images.len() as i32;
            // println!("row count is {cnt}");
            cnt
        }

        #[qinvokable]
        pub fn count(&self) -> i32 {
            self.rust().images.len() as i32
        }
    }
}
