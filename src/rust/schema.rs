// @generated automatically by Diesel CLI.

diesel::table! {
    images (id) {
        id -> Integer,
        title -> Text,
        #[sql_name = "filePath"]
        path -> Text,
    }
}

diesel::table! {
    presentations (id) {
        id -> Integer,
        title -> Text,
        filePath -> Text,
        pageCount -> Nullable<Integer>,
    }
}

diesel::table! {
    songs (id) {
        id -> Integer,
        title -> Text,
        lyrics -> Nullable<Text>,
        author -> Nullable<Text>,
        ccli -> Nullable<Text>,
        audio -> Nullable<Text>,
        vorder -> Nullable<Text>,
        background -> Nullable<Text>,
        backgroundType -> Nullable<Text>,
        horizontalTextAlignment -> Nullable<Binary>,
        verticalTextAlignment -> Nullable<Binary>,
        font -> Nullable<Text>,
        fontSize -> Nullable<Integer>,
    }
}

diesel::table! {
    videos (id) {
        id -> Integer,
        title -> Text,
        #[sql_name = "filePath"]
        path -> Text,
        #[sql_name = "startTime"]
        start_time -> Nullable<Float>,
        #[sql_name = "endTime"]
        end_time -> Nullable<Float>,
        #[sql_name = "loop"]
        looping -> Bool,
    }
}

diesel::allow_tables_to_appear_in_same_query!(images, presentations, songs, videos,);
