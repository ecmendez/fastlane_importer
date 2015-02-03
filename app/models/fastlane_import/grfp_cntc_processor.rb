class FastlaneImport::GrfpCntcProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "grfp_cntc.txt"
    end
    
    def process_fields(fields)
      applicant_id = fields[1]
      contact_type = fields[0]
      ap = Applicant.find(applicant_id)
      ap.skip_update_applicants = true
      if contact_type == "P"
        ap.primary_address = create_or_update_address(ap.primary_address, fields)
        ap.telephone_1 = fields[2]
        ap.fax_1 = fields[3]
        ap.email = fields[4]
      elsif contact_type == "S"
        ap.secondary_address = create_or_update_address(ap.secondary_address, fields)
        ap.telephone_2 = fields[2]
        ap.fax_2 = fields[3]
        ap.email_2 = fields[4]
      end
      ap.save!
      ap
    end
    
    def create_or_update_address(addr, fields)
      addr ||= Address.new
      update_address(addr, fields)
      addr
    end
    
    def update_address(addr, fields)
      addr.attributes = {
        :street_line1 => fields[5],
        :street_line2 => fields[6],
        :street_line3 => fields[7],
        :city => fields[8],
        :state => fields[9],
        :country => fields[11],
        :updated_at => to_datetime(fields[14]),
      }
      if addr.country == "US"
        addr.zip = fields[10]
      else
        addr.zip = fields[12]
      end
      addr.save!
    end
    
    def delete_fields(fields)
      applicant_id = fields[1]
      contact_type = fields[0]
      ap = Applicant.find(:first, :conditions => {:id => applicant_id})
      return unless ap
      if contact_type == "P"
        ap.primary_address.destroy if ap.primary_address
        ap.telephone_1 = nil
        ap.fax_1 = nil
        ap.email = nil
      elsif contact_type == "S"
        ap.secondary_address.destroy if ap.secondary_address
        ap.telephone_2 = nil
        ap.fax_2 = nil
        ap.email_2 = nil        
      end
      ap.save!
    end
  end
end