class FastlaneImport::GrfpApplCertDnldProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "grfp_appl_cert_dnld.txt"
    end
    
    def process_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]}, :include => :cert)
      return unless a
      
      c = a.cert || a.build_cert
      
      c.update_attributes(
        :unlawful_action => fields[1],
        :delinquent => fields[2],
        :debarred => fields[3],
        :conviction => fields[4],
        :criminal_charges => fields[5],
        :public_transaction => fields[6],
        :eligibility_criteria => fields[7],
        :essays => fields[8],
        :sig_last_name => fields[9],
        :sig_first_name => fields[10],
        :sig_middle_name => fields[11],
        :sig_ip_addr => fields[12],
        :sig_time_stamp => to_datetime(fields[13])
      )
      c.save!
      a
    end
    
    def delete_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]}, :include => :cert)
      a.cert.destroy if (a && a.cert)
    end
  end
end