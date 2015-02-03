class FastlaneImport::GrfpPrsnProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      'grfp_prsn.txt'
    end
    
    def process_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]})
      unless a
        a = Applicant.new
        a.id = fields[0]
      end
      a.skip_update_applicants = true
      a.attributes = {
        :first_name => fields[1],
        :last_name => fields[2],
        :middle_name => fields[3],
        :prefix => fields[4],
        :suffix => fields[5],
        :citizen => fix_citizen(fields[8]),
        :birth_date => to_datetime(fields[9]),
        :gender => fields[12],
        :disability => fix_disability(fields[13]),
        :updated_at => to_datetime(fields[15]),
        :other_name => fields[16],
        :ethnicity => fix_ethnicity(fields[18]),
        :high_school_city => fields[19],
        :high_school_state => fields[20],
        :high_school_country => fields[21],
        :permanent_resident_date => to_datetime(fields[22]),
        :disability_description => fields[23],
        :birth_state => fields[24],
        :birth_country => fields[25],
        :veteran_status => fields[27]
      }
      a.save!
      a
    end
    
    def delete_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]})
      a.applicants_applicant.destroy if a
      a.destroy if a
    end
    
    def fix_citizen(c)
      case c
      when 'C' then 'US Citizen'
      when 'P' then 'Permanent Resident'
      else 'Unknown'
      end
    end
    
    def fix_disability(d)
      case d
      when 'Y' then 'D'
      when 'N' then 'N'
      else nil
      end
    end
    
    def fix_ethnicity(e)
      case e
      when 'H' then 'H'
      when 'NH' then 'N'
      when 'D' then 'X'
      when 'N' then nil
      when 'U' then nil
      end
    end
  end
end
