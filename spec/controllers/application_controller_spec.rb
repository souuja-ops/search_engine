require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
    describe 'set_current_user' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        user = User.create(email: 'test@example.com', password: 'password')
        sign_in user
      end
  
      it 'sets @current_user to the currently logged in user' do
        controller.send(:set_current_user)
        expect(assigns(:current_user)).to eq(user)
      end
    end
end
  