class UsersController < ApplicationController

    # loads the signup page
    # if the user is not logged in, direct them the sign up form
    # if the user is logged in, redirect them to twitter index page
    get '/signup' do
        if !logged_in?
            erb :'/users/create_user'
        else
            redirect '/tweets'
        end
    end

    # loads the login page
    # if the user is not logged in, direct them the login page
    # if the user is logged in, redirect them to twitter index page
    get '/login' do
        if !logged_in?
            erb :'/users/login'
        else
            redirect '/tweets'
        end
    end

    # submits the signup form
    # if there is a blank input, redirect them back to sign up
    # if user creates their sign in info with three params, redirect to twitter index page
    post '/signup' do
        if params[:username] == "" || params[:email] == "" || params[:password] == ""
            redirect '/signup'
        else
            @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
            @user.save
            session[:user_id] = @user.id
            redirect '/tweets'
        end
    end

    # submits the login form
    # find the user in db based on their username
    # if the user is found AND the user is authenticated,
    # set their session to their user_id
    # and redirect to twitter index page
    # otherwise, redirect to the sign up page
    post '/login' do
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect '/tweets'
        else
            redirect '/signup'
        end
    end

    # lets a user log out if they are already logged in
    get '/logout' do
        if logged_in?
            session.clear
            redirect '/login'
        else
            redirect '/'
        end
    end

    get '/users/:slug' do
        @user = User.find_by_slug(params[:slug])
        erb :'/users/show'
    end

end
