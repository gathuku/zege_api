class V1::TransactionsController < ApplicationController
  def show
    user=get_auth_token
    if user
        transaction=Transaction.where(user_id: user.id).first
        if transaction
         #Return Json
           render json: transaction.as_json(only: [:user_id, :made_to, :trans_type, :amount])
        else
        head(:unprocessable_entity)
       end
     else
       render json:{status:'error',message:'Missing or Incorrect Token'}
     end

  end

  # transaction creates
  def create
    user=get_auth_token
    if user
        @transaction=Transaction.new(transaction_params)
        @transaction.user_id=user.id
        @transaction.made_to=user.id
        @transaction.trans_type="credit"
        if @transaction.save
          #Update wallet amount 
          render json: @transaction.as_json(only:[:user_id,:made_to,:trans_type,:amount])
        else
          head(:unprocessable_entity)
        end
    else
      render json:{status:'error',message:'Missing or Incorrect Token'}
    end
  end

private

def  transaction_params
  params.require(:transaction).permit(:amount)
end
# Get Bearer Token for request headers
  def get_auth_token
    if request.headers['Authorization'].present?
      token=request.headers['Authorization'].split(' ').last
      token_user=User.where(authentication_token: token).first

      #return the bearer Token User
      if token_user
        return token_user
      end
    end
  end
end
