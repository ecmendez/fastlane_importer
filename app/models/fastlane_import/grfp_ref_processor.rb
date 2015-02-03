class FastlaneImport::GrfpRefProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "grfp_ref.txt"
    end
    
    def process_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]}, :include => :references)
      return unless a
      
      ref = a.references.find_by_position(fields[2]) || a.references.build
      
      ref.attributes = {
        :position => fields[2],
        :last_name => fields[3],
        :first_name => fields[4],
        :middle_name => fields[5],
        :institution => fields[6],
        :rank => fields[13],
        :email => fields[7],
        :submitted_at => to_datetime(fields[9]),
        :confidential => to_boolean(fields[10])
      }
      
      file_name = get_filename(fields[8])
      if file_name.blank?
        ref.uploaded_pdf = nil
      else
        up = UploadedPdf.find_by_file_name(file_name) || UploadedPdf.new
        up.file_name = file_name
        up.save!
        ref.uploaded_pdf = up
      end
      
      if ref.submitted_at
        ref.complete = true
      end
      
      ref.save!
      nil
    end
    
    def delete_fields(fields)
      r = Reference.find(:first, :conditions => {:applicant_id => fields[0], :position => fields[2] })
      r.destroy if r
    end
  end
end