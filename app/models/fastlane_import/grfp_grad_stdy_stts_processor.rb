class FastlaneImport::GrfpGradStdySttsProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "grfp_grad_stdy_stts.txt"
    end
    
    def process_fields(fields)
      gsl = GradStudyLevel.find(:first, :conditions => ["id = ?", fields[0]])
      unless gsl 
        gsl = GradStudyLevel.new
        gsl.id = fields[0]
      end
      gsl.nsf_level_text = fields[1]

      # NOTE: The data from fastlane does not match the data model!  
      # per the data model, exp date should be fields[5]
      expiration_date = to_datetime(fields[4]) 
      if expiration_date && expiration_date < DateTime.now
        gsl.active = false
      end
      gsl.save!
    end
    
    def delete_fields(fields)
      gsl = GradStudyLevel.find(:first, :conditions => ["id = ?", fields[0]])
      gsl.destroy if gsl
    end
  end
end