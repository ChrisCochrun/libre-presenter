//! `SeaORM` Entity. Generated by sea-orm-codegen 0.11.2

use sea_orm::entity::prelude::*;

#[derive(Clone, Debug, PartialEq, DeriveEntityModel, Eq)]
#[sea_orm(table_name = "videos")]
pub struct Model {
    #[sea_orm(primary_key, auto_increment = false)]
    pub id: i32,
    pub title: String,
    #[sea_orm(column_name = "filePath")]
    pub file_path: String,
    #[sea_orm(column_name = "startTime")]
    pub start_time: i32,
    #[sea_orm(column_name = "endTime")]
    pub end_time: i32,
    #[sea_orm(column_name = "loop")]
    pub looping: bool,
}

#[derive(Copy, Clone, Debug, EnumIter, DeriveRelation)]
pub enum Relation {}

impl ActiveModelBehavior for ActiveModel {}