#[derive(Debug)]
pub enum Error {
    StdIO(std::io::Error),
    UnknownArgument(&'static str, String),
    MissingArgument(&'static str),
    UnexpectedArgument(String),
}

impl From<std::io::Error> for Error {
    fn from(e: std::io::Error) -> Error {
        Error::StdIO(e)
    }
}
