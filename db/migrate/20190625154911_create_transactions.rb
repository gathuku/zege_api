class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :made_to
      t.string :trans_type
      t.float :amount

      t.timestamps
    end
  end
end
