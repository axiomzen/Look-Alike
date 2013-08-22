## Test case considering only two attriubutes, requires normalization

## Chart
chart = "\u001b[31m
    4 | B                \u001b[34m 3\u001b[31m               | B  |     |        \u001b[34m3\u001b[31m  \n
    3 |                J                  |    |     |     J  |  \n
    2 |    D     G        L               |    D     G        L  \n
    1 |       F                 ___| \\    |-------F--|        |  \n
    0 | A     E\u001b[32m2\u001b[31m       I        ___|  )   | A  |  E\u001b[32m2\u001b[31m |-----I---- \n
    -1|                            | /    |    |     |     |     \n
    -2|    C     H                        |    C     H-----|     \n
    -3|                K                  |    |     |     K     \n
    -4|_\u001b[33m1\u001b[31m___________________              |_\u001b[33m1\u001b[31m__|_____|_____|____ \n
       \u001b[35m 1  2  3  4  5  6  7                 1  2  3  4  5  6  7\u001b[0m"

## Test Subjects
subject1 =
  attr_a: 1
  attr_b: -40

subject2 =
  attr_a: 3
  attr_b: 0

subject3 =
  attr_a: 7
  attr_b: 40

## Objects
objects = [
    label: 'A'
    attr_a: 1
    attr_b: 0
  ,
    label: 'B'
    attr_a: 1
    attr_b: 40
  ,
    label: 'C'
    attr_a: 2
    attr_b: -20
  ,
    label: 'D'
    attr_a: 2
    attr_b: 20
  ,
    label: 'E'
    attr_a: 3
    attr_b: 0
  ,
    label: 'F'
    attr_a: 3
    attr_b: 10
  ,
    label: 'G'
    attr_a: 4
    attr_b: 20
  ,
    label: 'H'
    attr_a: 4
    attr_b: -20
  ,
    label: 'I'
    attr_a: 6
    attr_b: 0
  ,
    label: 'J'
    attr_a: 6
    attr_b: 30
  ,
    label: 'K'
    attr_a: 6
    attr_b: -30
  ,
    label: 'L'
    attr_a: 7
    attr_b: 20
]

module.exports =
  subject1: subject1
  subject2: subject2
  subject3: subject3
  objects: objects
  chart: chart
