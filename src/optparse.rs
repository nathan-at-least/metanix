use crate::Error;

#[derive(Debug)]
pub enum Command {
    Help,
    Build(std::path::PathBuf),
    Install(std::path::PathBuf),
}

impl Command {
    pub fn parse<I>(args: I) -> Result<Command, Error>
    where
        I: Iterator<Item = String>,
    {
        let mut popargs = PopArgs(args);

        let cmd = parse(&mut popargs)?;
        popargs.finish()?;
        Ok(cmd)
    }
}

fn parse<I>(popargs: &mut PopArgs<I>) -> Result<Command, Error>
where
    I: Iterator<Item = String>,
{
    let cmd = popargs.pop("command")?;
    if cmd == "build" || cmd == "install" {
        use std::path::PathBuf;

        let specimen = PathBuf::from(popargs.pop("specimen")?);
        Ok(match cmd.as_ref() {
            "build" => Command::Build(specimen),
            "install" => Command::Install(specimen),
            other => unreachable!("cmd: {:?}", other),
        })
    } else if cmd == "help" || cmd == "--help" {
        Ok(Command::Help)
    } else {
        Err(Error::UnknownArgument("command", cmd))
    }
}

struct PopArgs<I>(I)
where
    I: Iterator<Item = String>;

impl<I> PopArgs<I>
where
    I: Iterator<Item = String>,
{
    fn pop(&mut self, name: &'static str) -> Result<String, Error> {
        self.0.next().ok_or(Error::MissingArgument(name))
    }

    fn finish(mut self) -> Result<(), Error> {
        if let Some(arg) = self.0.next() {
            Err(Error::UnexpectedArgument(arg))
        } else {
            Ok(())
        }
    }
}
