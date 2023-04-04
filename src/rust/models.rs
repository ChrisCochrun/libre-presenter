use diesel::prelude::*;

#[derive(Queryable)]
pub struct Image {
    pub id: i32,
    pub title: String,
    #[diesel(column_name = "filePath")]
    pub path: String,
}
