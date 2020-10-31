const CARGO: &'static str = env!("NIXDEP_CARGO");
const CRATE2NIX: &'static str = env!("NIXDEP_CRATE2NIX");

fn main() {
    println!("Hello, world!");
    dbg!(CARGO);
    dbg!(CRATE2NIX);
}
