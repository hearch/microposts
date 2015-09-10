class RemovePrefectureFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :prefecture, :text
  end
end
