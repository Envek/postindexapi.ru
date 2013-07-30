class CreatePostIndices < ActiveRecord::Migration
  def up
    create_table :post_indices, id: false do |t|
      t.string :index,     limit:  6
      t.string :ops_name,  limit: 60
      t.string :ops_type,  limit: 50
      t.string :ops_subm,  limit:  6
      t.string :region,    limit: 60
      t.string :autonom,   limit: 60
      t.string :area,      limit: 60, index: true
      t.string :city,      limit: 60, index: true
      t.string :city_1,    limit: 60
      t.date   :act_date
      t.string :index_old, limit:  6
      t.index  :index_old
      t.index  :region
      t.index  [:region, :autonom, :area]
      t.index  [:region, :autonom, :area, :city]
      t.index  [:region, :area]
      t.index  [:region, :city]
    end
    execute 'ALTER TABLE post_indices ADD PRIMARY KEY (index);'
  end

  def down
    drop_table :post_indices
  end
end
