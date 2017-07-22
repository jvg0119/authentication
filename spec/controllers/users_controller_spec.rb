require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:new_user_attributes) {{ name: "Mike Smith", email: "mike@example.com", password: "password", password_confirmation: "password"}}
  # hash to be used for creating a user

  describe "GET #new" do
    before { get :new }
    it "returns http success" do    # looks for a general 200 status code means it rendered the new template
     expect(response).to have_http_status(:success)
    end
    it "instantiates @user" do # instantiates an empty object     User.new
      expect(assigns(:user)).to be_a_new(User)
      expect(assigns(:user)).to_not be nil
    end
  end

  describe "POST #create" do
    it "returns an http redirect" do
      post :create, params: { user: new_user_attributes }
      expect(response).to have_http_status(:redirect) # this is status code 302; a redirect
                                                      # means that it created a user
     end
    it "creates a new user" do # it successfully created a user; checks the number of user(s) after
      expect{ post :create, params: { user: new_user_attributes }
    }.to change{User.count}.by(1)
    end
    it "sets the name properly" do # checks the name attribute was created
      post :create, params: { user: new_user_attributes }
      expect(assigns(:user).name).to eq(new_user_attributes[:name] )
    end
    it "sets the email properly" do
      post :create, params: { user: new_user_attributes } # checks the email attribute was created
      expect(assigns(:user).email).to eq(new_user_attributes[:email] )
    end
    it "sets the password properly" do
      post :create, params: { user: new_user_attributes } # checks the password attribute was created
      expect(assigns(:user).password).to eq(new_user_attributes[:password] )
    end
    it "sets the password confirmation properly" do # checks the password_confirmation attribute was created
      post :create, params: { user: new_user_attributes }
      expect(assigns(:user).password_confirmation).to eq(new_user_attributes[:password_confirmation] )
    end

    # add this after the sessionsController is done
    it "logs the user in after sign up" do # checks that the user is signed in (or logged in) after signin up
      post :create, params: { user: new_user_attributes }
      expect(session[:user_id]).to eq(assigns(:user).id) # it assigns the session[:user_id] to the user's id
    end
  end


  # adding delete user
  describe "DELTE #destroy" do
    before do
      @my_user = User.create!(name: "Mike Smith", email: "mike@example.com", password: "password", password_confirmation: "password")
      delete :destroy, params: { id: @my_user.id }
    end
    it "removes the user" do
      expect(User.where(id: @my_user.id).count).to eq(0)
    end
    it "redirects to the root path" do
      expect(response).to redirect_to(root_path)
    end
    it "signs out user after deleting user account" do
      expect(session[:user_id]).to be nil
    end
  end

end
