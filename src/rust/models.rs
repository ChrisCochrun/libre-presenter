use diesel::prelude::*;

#[derive(Queryable)]
pub struct Image {
    pub id: i32,
    pub title: String,
    pub path: String,
}

#[derive(Queryable)]
pub struct Video {
    pub id: i32,
    pub title: String,
    pub path: String,
    pub start_time: f32,
    pub end_time: f32,
    pub looping: bool,
}
