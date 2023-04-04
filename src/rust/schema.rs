// @generated automatically by Diesel CLI.

diesel::table! {
    images (id) {
        id -> Integer,
        title -> Text,
        filePath -> Text,
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
        filePath -> Text,
        startTime -> Nullable<Float>,
        endTime -> Nullable<Float>,
        #[sql_name = "loop"]
        loop_ -> Bool,
    }
}

diesel::allow_tables_to_appear_in_same_query!(
    images,
    presentations,
    songs,
    videos,
);
