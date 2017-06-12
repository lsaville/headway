require 'rails_helper'
require 'cancan/matchers'

describe Canard::Abilities, '#principles' do
  let(:acting_principle) { FactoryGirl.create(:user, :principle) }

  subject(:principle_ability) { Ability.new(acting_principle) }

  describe 'on User' do
    let(:user) { FactoryGirl.create(:user) }

    it { is_expected.to be_able_to(:manage, user) }
    it { is_expected.to_not be_able_to(:destroy, user) }
  end
  # on User
end
