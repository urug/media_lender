module BuilderStepHelpers

  def create_model(model_name, attributes={})
    send("create_#{model_name.gsub(' ','_')}",attributes)
  end

end
World(BuilderStepHelpers)

# Examples:
# Given the following widgets:
# | Name  | Price |
# | Foo   | 20.00 |
# Given the following pet:
# |  Pet Type | Months Old     |
# | Dog       | 23             |
# | Cat       | 34             |
Given /^the following (.+?)(?:s|):$/ do |model_name, table|
  table.hashes.each do |hash|
    attributes = {}
    hash.each { |k, v| attributes[k.gsub(' ','').underscore] = v }
    create_model(model_name, attributes)
  end
end

# Example:
# Given widgets named 'Foo', 'Bar', and 'Car' exist
Given /^(.+?)(?:s|) named (.+) exist$/ do |model_name, names|
  names.extract_list.each do |name|
    create_model(model_name, {:name => name})
  end
end

# Example:
# Given an expensive widget exists  (assumes you have a create_expensive_widget method)
# Given a widget exists
# Given 3 widgets exist
# Given 33 widgets exist
#
# Warning: this one can be a little too greedy at times so YMMV from project to project.
Given /^(a|an|\d+) (.+?)(?:s|) exist(?:s|)$/ do |ammount, model_name|
  how_many = ammount =~ /a|an/ ? 1 : ammount.to_i
  1.upto(how_many) { create_model(model_name) }
end

