#import "@preview/cuti:0.2.1": show-cn-fakebold
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/gentle-clues:1.3.0": *
#import "@preview/lovelace:0.3.0": *
#import "@preview/pinit:0.2.2": *

#let school_title_pic = "./assets/sdu-title-image.jpg"
#let school_logo_pic = "./assets/sdu-pic-image.jpg"
#let school_title = "shandong university"
#let main_show_pic = "./assets/sdu-report-image-gray.png"

#let _cover_font = ("Times New Roman", "Kaiti SC")
#let _body_font = ("Times New Roman", "Songti SC")
#let _heading_font = ("Times New Roman", "Heiti SC")

#let field(label, content) = (
  [
    #set align(left + horizon)
    #block(
      width: 100%,
      stroke: (bottom: white + 0.5pt), 
      inset: (top: 0pt, bottom: 5pt),
    )[
      #set text(font: _cover_font)
      #text(size: 16pt)[#label]
    ]
  ],
  [
    #set align(center + horizon)
    #block(
      width: 100%, 
      stroke: (bottom: 0.5pt), 
      inset: (top: 0pt, bottom: 5pt),
    )[
      #set text(font: _cover_font, size: 16pt)
      #set par(first-line-indent: 0pt, leading: 0em)
      #content
    ]
  ]
)
#let showpage(
  course : "", 
  class : "", 
  author : "", 
  stdid : "", 
  college : "", 
  title : "",
  doctype : "实验报告",
) = {
  set page(
    paper: "a4",
    margin: (top: 2.12cm,bottom: 3cm,left: 1cm,right: 1cm),
    numbering: none,
  )
  show: show-cn-fakebold
  align(center)[
    #image(school_title_pic,width: 10.8cm)
    #text(font: "Times New Roman",size: 20pt,)[#upper(school_title)]
    #v(0.5cm)
    #text(font: _cover_font, size: 16pt)[#underline(stroke: 0.8pt, offset: 3pt, evade: false)[#course] #doctype]
    #image(school_logo_pic,width: 12cm)
    #v(0.0cm)
    #grid(
      columns: (80pt, 180pt),
      column-gutter: 0em,
      row-gutter: 10pt,
      ..field([主#h(2em)题],title),
      ..field([学#h(2em)院:],college),
      ..field([班#h(2em)级:],class),
      ..field([姓#h(2em)名:], author),
      ..field([学#h(2em)号:],stdid),
    )
  ]
}
#let reportpage(
  body,
) = {
  set page(
    paper: "a4",
    margin: (top: 3.03cm, bottom: 2.3cm, left: 1.4cm, right: 1.4cm),
    numbering : none,
    header-ascent: 0.45cm,
    header: [
      #align(center)[
        #move(dy: 0.45cm)[
          #image(main_show_pic, width: 4.8cm)
        ]
      ]
      #v(0.4cm)
      #move(dy: -0.3cm)[
        #line(length: 100%, stroke: 1.5pt)
      ]
    ],
    background: place(top + left, dx: 1.2cm, dy: 2.78cm)[
      #box(
        width: 100% - 1.2cm - 1.2cm,
        height: 100% - 2.78cm - 2cm,
        stroke: 1pt
      )
    ],
    footer: align(center)[
      #set text(font: _body_font, size: 16pt)
      #context[
         #counter(page).display("1") 
      ]
    ],
  )
  show: codly-init.with()
  set text(
    font: _body_font,
    size: 12pt,
    top-edge: 0.8em,
    bottom-edge: -0.2em,
  )
  set par(
    justify: true,
    leading: 0.25em, // 约 1.25 倍行距
    spacing: 1.5em, //段间距
  )
  show strong: set text(stroke: 0.02857em)
  show emph: it => {
    show regex("[\p{Unified_Ideograph}\p{Punctuation}]"): char => {
      box(skew(ax: -12deg, char))
    }
    it
  }
  set heading(numbering: "1.1.1")
  show heading : it => {
    let title_size = if it.level == 1 { 16pt }
      else if it.level == 2 { 14pt }
      else { 12pt }
    let numbering_str = if it.numbering != none {
      numbering(it.numbering, ..counter(heading).at(it.location()))
    } else { none }
    set text(font: _heading_font, size: title_size, weight: "bold")
    if it.level > 1 {
      v(0.75em, weak: true)
    }
    grid(
      columns: (auto, 1fr),
      column-gutter: 0.6em,
      align : bottom,
      [#numbering_str],
      [#it.body]
    )
    v(0.65em, weak: true)
  }
  body
  block(height: 1fr)
}
