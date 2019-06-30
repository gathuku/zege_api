class V1::UsersController < ApplicationController
  def index
    @user =User.all
  end
  def create

    @user=User.new
    @user.email=params[:email]
    @user.password=params[:password]
    @user.password_confirmation=params[:password_confirmation]
    @user.authentication_token=SecureRandom.alphanumeric
    if @user.save
      render json:{status:'success',message:'Registered',token:@user.authentication_token}
    else
      #head(:unprocessable_entity)
      render json:{status:'error',message:'Email Taken'}
    end
  end

  @private
  def user_params
    params.require(:user).permit(:email,:password,:password_confirmation)
  end
end
