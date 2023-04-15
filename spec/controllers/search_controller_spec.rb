RSpec.describe SearchesController, type: :controller do
    describe '#create' do
      let(:user) { create(:user) }
      let(:article) { create(:article) }
      
      before do
        sign_in user
      end
      
      context 'when search query is valid' do
        it 'creates a new search record for the current user' do
          post :create, params: { query: article.title }
          expect(user.searches.count).to eq(1)
          expect(user.searches.last.query).to eq(article.title)
        end
        
        it 'returns a success response with message' do
          post :create, params: { query: article.title }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['message']).to eq('Search saved successfully')
        end
      end
      
      context 'when search query is invalid' do
        it 'does not create a new search record' do
          post :create, params: { query: 'invalid query' }
          expect(user.searches.count).to eq(0)
        end
        
        it 'returns an error response with message' do
          post :create, params: { query: 'invalid query' }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to eq('Invalid search query')
        end
      end
      
      context 'when user is not logged in' do
        before do
          sign_out user
        end
        
        it 'redirects to the login page' do
          post :create, params: { query: article.title }
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end
  