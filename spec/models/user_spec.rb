require "rails_helper"

RSpec.describe User, :type => :model do

  describe "validation user" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'custom method for user' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }
    context 'user' do
      it '#should check ensure_an_admin_remains method' do
        user1.destroy
        user2.destroy
        expect { user3.destroy }.to raise_error("Последний пользователь не может быть удален")
      end
    end
  end
end