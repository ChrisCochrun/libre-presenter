use dirs;
use std::fs;
use std::io::{self, Write};
use std::path::{Path, PathBuf};
use std::process::Command;
use std::str;

pub fn bg_from_video(video: &Path) -> PathBuf {
    let video = PathBuf::from(video);
    println!("{:?}", video);
    println!("{:?}", video.file_name());
    let mut data_dir = dirs::data_local_dir().unwrap();
    data_dir.push("librepresenter");
    data_dir.push("thumbnails");
    if !data_dir.exists() {
        fs::create_dir(&data_dir).expect("Could not create thumbnails dir");
    }
    let mut screenshot = data_dir.clone();
    screenshot.push(video.file_name().unwrap());
    screenshot.set_extension("png");
    if !screenshot.exists() {
        let output_duration = Command::new("ffprobe")
            .args(&["-i", &video.to_string_lossy()])
            .output()
            .expect("failed to execute ffprobe");
        let mut duration = String::from("");
        let mut at_second: i32;
        at_second = 2;
        let mut log = str::from_utf8(&output_duration.stdout)
            .expect("Using non UTF-8 characters")
            .to_string();
        if let Some(duration_index) = &log.find("Duration") {
            duration = log.split_off(*duration_index + 10);
            duration.truncate(11);
            println!("rust-duration-is: {duration}");
        }
        let output = Command::new("ffmpeg")
            .args(&[
                "-i",
                &video.to_string_lossy(),
                "-ss",
                &at_second.to_string(),
                "-vframes",
                "1",
                "-y",
                &screenshot.to_string_lossy(),
            ])
            .output()
            .expect("failed to execute ffmpeg");
        io::stdout().write_all(&output.stdout).unwrap();
        io::stderr().write_all(&output.stderr).unwrap();
    } else {
        println!("Screenshot already exists");
    }
    screenshot
}
