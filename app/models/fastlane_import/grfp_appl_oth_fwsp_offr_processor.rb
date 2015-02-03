class FastlaneImport::GrfpApplOthFwspOffrProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "grfp_appl_oth_fwsp_offr.txt"
    end
    
    def process_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]})
      return unless a

      fellowship = ApplicantsFellowship.find(:first, :conditions => ["applicant_id = ? and fellowship_code = ?", fields[0], fields[3]])
      unless fellowship
        fellowship = ApplicantsFellowship.new(:applicant_id => fields[0], :fellowship_code => fields[3])
      end
      fellowship.fellowship_other_code = fields[4]
      fellowship.save!
    end
    
    def delete_fields(fields)
      af = ApplicantsFellowship.find(:first, :conditions => {:applicant_id => fields[0], :fellowship_code => fields[3]})
      af.destroy if af
    end
    

  end
end