#import "template.typ": *
#show: template.with(
  title: "Rust Guide",
  subtitle: "Justin Choi"
)

= Introduction 

== A basic Rust program

```rust
fn main() {
    println!("Hello, world!");
}
```

- Rust uses 4 spaces as their indentation convention.

== Cargo

Cargo is a useful tool for Rust that manages packages as well as makes compilation and running of Rust smoother. `cargo run` can be used to `cargo build` the `src` directory, then run the built binary. You can also run `cargo check` to see if the program will compile, which has the benefit of running extremely quickly.

The `Cargo.lock` file freezes the package versions specified in `Cargo.toml`, meaning that the setup remains reproducible, even as packages update and get newer versions.

== Basic Facts

- Variable in Rust declared with `let` are *immutable* by default. You need to specify mutability with the `mut` keyword.
- Matching is an important construct in Rust.
- The `Result` data type can either take on the `Ok` or `Err` values. We can match the result, or we can also call `.expect()` to throw an error if the value is `Err`, otherwise returning the `Ok` data.

= Common Programming Concepts

== Variables and Mutability

Variables declared with `let` are *immutable* by default, and need to be prefixed with `mut` in order to obtain mutability.

```rust
let x = 5;
let mut x = 5;
```

Variables can also be declared with `const`. Constant variables can be put in the global scope, but are always immutable and cannot take on values that are only able to be computed at runtime.

By shadowing variables, we can have some interesting interactions in Rust.

```rust
fn main() {
    let x = 5;
    // x= 5
    let x = x + 1;
    // x = 6
    {
        let x = x * 2;
        // x = 12

    }
    // x = 6
}
```

This is also an effective way to chance the type of a variable, by redeclaring and shadowing the old variable.

== Data Types

We annotate types with a colon after the name.

```rust
let x: u64;
```

Interestingly, Rust in debug mode reports overflows as an error, but does not do so in release mode, and instead uses complement wrapping.

=== Scalar Types

- `int` types `i32, u8`
- `float` types `f32, f64`
- `bool` can be `true, false`
- `char` can be `'<char>'`

Dividing two integers, results in another integer.

=== Compound Types

Tuples are very similar to Python.

```rust
fn main() {
    let tup = (500, 6.4, 1);

    let (x, y, z) = tup;
    let x = tup.0;

    println!("The value of y is: {y}");
}
```

Tuples can be indexed using a dot `(.)`, with the index of the desired value. We can also see above a basic example of *destructuring*.

#define(
  title: "Unit"
)[
  A tuple without any elements is called a *unit*, which is the default return type for a function.
]

Arrays in Rust must be a *fixed* length.

```rust
fn main() {
    let a = [1, 2, 3, 4, 5];
    let a: [i32; 5] = [1, 2, 3, 4, 5];
    // fills length 5 array with 3's
    let a = [3; 5];
}

```

== Functions

Rust doesn't care about where you define your functions, as long as they are visible in the scope of their caller.

```rust
fn test(x: i32, y: char) {}
```

There is an important distinction between an `expression` and a `statement` in Rust. We can't use the value of a statement like we can in some languages. However, we can do something interesting in rust with brackets `{}`. Since brackets constitute an expression, we can have it evaluate to a specific value by making the last line an expression without the semicolon.

```rust
// this block of code as an expression evaluates to 4
{
    let x = 3;
    x + 1
}
```

You can specify the return type of a function, and Rust will automatically return the last line as long as it is an expression.

```rust
fn five() -> i32 {
    5
}
```

== Control Flow

In Rust, similarly to Python, parenthesis on control keywords are generally not needed. Rust will not implicitly convert one type to another, for example an integer to a boolean, so all checks must be made with this in mind.

== If

```rust
fn main() {
  let number = 6;

  if number % 4 == 0 {
      println!("number is divisible by 4");
  } else if number % 3 == 0 {
      println!("number is divisible by 3");
  } else if number % 2 == 0 {
      println!("number is divisible by 2");
  } else {
      println!("number is not divisible by 4, 3, or 2");
  }
}
```

We can also use `if` in a Python-like way:

```rust
fn main() {
    let condition = true;
    let number = if condition { 5 } else { 6 };

    println!("The value of number is: {number}");
}
```

== Looping

You can loop infinitely with `loop`. One cool feature of Rust is that the `break` keyword can be used as a pseudo `return`, and the entire loop can be used as an expression. In addition, you can also labels loops to break out multiple layers, or otherwise control the flow of the program.

```rust
fn main() {
    let val = 'outer: loop {
        loop {
            break 'outer 10;
        }
    };
    println!("{val}");
}
```

Other types of loop include the traditional `while` and `for` loops.

```rust
for i in 0..10 {
    println!("{i}");
}
```

= Ownership

s
