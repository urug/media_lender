require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Movie do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :rating => "value for rating",
      :genre => "value for genre",
      :synopsis => "value for synopsis"
    }
  end

  it "should create a new instance given valid attributes" do
    Movie.create!(@valid_attributes)
  end
end
