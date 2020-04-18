require 'rails_helper'

RSpec.describe UserMailer, :type => :mailer do
  describe 'confirmation_email' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.confirmation_email(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Confirm your Account!')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['admin@alexandria.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hello')
    end
  end

end
