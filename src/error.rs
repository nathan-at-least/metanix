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

use std::fmt;

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        use Error::*;

        match self {
            StdIO(e) => write!(f, "IO Error: {}", e),
            UnknownArgument(name, val) => write!(f, "unknown <{}> {:?}", name, val),
            MissingArgument(name) => write!(f, "missing argument <{}>", name),
            UnexpectedArgument(val) => write!(f, "unexpected argument {:?}", val),
        }
    }
}
