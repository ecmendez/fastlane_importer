class AddFilemtimeToFastlaneFile < ActiveRecord::Migration
  def change
    add_column :fastlane_files, :filemtime, :datetime
  end
end
