# child-health
A Ruby Gem for calculating important medical child health parameters such as growth charts and BMI-centile

This gem can be used from the command line (eg for testing/evaluation of the gem) and also in other Ruby programs. The centile code has been abstracted out from the Clinical Calculator API, in order to make the code more reusable.

LICENSE: GPL v3

## Installation

`gem install child-health`
(use `sudo` if you are not using RVM to manage rubies and gemsets)

## Command-line usage

`centile <age> <sex> <height> <weight>`

* `<age>` must be in **months** since birth (a future API might include helpful years+months.to_months functionality)
* `<sex>` can be the string literal "male" or "female" only. (note that in this context, sex is different to sexual identity/gender, hence why there are only 2 options - most people are genotypically either male or female, those few that are 'intersex' may require special growth charts, for which specialist paediatric endocrinology advice is often necessary)
* `<height>` is in centimetres (this is just convention for child measurement in the UK)
* `<weight>` is in kg

## Use in other Ruby programs

The module `ChildHealth` gives you, at present, just one new class called `Child`, which has some methods allowing you to get and set the parameters `age`, `sex`, `height` and `weight`, and methods which return the child's `height_centile`, `weight_centile`, and `bmi_centile`.

I've designed it in this way to allow easy extensibility if there are other child health parameters that need to be added later. Whatever the parameter, as long as it is something that makes sense as a property of a Child object, it should make OO sense.

Install the gem either with `gem install child-health` from the command line, or by adding `gem 'child health'` to your Gemfile and running `bundle install`

In your Ruby program or IRB:

`require 'child-health'` 

Instantiate a Child object:

`child = ChildHealth::Child.new(age: <age>, sex: <sex>, height: <height>, weight: <weight>)``

Note the use of named parameters in the arguments to Child.new - this means that the parameters can be given in any order. 

The defaults are (age: 0, sex: nil height: 0 weight: 0) - they are set like this mainly to avoid the need for loads of error handling during initial gem creation.

The instantiation should return a Child object, here's an example:

`2.3.0 :113 > child = ChildHealth::Child.new(age: 54, height: 112, weight: 21, sex: "male")``
`=> #<ChildHealth::Child:0x00000001e596a0 @age=54, @sex="male", @weight=21.0, @height=112.0>`` 


This object has some other methods which will return the parameters we are interested in calculating:

`ChildHealth::Child#height_centile #=> returns the centile`
`ChildHealth::Child#weight_centile`
`ChildHealth::Child#bmi_centile`

##What are these 'Centiles' anyway?
Centiles (short for Percentiles) are a statistical measure of where a gievn measurement is within its population. In the case of chilld growth, we want to know how this child compares to other children of the same sex, and at exactly the same age.

A simple way to interpret a percentile is to think of it as the percentage of children that are *shorter* (for height centile), or *weigh less* (for weight centile), or are *thinner* (for BMI centile) than the child we're testing.

In medical practice, a single centile on its own is of almost no use, and we take into account numerous centile observations over time when making clinical decisions. A child whose centiles change rapidly (either up or down) over a short period of time may present a cause for concern.

Further information:

[Royal College of Paediatrics and Child Health](http://www.rcpch.ac.uk/growthcharts/)

[My article on centiles for openhealthhub.org](https://www.openhealthhub.org/t/centile-part-1-what-are-centiles/463)

[Another article I did for my own blog](http://www.bawmedical.co.uk/centiles-doing-them-in-code-part-1.html)

©Marcus Baw 2017 - see LICENSE for further information
