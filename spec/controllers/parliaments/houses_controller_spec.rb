require 'rails_helper'

RSpec.describe Parliaments::HousesController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index, params: { parliament_id: 'fHx6P1lb' }
    end

    it 'should have a response with http status ok (200)'do
      expect(response).to have_http_status(:ok)
    end

    context '@parliament' do
      it 'assigns @parliament' do
        expect(assigns(:parliament)).to be_a(Grom::Node)
        expect(assigns(:parliament).type).to eq('https://id.parliament.uk/schema/ParliamentPeriod')
      end
    end

    context '@house' do
      it 'assigns @houses' do
        assigns(:houses).each do |house|
          expect(house).to be_a(Grom::Node)
          expect(house.type).to eq('https://id.parliament.uk/schema/House')
        end
      end
    end

    it 'renders the houses template' do
      expect(response).to render_template('index')
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
          {
            route: 'index',
            parameters: { parliament_id: 'fHx6P1lb' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliament_houses?parliament_id=fHx6P1lb"
          }
        ]

      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
      end

      it 'should have a response with http status redirect (302)' do
        methods.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to have_http_status(302)
        end
      end

      it 'redirects to the data service' do
        methods.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to redirect_to(method[:data_url])
        end
      end

    end
  end
end
