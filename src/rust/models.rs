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
    pub start_time: Option<f32>,
    pub end_time: Option<f32>,
    pub looping: bool,
}

#[derive(Queryable)]
pub struct Presentation {
    pub id: i32,
    pub title: String,
    pub path: String,
    pub page_count: Option<i32>,
}
