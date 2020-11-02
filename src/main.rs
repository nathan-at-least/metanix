const CARGO: &'static str = env!("NIXDEP_CARGO");
const CRATE2NIX: &'static str = env!("NIXDEP_CRATE2NIX");

mod error;
mod help;
mod optparse;

pub use error::Error;

fn main() {
    if let Err(e) = inner_main() {
        println!(
            "{0} error: {1}\n\nFor usage help run: {0} --help",
            env!("CARGO_PKG_NAME"),
            e,
        );
        std::process::exit(1);
    }
}

fn inner_main() -> Result<(), Error> {
    use optparse::Command;

    let args = std::env::args().skip(1);
    match Command::parse(args)? {
        Command::Help => help::help(),
        other => unimplemented!("cmd: {:?}", other),
        /*
            Command::Build(specimen) => build(specimen),
            Command::Install(specimen) => install(specimen),
        */
    }
}
