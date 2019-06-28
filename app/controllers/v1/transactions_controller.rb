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
        @transaction=Transaction.new
        #@transation.amount = params[:amount]
        @transaction.amount=params[:amount]
        @transaction.user_id=user.id
        @transaction.made_to=user.id
        @transaction.trans_type="credit"
        if @transaction.save
          #Update wallet amount
          wallet_amount=user.wallet+=@transaction.amount
          user.update(wallet: wallet_amount)

          #render json: @transaction.as_json(only:[:user_id,:made_to,:trans_type,:amount])
          render json:{status:'success',message:'amount deposited',balace:user.wallet}
        else
          head(:unprocessable_entity)
        end
    else
      render json:{status:'error',message:'Missing or Incorrect Token'}
    end
  end
  #end transaction create

#Transfer amount
  def transfer
       user=get_auth_token
       if user
         email=params[:email]

         @transaction=Transaction.new
         @transaction.user_id=user.id
         @transaction.made_to=User.find_by(email:email).id
         @transaction.trans_type="debit"
         @transaction.amount=params[:amount]
         if @transaction.save
           #Update wallet amount
           wallet_amount=user.wallet-=@transaction.amount
           user.update(wallet: wallet_amount)


           #update sentTo wallet
           sentTo=User.find_by(id:@transaction.made_to)
           sent_to_wallet=sentTo.wallet+=@transaction.amount
           sentTo.update(wallet:sent_to_wallet)

           render json:{status:'success',message:'Amount sent',sentTo:email,balance:wallet_amount}
         end
       else
         render json:{status:'error',message:'Missing or Incorrect Token'}
       end
  end
#end transfer

# Balance
def balance
  user=get_auth_token
  if user
    balance =user.wallet
    render json:{status:'success',balance:balance}
  else
  render json:{status:'error',message:'Missing or Incorrect Token'}
  end
end
# End balance

#Notifications
def notifications
  user=get_auth_token
  if user
  @notifies=Transaction.where(made_to: user.id, trans_type: "credit")
  render json:@notifies
  else
  render json:{status:'error',message:'Missing or Incorrect Token'}
  end
end
#end notification

private
def transfer_params
  params.require(:transfer).permit(:email,:amount)
end

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
