use ffmpeg_next::ffi::AV_TIME_BASE;
use ffmpeg_next::software::scaling::flag::BICUBIC;
use ffmpeg_next::{decoder, format, frame, media, software::scaling, Error as FFMpegError};
use image::{ImageBuffer, Rgba};
use std::error::Error;
use std::path::{Path, PathBuf};
use std::time::Instant;

pub struct ImageIter {
    input: format::context::Input,
    stream_index: usize,
    decoder: decoder::Video,
    context: Option<scaling::Context>,
}

impl ImageIter {
    pub fn new<I: AsRef<Path>>(path: I) -> Result<Self, Box<dyn Error>> {
        let input = format::input(&path)?;

        if let Some(stream) = input.streams().best(media::Type::Video) {
            let stream_index = stream.index();

            if let Ok(video) = stream.codec().decoder().video() {
                println!("Video width:{}", video.width());
                println!("Video format:{:?}", video.format());
                println!("Video height:{}", video.height());

                let mut context = None;

                if video.format() != format::Pixel::RGBA {
                    println!("Need to convert to RGBA");

                    context = Some(scaling::Context::get(
                        video.format(),
                        video.width(),
                        video.height(),
                        format::Pixel::RGBA,
                        video.width(),
                        video.height(),
                        BICUBIC,
                    )?);
                }

                return Ok(Self {
                    input,
                    stream_index,
                    decoder: video,
                    context,
                });
            }
        }

        return Err(Box::new(FFMpegError::Unknown));
    }

    pub fn seek(&mut self, time_s: f64) -> Result<(), Box<dyn Error>> {
        let timestamp = (time_s * AV_TIME_BASE as f64) as i64;

        self.input.seek(timestamp, timestamp..)?;

        Ok(())
    }
}
pub fn get_ms(now: Instant) -> f32 {
    let duration = now.elapsed();
    let nanos = duration.subsec_nanos() as f32;
    (1000000000f32 * duration.as_secs() as f32 + nanos) / (1000000f32)
}

pub impl Iterator for ImageIter {
    type Item = Result<ImageBuffer<Rgba<u8>, Vec<u8>>, Box<dyn Error>>;

    fn next(&mut self) -> Option<Self::Item> {
        let imagetime = Instant::now();
        let mut output = frame::Video::empty();

        while let Some((stream, packet)) = self.input.packets().next() {
            if stream.index() != self.stream_index {
                continue;
            }

            let decodetime = Instant::now();

            // if let Err(err) = self.decoder.decode(&packet, &mut output) {
            //     return Some(Err(Box::new(err)));
            // }

            if let Err(err) = self.decoder.send_packet(&packet) {
                return Some(Err(Box::new(err)));
            }

            if let Err(err) = self.decoder.receive_frame(&mut output) {
                return Some(Err(Box::new(err)));
            }

            println!("Image decode time: {}", get_ms(decodetime));

            if output.format() == format::Pixel::None {
                println!("Skipping null format frame");
                continue;
            }

            if let Some(ref mut context) = self.context {
                let convert_time = Instant::now();
                let mut new_output = frame::Video::empty();

                if let Err(err) = context.run(&output, &mut new_output) {
                    return Some(Err(Box::new(err)));
                }

                println!("Image convert time: {}", get_ms(convert_time));

                output = new_output;
            }

            let data = output.data(0).to_vec();

            if let Some(image) =
                ImageBuffer::<Rgba<u8>, _>::from_raw(output.width(), output.height(), data)
            {
                println!("Image read time: {}", get_ms(imagetime));
                return Some(Ok(image));
            }
        }

        None
    }
}
