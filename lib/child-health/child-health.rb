require 'distribution'
require 'json'

# refactor this to be more OO

# a Child has properties of age, sex, weight and height when instantiated

# subsequently we can calculate other parameters using methods height_centile, weight_centile etc

# need to add rdoc strings above methods and classes

# need to make it capable of calculating US centiles as well as UK centiles, for now they will just be separate methods, but could be refactored in the future into a single multipurpose method

module ChildHealth

  class Child

    attr_accessor :age, :sex, :weight, :height

    def initialize(age: "0", sex: "nil", weight: "0", height: "0") # named parameters can be given in any order, some can be Nil
      @age = age
      @sex = sex 
      @height = height
      @weight = weight
    end

    def height_centile
      uk_centile @height, "height_centile"
    end

    def weight_centile
      uk_centile @weight, "weight_centile"
    end

    def bmi_centile
      @bmi = @weight / (@height**2)
      uk_centile @bmi, "bmi_centile"
    end

    private

    def uk_centile(child_measurement, centile_type)

      # UK centiles use the WHO charts from 0-4 years, and the UK90 charts from 4-18 years old

      # read JSON data in from file
      lms_hash = JSON.parse File.read './data/uk90-lms-data.json'

      return ' sex must be a String and either "male" or "female" ' unless @sex == "male" || @sex == "female"

      return ' centile type must be a String and must be "height_centile", "weight_centile", or "bmi_centile" ' unless lms_hash[sex].include? centile_type

      return ' age must be a positive integer number of months and between 0 and 276 ' unless lms_hash[sex][centile_type].include? @age.to_s

      return lms_to_centile child_measurement, lms_hash[sex][centile_type][@age.to_s]
    end

    def lms_to_centile(x, lms)
      # formulae taken from http://www.cdc.gov/growthcharts/percentile_data_files.htm
      # x is the new child measurement under consideration
      # this method returns the percentile as a number from 0 to 100
      # for more information about generating centile values in code, see this blog post: http://www.bawmedical.co.uk/2014/05/10/centiles-doing-them-in-code-part-1/
      l = lms["l"].to_f
      m = lms["m"].to_f
      s = lms["s"].to_f

      if l == 0
        z = log(x / m) / s
      else
        z = (((x / m)**l) - 1) / (l * s)
      end

      puts z

      Distribution::Normal.cdf(z) * 100
    end

  end # class Child

end # module ChildHealth