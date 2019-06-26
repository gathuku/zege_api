class V1::TransactionsController < ApplicationController
  def show
    transaction=Transaction.all
    if transaction
    #render :show
   render json: transaction.as_json(only: [:user_id, :made_to, :trans_type, :amount])
   else
    head(:unprocessable_entity)
  end
  end
  def create
  end
end
