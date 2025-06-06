require 'spec_helper'

RSpec.describe User, :type => :model do

  it { is_expected.to validate_presence_of :login }
  it { is_expected.to validate_uniqueness_of(:login).case_insensitive }
end