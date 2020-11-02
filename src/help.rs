use crate::Error;

pub fn help() -> Result<(), Error> {
    println!(include_str!("help.txt"), PROGNAME = env!("CARGO_PKG_NAME"));
    Ok(())
}
