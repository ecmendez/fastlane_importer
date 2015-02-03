class FastlaneImport::GrfpOthFwspOffrProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "grfp_oth_fwsp_offr.txt"
    end
    
    def process_fields(fields)
     f = Fellowship.find_or_create_by_code(fields[0])
     f.update_attributes(:name => fields[1])
    end
    
    def delete_fields(fields)
      f = Fellowship.find_by_code(fields[0])
      f.destroy if f
    end

    
  end
end