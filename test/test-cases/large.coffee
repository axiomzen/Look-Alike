## Test cases with more than two attriubutes, requires normalization

## Test Subjects
subject3 =
  attr_a: 1
  attr_b: -40
  attr_c: 0

subject4 =
  attr_a: 3
  attr_b: 0
  attr_c: 8
  attr_d: 9

subject5 =
  attr_a: 7
  attr_b: 40
  attr_c: 8
  attr_d: 9
  attr_e: 0

## Objects
objects3 = [
    label: 'A'
    attr_a: 1
    attr_b: 0
    attr_c: 1
  ,
    label: 'B'
    attr_a: 1
    attr_b: 40
    attr_c: 2
  ,
    label: 'C'
    attr_a: 2
    attr_b: -20
    attr_c: 3
  ,
    label: 'D'
    attr_a: 2
    attr_b: 20
    attr_c: 4
  ,
    label: 'E'
    attr_a: 3
    attr_b: 0
    attr_c: 5
  ,
    label: 'F'
    attr_a: 3
    attr_b: 10
    attr_c: 6
  ,
    label: 'G'
    attr_a: 4
    attr_b: 19
    attr_c: 7
  ,
    label: 'H'
    attr_a: 4
    attr_b: -18
    attr_c: 8
  ,
    label: 'I'
    attr_a: 6
    attr_b: 0
    attr_c: 9
  ,
    label: 'J'
    attr_a: 6
    attr_b: 31
    attr_c: 10
  ,
    label: 'K'
    attr_a: 6
    attr_b: -30
    attr_c: 11
  ,
    label: 'L'
    attr_a: 7
    attr_b: 20
    attr_c: 12
]

objects4 = [
    label: 'A'
    attr_a: 1
    attr_b: 0
    attr_c: 1
    attr_d: 12
  ,
    label: 'B'
    attr_a: 1
    attr_b: 40
    attr_c: 2
    attr_d: 13
  ,
    label: 'C'
    attr_a: 2
    attr_b: -20
    attr_c: 3
    attr_d: 14
  ,
    label: 'D'
    attr_a: 2
    attr_b: 20
    attr_c: 4
    attr_d: 15
  ,
    label: 'E'
    attr_a: 3
    attr_b: 0
    attr_c: 5
    attr_d: 16
  ,
    label: 'F'
    attr_a: 3
    attr_b: 10
    attr_c: 6
    attr_d: 17
  ,
    label: 'G'
    attr_a: 4
    attr_b: 19
    attr_c: 7
    attr_d: 18
  ,
    label: 'H'
    attr_a: 4
    attr_b: -18
    attr_c: 8
    attr_d: 19
  ,
    label: 'I'
    attr_a: 6
    attr_b: 0
    attr_c: 9
    attr_d: 20
  ,
    label: 'J'
    attr_a: 6
    attr_b: 31
    attr_c: 10
    attr_d: 22
  ,
    label: 'K'
    attr_a: 6
    attr_b: -30
    attr_c: 11
    attr_d: 12
  ,
    label: 'L'
    attr_a: 7
    attr_b: 20
    attr_c: 12
    attr_d: 25
]

objects5 = [
    label: 'A'
    vals:
      attr_a: 1
      attr_b: 0
      attr_c: 1
      attr_d: 12
      attr_e: 1
  ,

    label: 'B'
    vals:
      attr_a: 1
      attr_b: 40
      attr_c: 2
      attr_d: 13
      attr_e: 11
  ,

    label: 'C'
    vals:
      attr_a: 2
      attr_b: -20
      attr_c: 3
      attr_d: 14
      attr_e: 12
  ,

    label: 'D'
    vals:
      attr_a: 2
      attr_b: 20
      attr_c: 4
      attr_d: 15
      attr_e: 13
  ,

    label: 'E'
    vals:
      attr_a: 3
      attr_b: 0
      attr_c: 5
      attr_d: 16
      attr_e: 14
  ,

    label: 'F'
    vals:
      attr_a: 3
      attr_b: 10
      attr_c: 6
      attr_d: 17
      attr_e: 15
  ,

    label: 'G'
    vals:
      attr_a: 4
      attr_b: 19
      attr_c: 7
      attr_d: 18
      attr_e: 16
  ,

    label: 'H'
    vals:
      attr_a: 4
      attr_b: -18
      attr_c: 8
      attr_d: 19
      attr_e: 17
  ,

    label: 'I'
    vals:
      attr_a: 6
      attr_b: 0
      attr_c: 9
      attr_d: 20
      attr_e: 18
  ,

    label: 'J'
    vals:
      attr_a: 6
      attr_b: 31
      attr_c: 10
      attr_d: 22
      attr_e: 19
  ,

    label: 'K'
    vals:
      attr_a: 6
      attr_b: -30
      attr_c: 11
      attr_d: 12
      attr_e: 11
  ,

    label: 'L'
    vals:
      attr_a: 7
      attr_b: 20
      attr_c: 12
      attr_d: 25
      attr_e: 15
]

module.exports =
  subject3: subject3
  subject4: subject4
  subject5: subject5
  objects3: objects3
  objects4: objects4
  objects5: objects5
