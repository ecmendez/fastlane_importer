class FastlaneImport::FastlaneFile < ActiveRecord::Base
  has_many :fastlane_import_record

  serialize :key_fields

  def import_file(job)
    ActiveRecord::Base.transaction do
      puts "Importing #{self.file_name}"
      contents = File.binread(self.import_path)
      split_content = contents.split("#X:\n")
      split_content.each do |line|
        fastlane_import_record.import_data(line, self, job)
      end

      self.update_attributes(filemtime: File.open(self.import_path).mtime)
    end
  end

  def import_path
    "#{FastlaneImport::FileMover::LOCAL_DIRECTORY}/#{file_name}"
  end

  def was_modified?
    current_filemtime = File.open(self.import_path).mtime
    self.filemtime.nil? ? true : current_filemtime > self.filemtime
  end
  
end
