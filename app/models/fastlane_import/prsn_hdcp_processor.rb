class FastlaneImport::PrsnHdcpProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "prsn_hdcp.txt"
    end
    
    def process_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]})
      return unless a
      
      ds = fix_disability_string(fields[1])
      
      d = a.disabilities.find_by_disability(ds) || a.disabilities.build
      
      d.disability = ds
      d.description = fields[2]
      
      d.save!
      nil
    end
    
    def delete_fields(fields)
      d = Disability.find(:first, :conditions => {:applicant_id => fields[0], 
        :disability => fix_disability_string(fields[1])})
      d.destroy if d
    end
    
    public
    
    def fix_disability_string(str)
      case str
      when 'N'
        'None'
      when 'O'
        'Other'
      when 'MI'
        "Mobility Impairment"
      when 'HI'
        'Hearing Impairment'
      when 'D'
        "Unknown"
      when 'VI'
        "Visual Impairment"
      end
    end
  end
end