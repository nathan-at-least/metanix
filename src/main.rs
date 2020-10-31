const CARGO: &'static str = env!("NIXDEP_CARGO");
const CRATE2NIX: &'static str = env!("NIXDEP_CRATE2NIX");

mod error;
mod optparse;

pub use error::Error;

fn main() -> Result<(), Error> {
    use optparse::Command;

    let args = std::env::args().skip(1);
    let cmd = Command::parse(args)?;
    unimplemented!("cmd: {:?}", cmd);
    /*
    match Command::parse(args)? {
        Command::Help => help(),
        Command::Build(specimen) => build(specimen),
        Command::Install(specimen) => install(specimen),
    }
    */
}
