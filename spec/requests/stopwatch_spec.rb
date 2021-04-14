require 'rails_helper'

RSpec.describe "Stopwatches", type: :request do
  let(:user) { create(:user) }
  describe "GET #index" do
    it "exists and responds" do
      login_as(user)
      get user_stopwatches_path user_id: user
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    before :each do
      login_as(user)
    end
    it "assigns a requested to @stopwatch" do
      stopwatch = create(:stopwatch)
      get user_stopwatch_path(user, stopwatch)
      expect(assigns(:stopwatch)).to eq stopwatch
    end

    it "renders the :show template" do
      stopwatch = create(:stopwatch)
      get user_stopwatch_path(user, stopwatch)
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before :each do
      @stopwatch = create(:stopwatch, user: user)
      login_as(user)
    end

    context 'with valid attributes' do
      before(:each) do
        @laps = Array.new(3){ attributes_for(:lap) }
      end
      it "saves the stopwatch in the database" do
        expect{
          post user_stopwatches_path(user), params: {stopwatch: attributes_for(:stopwatch), laps: @laps}
        }.to change(Stopwatch, :count).by(1)
      end

      it "renders json @stopwatch" do
        post user_stopwatches_path(user), params: {stopwatch: attributes_for(:stopwatch), laps: @laps}
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid attributes' do 
      it "does not save the stopwatchin the databse" do 
        expect{
          post user_stopwatches_path(user), params: {stopwatch: attributes_for(:stopwatch, label: nil)}
        }.not_to change(Stopwatch, :count)
      end

      it "re-renders the index template" do
        post user_stopwatches_path(user), params: {stopwatch: attributes_for(:stopwatch, label: nil)}
        expect(response).to redirect_to user_stopwatches_path(user)
      end
    end
  end

  describe 'PATCH #update' do
    before :each do 
      @stopwatch = create(:stopwatch, user: user)
      login_as(user)
    end
    context 'with valid attributes' do
      it "locates the requested @stopwatch" do 
        patch user_stopwatch_path(user, @stopwatch), params: {stopwatch: attributes_for(:stopwatch)}
        expect(assigns(:stopwatch)).to eq(@stopwatch)
      end

      it "updates the  in the database" do
        lap = attributes_for(:lap)
        expect{
          patch user_stopwatch_path(user, @stopwatch), params: attributes_for(:lap)
        }.to change(Lap, :count).by(1)
      end

      it "redirects to the stopwatchindex" do
        patch user_stopwatch_path(user, @stopwatch), params: {time: nil, differece: 1010}
        expect(response).to redirect_to user_stopwatches_path(user)
      end
    end

    context 'with invalid attributes' do
      it "does not update the stopwatch" do
        patch user_stopwatch_path(user, @stopwatch), params: {stopwatch: attributes_for(:stopwatch, label: 'NewTime', user: nil)}
        @stopwatch.reload
        expect(@stopwatch.label).not_to eq('NewTime')
      end

      it "redirects to new template" do
        patch user_stopwatch_path(user, @stopwatch), params: {stopwatch: attributes_for(:stopwatch, label: 'NewTime', user: nil)}
        expect(response).to redirect_to user_stopwatches_path(user)
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @stopwatch = create(:stopwatch, user: user)
      login_as(user)
    end

    it "deletes the timezone from the database" do
      expect {
        delete user_stopwatch_path(user, @stopwatch)
      }.to change(Stopwatch, :count).by(-1)
    end

    it "redirects to stopwatchindex" do
      delete user_stopwatch_path(user, @stopwatch)
      expect(response).to redirect_to user_stopwatches_path(user)
    end
  end

  describe 'Decorators' do
    it "evaluate stopwatch decorator to display lap time and difference time" do
      lap = create(:lap, time: 15, difference: 10)
      expect(StopwatchDecorator.new(lap).display_lap_time).to eq "00:00:15"
      expect(StopwatchDecorator.new(lap).display_lap_difference).to eq "00:00:10"
    end
  end

end
