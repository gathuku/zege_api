class V1::SessionsController < ApplicationController
  def create
    #logger.info(params[:email])
    @user= User.where(email: params[:email]).first

    if @user&.valid_password?(params[:password])
      #render :create, status: :created
      render json:{status:'success', email:@user.email, token:@user.authentication_token#}
    else
      #head(:unauthorized)
      render json:{status:"error",message:"Incorrect password or Email"}

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
