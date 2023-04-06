use diesel::prelude::*;

#[derive(Queryable)]
pub struct Image {
    pub id: i32,
    pub title: String,
    pub path: String,
}
