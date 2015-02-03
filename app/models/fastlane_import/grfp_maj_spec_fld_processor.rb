class FastlaneImport::GrfpMajSpecFldProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      'grfp_maj_spec_fld.txt'
    end
    
    def process_fields(fields)
      if fields[1] == '0000' # gross field
        f = GrossField.find_or_create_by_fastlane_code(fields[0])
        f.update_attributes({
          :name => fields[2]
        })
      else # regular field
        gf = GrossField.find_by_fastlane_code(fields[0])
        # This depends on the fact that the "gross field" is listed before all the fields 
        # in the fastlane import file
        # Kinda hackey

        exp_date = to_datetime(fields[10])
        gf_id = gf.nil? ? nil : gf.id

        f = Field.find_or_create_by_gross_field_id_and_fastlane_code(gf_id, fields[1])
        f.update_attributes({
          :full_name => fields[2],
          :field_name => fields[3],
          :gross_field => gf,
          :expired => (exp_date && (exp_date < Time.now))
        })
      end
    end
    
    def delete_fields(fields)
      if fields[1] == '0000' # gross field
        f = GrossField.find_by_fastlane_code(fields[0])
        f.destroy if f
      else # regular field
        gf = GrossField.find_by_fastlane_code(fields[0])
        gf_id = gf.nil? ? nil : gf.id
        f = Field.find_by_gross_field_id_and_fastlane_code(gf_id, fields[1])
        f.destroy if f
      end
    end
  end
end