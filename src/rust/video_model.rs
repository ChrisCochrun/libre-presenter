#[cxx_qt::bridge]
mod video_model {
    use crate::models::*;
    use crate::schema::videos::dsl::*;
    use crate::video_model::video_model::Video;
    use diesel::sqlite::SqliteConnection;
    use diesel::{delete, insert_into, prelude::*};
    use std::path::{Path, PathBuf};

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

    #[derive(Default, Clone, Debug)]
    pub struct Video {
        id: i32,
        title: QString,
        path: QString,
        start_time: f32,
        end_time: f32,
        looping: bool,
    }

    #[cxx_qt::qobject(base = "QAbstractListModel")]
    #[derive(Default, Debug)]
    pub struct VideoModel {
        highest_id: i32,
        videos: Vec<self::Video>,
    }

    #[cxx_qt::qsignals(VideoModel)]
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
        TitleRole,
        PathRole,
        StartTimeRole,
        EndTimeRole,
        LoopingRole,
    }

    // use crate::entities::{videos, prelude::Videos};
    // use sea_orm::{ConnectionTrait, Database, DbBackend, DbErr, Statement, ActiveValue};
    impl qobject::VideoModel {
        #[qinvokable]
        pub fn clear(mut self: Pin<&mut Self>) {
            unsafe {
                self.as_mut().begin_reset_model();
                self.as_mut().videos_mut().clear();
                self.as_mut().end_reset_model();
            }
        }

        #[qinvokable]
        pub fn test_database(mut self: Pin<&mut Self>) {
            let db = &mut self.as_mut().get_db();
            let results = videos
                .load::<crate::models::Video>(db)
                .expect("Error loading videos");
            self.as_mut().set_highest_id(0);

            println!("SHOWING VIDEOS");
            println!("--------------");
            for video in results {
                println!("{}", video.title);
                println!("{}", video.id);
                println!("{}", video.path);
                println!("--------------");
                if self.as_mut().highest_id() < &video.id {
                    self.as_mut().set_highest_id(video.id);
                }

                let img = self::Video {
                    id: video.id,
                    title: QString::from(&video.title),
                    path: QString::from(&video.path),
                    start_time: 0.0,
                    end_time: 0.0,
                    looping: false,
                };

                self.as_mut().add_video(img);
            }
            println!("--------------------------------------");
            println!("{:?}", self.as_mut().videos());
            println!("--------------------------------------");
        }

        #[qinvokable]
        pub fn remove_item(mut self: Pin<&mut Self>, index: i32) -> bool {
            if index < 0 || (index as usize) >= self.videos().len() {
                return false;
            }
            let db = &mut self.as_mut().get_db();

            let video_id = self.videos().get(index as usize).unwrap().id;

            let result = delete(videos.filter(id.eq(video_id))).execute(db);

            match result {
                Ok(_i) => {
                    unsafe {
                        self.as_mut()
                            .begin_remove_rows(&QModelIndex::default(), index, index);
                        self.as_mut().videos_mut().remove(index as usize);
                        self.as_mut().end_remove_rows();
                    }
                    println!("removed-item-at-index: {:?}", video_id);
                    println!("new-Vec: {:?}", self.as_mut().videos());
                    true
                }
                Err(_e) => {
                    println!("Cannot connect to database");
                    false
                }
            }
        }

        fn get_db(self: Pin<&mut Self>) -> SqliteConnection {
            const DATABASE_URL: &str = "sqlite:///home/chris/.local/share/librepresenter/Libre Presenter/library-db.sqlite3";

            SqliteConnection::establish(DATABASE_URL)
                .unwrap_or_else(|_| panic!("error connecting to {}", DATABASE_URL))
            // self.rust().db = db;
        }

        #[qinvokable]
        pub fn new_item(mut self: Pin<&mut Self>, url: QUrl) {
            println!("LETS INSERT THIS SUCKER!");
            let file_path = PathBuf::from(url.path().to_string());
            let name = file_path.file_stem().unwrap().to_str().unwrap();
            let video_id = self.rust().highest_id + 1;
            let video_title = QString::from(name);
            let video_path = url.to_qstring();

            if self.as_mut().add_item(video_id, video_title, video_path) {
                println!("filename: {:?}", name);
                self.as_mut().set_highest_id(video_id);
            } else {
                println!("Error in inserting item");
            }
        }

        #[qinvokable]
        pub fn add_item(
            mut self: Pin<&mut Self>,
            video_id: i32,
            video_title: QString,
            video_path: QString,
        ) -> bool {
            let db = &mut self.as_mut().get_db();
            // println!("{:?}", db);
            let video = self::Video {
                id: video_id,
                title: video_title.clone(),
                path: video_path.clone(),
                start_time: 0.0,
                end_time: 0.0,
                looping: false,
            };
            println!("{:?}", video);

            let result = insert_into(videos)
                .values((
                    id.eq(&video_id),
                    title.eq(&video_title.to_string()),
                    path.eq(&video_path.to_string()),
                ))
                .execute(db);
            println!("{:?}", result);

            match result {
                Ok(_i) => {
                    self.as_mut().add_video(video);
                    println!("{:?}", self.as_mut().videos());
                    true
                }
                Err(_e) => {
                    println!("Cannot connect to database");
                    false
                }
            }
        }

        fn add_video(mut self: Pin<&mut Self>, video: self::Video) {
            let index = self.as_ref().videos().len() as i32;
            println!("{:?}", video);
            unsafe {
                self.as_mut()
                    .begin_insert_rows(&QModelIndex::default(), index, index);
                self.as_mut().videos_mut().push(video);
                self.as_mut().end_insert_rows();
            }
        }

        #[qinvokable]
        pub fn get_item(self: Pin<&mut Self>, index: i32) -> QMap_QString_QVariant {
            println!("{index}");
            let mut qvariantmap = QMap_QString_QVariant::default();
            let idx = self.index(index, 0, &QModelIndex::default());
            if !idx.is_valid() {
                return qvariantmap;
            }
            let role_names = self.as_ref().role_names();
            let role_names_iter = role_names.iter();
            if let Some(video) = self.rust().videos.get(index as usize) {
                for i in role_names_iter {
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
                Role::StartTimeRole => 3,
                Role::EndTimeRole => 4,
                Role::LoopingRole => 5,
                _ => 0,
            }
        }
    }

    // Create Rust bindings for C++ functions of the base class (QAbstractItemModel)
    #[cxx_qt::inherit]
    extern "C++" {
        unsafe fn begin_insert_rows(
            self: Pin<&mut qobject::VideoModel>,
            parent: &QModelIndex,
            first: i32,
            last: i32,
        );
        unsafe fn end_insert_rows(self: Pin<&mut qobject::VideoModel>);

        unsafe fn begin_remove_rows(
            self: Pin<&mut qobject::VideoModel>,
            parent: &QModelIndex,
            first: i32,
            last: i32,
        );
        unsafe fn end_remove_rows(self: Pin<&mut qobject::VideoModel>);

        unsafe fn begin_reset_model(self: Pin<&mut qobject::VideoModel>);
        unsafe fn end_reset_model(self: Pin<&mut qobject::VideoModel>);
    }

    #[cxx_qt::inherit]
    unsafe extern "C++" {
        #[cxx_name = "canFetchMore"]
        fn base_can_fetch_more(self: &qobject::VideoModel, parent: &QModelIndex) -> bool;

        fn index(
            self: &qobject::VideoModel,
            row: i32,
            column: i32,
            parent: &QModelIndex,
        ) -> QModelIndex;
    }

    // QAbstractListModel implementation
    impl qobject::VideoModel {
        #[qinvokable(cxx_override)]
        fn data(&self, index: &QModelIndex, role: i32) -> QVariant {
            if let Some(video) = self.videos().get(index.row() as usize) {
                return match role {
                    0 => QVariant::from(&video.id),
                    1 => QVariant::from(&video.title),
                    2 => QVariant::from(&video.path),
                    3 => QVariant::from(&video.start_time),
                    4 => QVariant::from(&video.end_time),
                    5 => QVariant::from(&video.looping),
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
            roles.insert(2, cxx_qt_lib::QByteArray::from("filePath"));
            roles.insert(3, cxx_qt_lib::QByteArray::from("startTime"));
            roles.insert(4, cxx_qt_lib::QByteArray::from("endTime"));
            roles.insert(5, cxx_qt_lib::QByteArray::from("loop"));
            roles
        }

        #[qinvokable(cxx_override)]
        pub fn row_count(&self, _parent: &QModelIndex) -> i32 {
            let cnt = self.rust().videos.len() as i32;
            // println!("row count is {cnt}");
            cnt
        }

        #[qinvokable]
        pub fn count(&self) -> i32 {
            self.rust().videos.len() as i32
        }
    }
}
