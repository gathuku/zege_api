class V1::SessionsController < ApplicationController
  def create
    @user= User.where(email: params[:email]).first

    if @user&.valid_password?(params[:password])
      render :create, status: :created
    else
      head(:unauthorized)
    end
  end

  def destroy
    user=User.where(authentication_token: params[:token]).first
    if user
    #reset Token
    user.authentication_token = nil
    user.save
    head(:ok)
    render json:{status:'success',message:'Logged out successfully'}
   else
    #render :json => 'user not found'
    render json:{status:'Error',message:'user not found'}
  end
  end
end
