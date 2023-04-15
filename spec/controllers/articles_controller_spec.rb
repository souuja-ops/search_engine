RSpec.describe ArticlesController, type: :controller do
    describe 'GET #index' do
      it 'assigns @articles' do
        article1 = FactoryBot.create(:article)
        article2 = FactoryBot.create(:article)
        get :index
        expect(assigns(:articles)).to eq([article1, article2])
      end
  
      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  
    describe 'GET #search' do
      it 'assigns @articles' do
        article1 = FactoryBot.create(:article, title: 'Foo Bar')
        article2 = FactoryBot.create(:article, title: 'Baz')
        get :search, params: { query: 'foo' }
        expect(assigns(:articles)).to eq([article1])
      end
  
      it 'renders the search template' do
        get :search, params: { query: 'foo' }, format: :js
        expect(response).to render_template(:search)
      end
    end
  
    describe 'GET #show' do
      let(:user) { FactoryBot.create(:user) }
      before { sign_in user }
  
      it 'assigns @search_data' do
        FactoryBot.create(:search, user: user, search_time: Time.now)
        get :show
        expect(assigns(:search_data)).to eq({ Date.today => 1 })
      end
  
      it 'assigns @user_search_data' do
        search1 = FactoryBot.create(:search, user: user, query: 'foo')
        search2 = FactoryBot.create(:search, user: user, query: 'bar')
        get :show
        expect(assigns(:user_search_data)).to eq({ "#{search1.query},#{search1.user_id}" => 1, "#{search2.query},#{search2.user_id}" => 1 })
      end
  
      it 'assigns @most_searched_terms' do
        search1 = FactoryBot.create(:search, user: user, query: 'foo')
        search2 = FactoryBot.create(:search, user: user, query: 'bar')
        get :show
        expect(assigns(:most_searched_terms)).to eq({ 'foo' => 1, 'bar' => 1 })
      end
  
      it 'renders JSON with the expected data' do
        FactoryBot.create(:search, user: user, search_time: Time.now)
        get :show, format: :json
        expect(response.body).to eq({
          search_data: { Date.today.to_s => 1 },
          user_search_data: { "foo,#{user.id}" => 1 },
          most_searched_terms: { 'foo' => 1 }
        }.to_json)
      end
    end
  end
  