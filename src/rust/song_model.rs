#[cxx_qt::bridge]
mod song_model {
    use crate::models::*;
    use crate::schema::songs::dsl::*;
    use crate::song_model::song_model::Song;
    use diesel::sqlite::SqliteConnection;
    use diesel::{delete, insert_into, prelude::*, update};
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
    pub struct Song {
        id: i32,
        title: QString,
        lyrics: QString,
        author: QString,
        ccli: QString,
        audio: QString,
        verse_order: QString,
        background: QString,
        background_type: QString,
        horizontal_text_alignment: QString,
        vertical_text_alignment: QString,
        font: QString,
        font_size: i32,
    }

    #[cxx_qt::qobject(base = "QAbstractListModel")]
    #[derive(Default, Debug)]
    pub struct SongModel {
        highest_id: i32,
        songs: Vec<self::Song>,
    }

    #[cxx_qt::qsignals(SongModel)]
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
        LyricsRole,
        AuthorRole,
        CcliRole,
        AudioRole,
        VerseOrderRole,
        BackgroundRole,
        BackgroundTypeRole,
        HorizontalTextAlignmentRole,
        VerticalTextAlignmentRole,
        FontRole,
        FontSizeRole,
    }

    // use crate::entities::{songs, prelude::Songs};
    // use sea_orm::{ConnectionTrait, Database, DbBackend, DbErr, Statement, ActiveValue};
    impl qobject::SongModel {
        #[qinvokable]
        pub fn clear(mut self: Pin<&mut Self>) {
            unsafe {
                self.as_mut().begin_reset_model();
                self.as_mut().songs_mut().clear();
                self.as_mut().end_reset_model();
            }
        }

        #[qinvokable]
        pub fn setup(mut self: Pin<&mut Self>) {
            let db = &mut self.as_mut().get_db();
            let results = songs
                .load::<crate::models::Song>(db)
                .expect("Error loading songs");
            self.as_mut().set_highest_id(0);

            println!("SHOWING SONGS");
            println!("--------------");
            for song in results {
                println!("{}", song.title);
                println!("{}", song.id);
                println!("{}", song.path);
                println!("--------------");
                if self.as_mut().highest_id() < &song.id {
                    self.as_mut().set_highest_id(song.id);
                }

                let img = self::Song {
                    id: song.id,
                    title: QString::from(&song.title),
                    path: QString::from(&song.path),
                };

                self.as_mut().add_song(img);
            }
            println!("--------------------------------------");
            println!("{:?}", self.as_mut().songs());
            println!("--------------------------------------");
        }

        #[qinvokable]
        pub fn delete_song(mut self: Pin<&mut Self>, index: i32) -> bool {
            if index < 0 || (index as usize) >= self.songs().len() {
                return false;
            }
            let db = &mut self.as_mut().get_db();
            let song_id = self.songs().get(index as usize).unwrap().id;
            let result = delete(songs.filter(id.eq(song_id))).execute(db);

            match result {
                Ok(_i) => {
                    unsafe {
                        self.as_mut()
                            .begin_remove_rows(&QModelIndex::default(), index, index);
                        self.as_mut().songs_mut().remove(index as usize);
                        self.as_mut().end_remove_rows();
                    }
                    println!("removed-item-at-index: {:?}", song_id);
                    println!("new-Vec: {:?}", self.as_mut().songs());
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
        pub fn new_song(mut self: Pin<&mut Self>) {
            todo!();
        }

        #[qinvokable]
        pub fn new_item(mut self: Pin<&mut Self>, url: QUrl) {
            println!("LETS INSERT THIS SUCKER!");
            let file_path = PathBuf::from(url.path().to_string());
            let name = file_path.file_stem().unwrap().to_str().unwrap();
            let song_id = self.rust().highest_id + 1;
            let song_title = QString::from(name);
            let song_path = url.to_qstring();

            if self.as_mut().add_item(song_id, song_title, song_path) {
                println!("filename: {:?}", name);
                self.as_mut().set_highest_id(song_id);
            } else {
                println!("Error in inserting item");
            }
        }

        fn add_item(
            mut self: Pin<&mut Self>,
            song_id: i32,
            song_title: QString,
            song_path: QString,
        ) -> bool {
            let db = &mut self.as_mut().get_db();
            // println!("{:?}", db);
            let song = self::Song {
                id: song_id,
                title: song_title.clone(),
                path: song_path.clone(),
            };
            println!("{:?}", song);

            let result = insert_into(songs)
                .values((
                    id.eq(&song_id),
                    title.eq(&song_title.to_string()),
                    path.eq(&song_path.to_string()),
                ))
                .execute(db);
            println!("{:?}", result);

            match result {
                Ok(_i) => {
                    self.as_mut().add_song(song);
                    println!("{:?}", self.as_mut().songs());
                    true
                }
                Err(_e) => {
                    println!("Cannot connect to database");
                    false
                }
            }
        }

        fn add_song(mut self: Pin<&mut Self>, song: self::Song) {
            let index = self.as_ref().songs().len() as i32;
            println!("{:?}", song);
            unsafe {
                self.as_mut()
                    .begin_insert_rows(&QModelIndex::default(), index, index);
                self.as_mut().songs_mut().push(song);
                self.as_mut().end_insert_rows();
            }
        }

        #[qinvokable]
        pub fn update_title(mut self: Pin<&mut Self>, index: i32, updated_title: QString) -> bool {
            let mut vector_roles = QVector_i32::default();
            vector_roles.append(self.as_ref().get_role(Role::TitleRole));
            let model_index = &self.as_ref().index(index, 0, &QModelIndex::default());

            let db = &mut self.as_mut().get_db();
            let result = update(songs.filter(id.eq(index)))
                .set(title.eq(updated_title.to_string()))
                .execute(db);
            match result {
                Ok(_i) => {
                    let song = self.as_mut().songs_mut().get_mut(index as usize).unwrap();
                    song.title = updated_title;
                    self.as_mut()
                        .emit_data_changed(model_index, model_index, &vector_roles);
                    true
                }
                Err(_e) => false,
            }
        }

        #[qinvokable]
        pub fn update_lyrics(
            mut self: Pin<&mut Self>,
            index: i32,
            updated_lyrics: QString,
        ) -> bool {
            let mut vector_roles = QVector_i32::default();
            vector_roles.append(self.as_ref().get_role(Role::LyricsRole));
            let model_index = &self.as_ref().index(index, 0, &QModelIndex::default());

            let db = &mut self.as_mut().get_db();
            let result = update(songs.filter(id.eq(index)))
                .set(lyrics.eq(updated_lyrics.to_string()))
                .execute(db);
            match result {
                Ok(_i) => {
                    let song = self.as_mut().songs_mut().get_mut(index as usize).unwrap();
                    song.lyrics = updated_lyrics;
                    self.as_mut()
                        .emit_data_changed(model_index, model_index, &vector_roles);
                    true
                }
                Err(_e) => false,
            }
        }

        #[qinvokable]
        pub fn update_audio(mut self: Pin<&mut Self>, index: i32, updated_audio: QString) -> bool {
            let mut vector_roles = QVector_i32::default();
            vector_roles.append(self.as_ref().get_role(Role::AudioRole));
            let model_index = &self.as_ref().index(index, 0, &QModelIndex::default());

            let db = &mut self.as_mut().get_db();
            let result = update(songs.filter(id.eq(index)))
                .set(audio.eq(updated_audio.to_string()))
                .execute(db);
            match result {
                Ok(_i) => {
                    let song = self.as_mut().songs_mut().get_mut(index as usize).unwrap();
                    song.audio = updated_audio;
                    self.as_mut()
                        .emit_data_changed(model_index, model_index, &vector_roles);
                    true
                }
                Err(_e) => false,
            }
        }

        #[qinvokable]
        pub fn update_author(
            mut self: Pin<&mut Self>,
            index: i32,
            updated_author: QString,
        ) -> bool {
            let mut vector_roles = QVector_i32::default();
            vector_roles.append(self.as_ref().get_role(Role::AuthorRole));
            let model_index = &self.as_ref().index(index, 0, &QModelIndex::default());

            let db = &mut self.as_mut().get_db();
            let result = update(songs.filter(id.eq(index)))
                .set(author.eq(updated_author.to_string()))
                .execute(db);
            match result {
                Ok(_i) => {
                    let song = self.as_mut().songs_mut().get_mut(index as usize).unwrap();
                    song.author = updated_author;
                    self.as_mut()
                        .emit_data_changed(model_index, model_index, &vector_roles);
                    true
                }
                Err(_e) => false,
            }
        }

        #[qinvokable]
        pub fn update_ccli(mut self: Pin<&mut Self>, index: i32, updated_ccli: QString) -> bool {
            let mut vector_roles = QVector_i32::default();
            vector_roles.append(self.as_ref().get_role(Role::CcliRole));
            let model_index = &self.as_ref().index(index, 0, &QModelIndex::default());

            let db = &mut self.as_mut().get_db();
            let result = update(songs.filter(id.eq(index)))
                .set(ccli.eq(updated_ccli.to_string()))
                .execute(db);
            match result {
                Ok(_i) => {
                    let song = self.as_mut().songs_mut().get_mut(index as usize).unwrap();
                    song.ccli = updated_ccli;
                    self.as_mut()
                        .emit_data_changed(model_index, model_index, &vector_roles);
                    true
                }
                Err(_e) => false,
            }
        }

        #[qinvokable]
        pub fn update_file_path(
            mut self: Pin<&mut Self>,
            index: i32,
            updated_file_path: QString,
        ) -> bool {
            let mut vector_roles = QVector_i32::default();
            vector_roles.append(self.as_ref().get_role(Role::PathRole));
            let model_index = &self.as_ref().index(index, 0, &QModelIndex::default());

            let db = &mut self.as_mut().get_db();
            let result = update(songs.filter(id.eq(index)))
                .set(path.eq(updated_file_path.to_string()))
                .execute(db);
            match result {
                Ok(_i) => {
                    let song = self.as_mut().songs_mut().get_mut(index as usize).unwrap();
                    song.path = updated_file_path;
                    self.as_mut()
                        .emit_data_changed(model_index, model_index, &vector_roles);
                    true
                }
                Err(_e) => false,
            }
        }

        #[qinvokable]
        pub fn update_verse_order(
            mut self: Pin<&mut Self>,
            index: i32,
            updated_verse_order: QString,
        ) -> bool {
            let mut vector_roles = QVector_i32::default();
            vector_roles.append(self.as_ref().get_role(Role::VerseOrderRole));
            let model_index = &self.as_ref().index(index, 0, &QModelIndex::default());

            let db = &mut self.as_mut().get_db();
            let result = update(songs.filter(id.eq(index)))
                .set(verse_order.eq(updated_verse_order.to_string()))
                .execute(db);
            match result {
                Ok(_i) => {
                    let song = self.as_mut().songs_mut().get_mut(index as usize).unwrap();
                    song.verse_order = updated_verse_order;
                    self.as_mut()
                        .emit_data_changed(model_index, model_index, &vector_roles);
                    true
                }
                Err(_e) => false,
            }
        }

        #[qinvokable]
        pub fn update_background(
            mut self: Pin<&mut Self>,
            index: i32,
            updated_background: QString,
        ) -> bool {
            let mut vector_roles = QVector_i32::default();
            vector_roles.append(self.as_ref().get_role(Role::BackgroundRole));
            let model_index = &self.as_ref().index(index, 0, &QModelIndex::default());

            let db = &mut self.as_mut().get_db();
            let result = update(songs.filter(id.eq(index)))
                .set(background.eq(updated_background.to_string()))
                .execute(db);
            match result {
                Ok(_i) => {
                    let song = self.as_mut().songs_mut().get_mut(index as usize).unwrap();
                    song.background = updated_background;
                    self.as_mut()
                        .emit_data_changed(model_index, model_index, &vector_roles);
                    true
                }
                Err(_e) => false,
            }
        }

        #[qinvokable]
        pub fn update_background_type(
            mut self: Pin<&mut Self>,
            index: i32,
            updated_background_type: QString,
        ) -> bool {
            let mut vector_roles = QVector_i32::default();
            vector_roles.append(self.as_ref().get_role(Role::BackgroundTypeRole));
            let model_index = &self.as_ref().index(index, 0, &QModelIndex::default());

            let db = &mut self.as_mut().get_db();
            let result = update(songs.filter(id.eq(index)))
                .set(background_type.eq(updated_background_type.to_string()))
                .execute(db);
            match result {
                Ok(_i) => {
                    let song = self.as_mut().songs_mut().get_mut(index as usize).unwrap();
                    song.background_type = updated_background_type;
                    self.as_mut()
                        .emit_data_changed(model_index, model_index, &vector_roles);
                    true
                }
                Err(_e) => false,
            }
        }

        #[qinvokable]
        pub fn update_horizontal_text_alignment(
            mut self: Pin<&mut Self>,
            index: i32,
            updated_horizontal_text_alignment: QString,
        ) -> bool {
            let mut vector_roles = QVector_i32::default();
            vector_roles.append(self.as_ref().get_role(Role::HorizontalTextAlignmentRole));
            let model_index = &self.as_ref().index(index, 0, &QModelIndex::default());

            let db = &mut self.as_mut().get_db();
            let result = update(songs.filter(id.eq(index)))
                .set(horizontal_text_alignment.eq(updated_horizontal_text_alignment.to_string()))
                .execute(db);
            match result {
                Ok(_i) => {
                    let song = self.as_mut().songs_mut().get_mut(index as usize).unwrap();
                    song.horizontal_text_alignment = updated_horizontal_text_alignment;
                    self.as_mut()
                        .emit_data_changed(model_index, model_index, &vector_roles);
                    true
                }
                Err(_e) => false,
            }
        }

        #[qinvokable]
        pub fn update_vertical_text_alignment(
            mut self: Pin<&mut Self>,
            index: i32,
            updated_vertical_text_alignment: QString,
        ) -> bool {
            let mut vector_roles = QVector_i32::default();
            vector_roles.append(self.as_ref().get_role(Role::VerticalTextAlignmentRole));
            let model_index = &self.as_ref().index(index, 0, &QModelIndex::default());

            let db = &mut self.as_mut().get_db();
            let result = update(songs.filter(id.eq(index)))
                .set(vertical_text_alignment.eq(updated_vertical_text_alignment.to_string()))
                .execute(db);
            match result {
                Ok(_i) => {
                    let song = self.as_mut().songs_mut().get_mut(index as usize).unwrap();
                    song.vertical_text_alignment = updated_vertical_text_alignment;
                    self.as_mut()
                        .emit_data_changed(model_index, model_index, &vector_roles);
                    true
                }
                Err(_e) => false,
            }
        }

        #[qinvokable]
        pub fn update_font(mut self: Pin<&mut Self>, index: i32, updated_font: QString) -> bool {
            let mut vector_roles = QVector_i32::default();
            vector_roles.append(self.as_ref().get_role(Role::FontRole));
            let model_index = &self.as_ref().index(index, 0, &QModelIndex::default());

            let db = &mut self.as_mut().get_db();
            let result = update(songs.filter(id.eq(index)))
                .set(font.eq(updated_font.to_string()))
                .execute(db);
            match result {
                Ok(_i) => {
                    let song = self.as_mut().songs_mut().get_mut(index as usize).unwrap();
                    song.font = updated_font;
                    self.as_mut()
                        .emit_data_changed(model_index, model_index, &vector_roles);
                    true
                }
                Err(_e) => false,
            }
        }

        #[qinvokable]
        pub fn update_font_size(
            mut self: Pin<&mut Self>,
            index: i32,
            updated_font_size: i32,
        ) -> bool {
            let mut vector_roles = QVector_i32::default();
            vector_roles.append(self.as_ref().get_role(Role::FontSizeRole));
            let model_index = &self.as_ref().index(index, 0, &QModelIndex::default());

            let db = &mut self.as_mut().get_db();
            let result = update(songs.filter(id.eq(index)))
                .set(font_size.eq(updated_font_size))
                .execute(db);
            match result {
                Ok(_i) => {
                    let song = self.as_mut().songs_mut().get_mut(index as usize).unwrap();
                    song.font_size = updated_font_size;
                    self.as_mut()
                        .emit_data_changed(model_index, model_index, &vector_roles);
                    true
                }
                Err(_e) => false,
            }
        }

        #[qinvokable]
        pub fn get_lyric_list(mut self: Pin<&mut Self>, index: i32) -> QList_QString {
            todo!();
        }

        #[qinvokable]
        pub fn get_song(self: Pin<&mut Self>, index: i32) -> QMap_QString_QVariant {
            println!("{index}");
            let mut qvariantmap = QMap_QString_QVariant::default();
            let idx = self.index(index, 0, &QModelIndex::default());
            if !idx.is_valid() {
                return qvariantmap;
            }
            let role_names = self.as_ref().role_names();
            let role_names_iter = role_names.iter();
            if let Some(song) = self.rust().songs.get(index as usize) {
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
                Role::LyricsRole => 2,
                Role::AuthorRole => 3,
                Role::CcliRole => 4,
                Role::AudioRole => 5,
                Role::VerseOrderRole => 6,
                Role::BackgroundRole => 7,
                Role::BackgroundTypeRole => 8,
                Role::HorizontalTextAlignmentRole => 9,
                Role::VerticalTextAlignmentRole => 10,
                Role::FontRole => 11,
                Role::FontSizeRole => 12,
                _ => 0,
            }
        }
    }

    // Create Rust bindings for C++ functions of the base class (QAbstractItemModel)
    #[cxx_qt::inherit]
    extern "C++" {
        unsafe fn begin_insert_rows(
            self: Pin<&mut qobject::SongModel>,
            parent: &QModelIndex,
            first: i32,
            last: i32,
        );
        unsafe fn end_insert_rows(self: Pin<&mut qobject::SongModel>);

        unsafe fn begin_remove_rows(
            self: Pin<&mut qobject::SongModel>,
            parent: &QModelIndex,
            first: i32,
            last: i32,
        );
        unsafe fn end_remove_rows(self: Pin<&mut qobject::SongModel>);

        unsafe fn begin_reset_model(self: Pin<&mut qobject::SongModel>);
        unsafe fn end_reset_model(self: Pin<&mut qobject::SongModel>);
    }

    #[cxx_qt::inherit]
    unsafe extern "C++" {
        #[cxx_name = "canFetchMore"]
        fn base_can_fetch_more(self: &qobject::SongModel, parent: &QModelIndex) -> bool;

        fn index(
            self: &qobject::SongModel,
            row: i32,
            column: i32,
            parent: &QModelIndex,
        ) -> QModelIndex;
    }

    // QAbstractListModel implementation
    impl qobject::SongModel {
        #[qinvokable(cxx_override)]
        fn data(&self, index: &QModelIndex, role: i32) -> QVariant {
            if let Some(song) = self.songs().get(index.row() as usize) {
                return match role {
                    0 => QVariant::from(&song.id),
                    1 => QVariant::from(&song.title),
                    2 => QVariant::from(&song.lyrics),
                    3 => QVariant::from(&song.author),
                    4 => QVariant::from(&song.ccli),
                    5 => QVariant::from(&song.audio),
                    6 => QVariant::from(&song.verse_order),
                    7 => QVariant::from(&song.background),
                    8 => QVariant::from(&song.background_type),
                    9 => QVariant::from(&song.horizontal_text_alignment),
                    10 => QVariant::from(&song.vertical_text_alignment),
                    11 => QVariant::from(&song.font),
                    12 => QVariant::from(&song.font_size),
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
            roles.insert(2, cxx_qt_lib::QByteArray::from("lyrics"));
            roles.insert(3, cxx_qt_lib::QByteArray::from("author"));
            roles.insert(4, cxx_qt_lib::QByteArray::from("ccli"));
            roles.insert(5, cxx_qt_lib::QByteArray::from("audio"));
            roles.insert(6, cxx_qt_lib::QByteArray::from("vorder"));
            roles.insert(7, cxx_qt_lib::QByteArray::from("background"));
            roles.insert(8, cxx_qt_lib::QByteArray::from("backgroundType"));
            roles.insert(9, cxx_qt_lib::QByteArray::from("horizontalTextAlignment"));
            roles.insert(10, cxx_qt_lib::QByteArray::from("verticalTextAlignment"));
            roles.insert(11, cxx_qt_lib::QByteArray::from("font"));
            roles.insert(12, cxx_qt_lib::QByteArray::from("fontSize"));
            roles
        }

        #[qinvokable(cxx_override)]
        pub fn row_count(&self, _parent: &QModelIndex) -> i32 {
            let cnt = self.rust().songs.len() as i32;
            // println!("row count is {cnt}");
            cnt
        }

        #[qinvokable]
        pub fn count(&self) -> i32 {
            self.rust().songs.len() as i32
        }
    }
}
