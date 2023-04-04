// pub fn add(left: usize, right: usize) -> usize {
//     left + right
// }

// #[cfg(test)]
// mod tests {
//     use super::*;

//     #[test]
//     fn it_works() {
//         let result = add(2, 2);
//         assert_eq!(result, 4);
//     }
// }
const DATABASE_URL: &str = "sqlite://library-db.sqlite3";
const DB_NAME: &str = "library_db";

// mod my_object;
mod file_helper;
mod service_thing;
mod settings;
mod slide_obj;
mod slide_model;
mod image_model;
mod entities;
// mod video_thumbnail;
