class CreateMemberFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :member_friendships do |t|
      t.references :friend1, index: true, foreign_key: { to_table: :members }
      t.references :friend2, index: true, foreign_key: { to_table: :members }

      t.index %i[friend1_id friend2_id], name: 'uniq_friendships', unique: true
    end
  end
end
