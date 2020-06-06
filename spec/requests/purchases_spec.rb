require 'rails_helper'

RSpec.describe 'Purchases', type: :request do
  include_context 'Skip Auth'

  before(:all) { Stripe.api_key ||= ENV['STRIPE_API_KEY'] }

  let(:book) { create(:ruby_on_rails_tutorial, price_cents: 299) }
  let(:purchase) { create(:purchase, book: book) }

  describe 'GET /api/purchases' do
    before do
      purchase
      get '/api/purchases'
    end

    it 'gets HTTP status 200' do
      expect(response.status).to eq 200
    end

    it 'receives the only purchase in the db' do
      expect(json_body['data'].size).to eq 1
      expect(json_body['data'].first['id']).to eq purchase.id
    end
  end # describe 'GET /api/purchases' end
end