class AddPaidToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :paid, :boolean, default: false, null: false
    add_column :posts, :subscription_tier, :integer, default: 0, null: false
    add_index :posts, :paid
  end
end
