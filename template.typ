// | 🙑  dismint
// | YW5uaWUgPDM=

// FUNCTIONS //

#let colorbox(
  title: "Title",
  color: "95b8d1",
  type:  "DEFAULT",
  body
) = {
  box(
    stack(
      block(
        width: 100%,
        fill: rgb(color),
        stroke: (left: (black + 0.2em), right: (rgb(color) + 0.2em)),
        inset: (left: 1em, top: 0.6em, bottom: 0.6em, right: 1em),
      )[*#title* #h(1fr) #smallcaps(text(size: 0.7em)[#type])],
      block(
        radius: (bottom: 0.3em),
        width: 100%,
        stroke: (left: (black + 0.2em), right: (rgb(color) + 0.2em), bottom: (rgb(color) + 0.2em)),
        inset: (left: 1em, top: 0.8em, bottom: 0.8em, right: 1em),
      )[#body],
    )
  )
}
#let example(
  title: "Example",
  body
) = {
  colorbox(title: title, color: "d1cfe2", type: "EXAMPLE")[#body]
}
#let define(
  title: "Definition",
  body
) = {
  colorbox(title: title, color: "b8e0d2", type: "DEFINITION")[#body]
}
#let note(
  title: "Note",
  body
) = {
  colorbox(title: title, color: "a7c7e7", type: "NOTE")[#body]
}

#let twocol(
  body_l,
  body_r
) = {
  grid(
    columns: (47%, 47%),
    column-gutter: 6%,
    body_l,
    body_r,
  )
}

#let twocola(
  body_l,
  body_r
) = {
  grid(
    columns: (47%, 47%),
    column-gutter: 6%,
    align(horizon)[#body_l],
    align(horizon)[#body_r],
  )
}

#let boxed(
  body
) = {
  rect()[$ #body $]
}

#let bimg(
  path,
  width: 50%
) = {
  align(center, rect(image(path, width: width), stroke: 0.2em, radius: 0.2em))
}

// TEMPLATE //

#let template(
  title:    "Notes",
  subtitle: "Class",
  pset:     false,
  toc:      true,
  body
) = {
  // SHOWS //
  
  // code block
  let fsize = 0.9em
  show raw.where(block: true): it => { set par(justify: false); grid(
    columns: (100%, 100%),
    column-gutter: -100%,
    par(
      leading: 0.585em,
      block(width: 100%, inset: 1.0em, for (i, line) in it.text.split("\n").enumerate() {
        box(width: 0em, align(right, text(font: "Cascadia Mono", str(i + 1), size: fsize) + h(1.5em)))
        hide(text(size: fsize)[#line])
        linebreak()
      }),
    ),
    par(
    block(radius: 1em, fill: luma(246), width: 100%, inset: 1em, text(size: fsize)[#it])),
  )}

  show raw.where(block: false): it => {
    box(fill: rgb("#EEEEEE"), outset: (y: 0.3em, x: 0.1em), radius: 0.2em, it)
  }
  
  // links
  show link: underline

  // SETS //

  set page(
    paper: "a4",
    margin: (
      x: if pset { 10% } else { 7% },
      y: if pset { 10% } else { 5% },
    ),
    numbering: "1 / 1",
  ) 
  // only set the header on the second page onward
  set page(header: locate(loc => {
    if counter(page).at(loc).first() > 1 and pset [
      *#title*
      #h(1fr)
      Justin Choi
      #box(line(length: 100%, stroke: 0.1em))
    ]
  }))
  set par(
    justify: true,
  )

  // TITLE
  par(leading: 1em)[
    #box(align(left, text(size: 2.5em)[*#title*]))
    #box(width: 1fr, line(start: (0.3em, -0.70em), length: 100%, stroke: 1em))
    #linebreak()
    // subtitle
    #box(align(left, text(size: 1.5em, fill: rgb("808080"))[*#subtitle*]))
  ]

  // TABLE OF CONTENTS //

  if toc {
    show outline.entry.where(
      level: 1
    ): it => {
      v(1em, weak: true)
      strong(it)
    }
    outline(
      indent: 1em,
      title: text(size: 1.2em)[Contents]
    )
  }

  // DIVIDING LINE //
  
  v(1em)
  if toc {
    line(start: (0em, -0.70em), length: 100%, stroke: 0.25em)
    v(-0.5em)  
  }
  
  body  
}
