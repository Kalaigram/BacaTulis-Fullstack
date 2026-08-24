class AddStripeFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :stripe_account_id, :string
    add_column :users, :stripe_onboarding_complete, :boolean, default: false, null: false
    add_index :users, :stripe_customer_id, unique: true
  end
end
