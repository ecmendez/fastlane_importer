class FastlaneImport::BaseProcessor

  class << self
    
    def process_records(job)
      applicants = []
      f = FastlaneImport::FastlaneFile.find_by_file_name(file_name) 
      unless f
        raise "could not find FastlaneFile for #{file_name}"
      end
      
      delete_records = job.records_to_delete(f)
      delete_records.each do |rec|
        delete(rec)
      end
      
      records = job.records_to_process(f)
      records.each do |rec|
        applicants << process(rec)
      end
      applicants
    end

    def delete(record)
      ActiveRecord::Base.transaction do
        delete_fields(record.fields)
        record.set_removed
        record.save!
      end
    end

    def process(record)
      ActiveRecord::Base.transaction do
        applicant = process_fields(record.fields)
        record.set_processed
        record.save!
        applicant
      end
    end
    
    protected
    
    def to_boolean(f)
      f == "Y"
    end
    
    def to_datetime(date_str)
      date_str.blank? ? nil : DateTime.parse(date_str)
    end
    
    def get_filename(filename)
      if filename.blank?
        return nil
      else
        return filename.split("/")[-1]
      end
    end
    
    def make_field(major,specialty)
      f = Field.find(:first, :include => :gross_field, 
        :conditions => ["gross_fields.fastlane_code = ? and fields.fastlane_code = ? and fields.expired is not true", major, specialty])
      return f ? f.id : nil
    end
    
  end
end