require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:my_user) { User.create!(name: "Mike Smith", email: "mike@example.com", password: "password")}
#  let(:my_user) { User.create!(name: "Blochead", email: "blochead@bloc.io", password: "password") }

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success) # this only renders the new template to sign in
    end
  end

# this is actually the create action for sessionsController w/c does not have a model
# this is signing in or loggin in    into your account
  describe "POST #sessions" do
    it "returns http success" do
    #  post :create, params: { session: { email: my_user.email, password: my_user.password } }
      post :create, params: { session: { email: my_user.email } }
      expect(response).to have_http_status(:success) # this just wants to check for success or that it get through this action
      # so it actually is failing to save the session here so it renders the new page
      # which will give the :success or 200 status code
      # saving the session user_id will cause a :redirect or 302 status code
    end
    it "initializes a session" do # user is signed in or logged in
      post :create, params: { session: { email: my_user.email, password: my_user.password } }
      expect(session[:user_id]).to eq(my_user.id) # it will save the current_user user.id to the session
    end
    it "does not add a user id to session due to missing password" do # user was not signed in because of bad password
      post :create, params: { session: { email: my_user.email } }
      expect(session[:user_id]).to be_nil # therefore session[:user_id] will be nil
    end
    it "flashes #error with bad email address" do # flash message due to bad email; user was not signed in
      post :create, params: { session: { email: "bad email", password: my_user.password } }
      expect(flash.now[:alert]).to be_present # give a flash.now[:alert]
    end
    it "renders #new with bad email address" do # render back to new form due to bad email; user was not signed in
      post :create, params: { session: { email: "email does not exist", password: my_user.password } }
      expect(response).to render_template(:new)
    end
    it "redirects to the root view" do # redirects   to root_path after signing in successfully
      post :create, params: { session: { email: my_user.email, password: my_user.password } }
      expect(response).to redirect_to(root_path) # after signing in user is redirect_to the root_path
    end

  end

# signing out or logging out
  describe "DELETE #destroy" do
    it "render the #welcome view" do # after successfully signed out or logged out it redirects to the root_path
      delete :destroy, params: { id: my_user.id }
      expect(response).to redirect_to(root_path)
      expect(response).to have_http_status(:redirect)  # or 302
    end
    it "deletes the user's session" do # successfully signed out or logged out
      delete :destroy, params: { id: my_user.id }
      expect(assigns(:session)).to be_nil # session[:user_id] is now set to nil
    end
    it "flashes #notice" do # after successfully signed out   there is a flash notice he is signed out
      delete :destroy, params: { id: my_user.id }
      expect(flash[:notice]).to be_present # just checking for the flash message
    end
  end

  # add the to the UsersController that the user is signed in (or logged in) after signing up for an account

end
