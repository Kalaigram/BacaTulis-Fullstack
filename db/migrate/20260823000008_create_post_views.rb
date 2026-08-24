class CreatePostViews < ActiveRecord::Migration[8.1]
  def change
    create_table :post_views do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.string :ip_address
      t.string :user_agent
      t.datetime :viewed_at, null: false
      t.timestamps
    end

    add_index :post_views, [ :post_id, :viewed_at ]
    add_index :post_views, [ :user_id, :viewed_at ]
  end
end
