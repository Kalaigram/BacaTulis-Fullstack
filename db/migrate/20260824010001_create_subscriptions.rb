class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.references :subscriber, null: false, foreign_key: { to_table: :users }
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.integer :status, default: 0, null: false
      t.string :stripe_subscription_id
      t.string :stripe_price_id
      t.string :stripe_customer_id
      t.datetime :current_period_start
      t.datetime :current_period_end
      t.datetime :canceled_at
      t.datetime :trial_end
      t.timestamps
    end

    add_index :subscriptions, :stripe_subscription_id, unique: true
    add_index :subscriptions, [ :subscriber_id, :creator_id ], unique: true
    add_index :subscriptions, [ :creator_id, :status ]
  end
end
