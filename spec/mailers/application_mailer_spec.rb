require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'instructions' do
    let!(:order) { create(:order) }
    let(:mail) { UserMailer.new_order_alerm(order).deliver }

    it 'renders the subject' do
      expect(mail.subject).to eq("there is a new order")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq(["cool.snow.mail@gmail.com"])
    end
  end
end