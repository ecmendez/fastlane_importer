class FastlaneExtractor
  class << self
    def extract(ff, records)
      #***************************************************************************************
      # Extractor's definitions. Extractors will pick the information we need from each file.
      # **************************************************************************************
      grfp_grad_stdy_stts_extractor = lambda do |r|
        {
            :id => r[0],
            :nsf_level_text =>  r[1],
            :active => is_expired?(r[4])
        }
      end

      grfp_maj_spec_fld_extractor = lambda do |r|
        {
            :fastlane_code => r[0],
            :gross_field_code => r[1],
            :name => r[2],
            :field_name => r[3],
            :expired => is_expired?(r[10])
        }
      end

      grfp_panl_name_extractor = lambda do |r|
        {
            :id => r[0],
            :name => r[1],
            :major_field_code => r[2],
            :effective_date => to_datetime(r[3]),
            :expiration_date => to_datetime(r[4])
        }
      end

      grfp_prsn_extractor = lambda do |r|
        {
            :id => r[0],
            :first_name => r[1],
            :last_name => r[2],
            :middle_name => r[3],
            :prefix => r[4],
            :suffix => r[5],
            :citizen => fix_citizen(r[8]),
            :birth_date => to_datetime(r[9]),
            :gender => r[12],
            :disability => fix_disability(r[13]),
            :updated_at => to_datetime(r[15]),
            :other_name => r[16],
            :ethnicity => fix_ethnicity(r[18]),
            :high_school_city => r[19],
            :high_school_state => r[20],
            :high_school_country => r[21],
            :permanent_resident_date => to_datetime(r[22]),
            :disability_description => r[23],
            :birth_state => r[24],
            :birth_country => r[25],
            :veteran_status => r[27]
        }
      end

      grfp_cntc_extractor = lambda do |r|
        {
            :id => r[1],
            :contact_type => r[0],
            :telephone => r[2],
            :fax => r[3],
            :email => r[4],
            :street_line1 => r[5],
            :street_line2 => r[6],
            :street_line3 => r[7],
            :city => r[8],
            :state => r[9],
            :country => r[11],
            :updated_at => to_datetime(r[14]),
            :us_zip => r[10],
            :non_us_zip => r[12]
        }
      end

      prsn_race_extractor = lambda do |r|

      end

      grfp_upld_file_loc_extractor = lambda do |r|

      end

      grfp_prev_expr_extractor = lambda do |r|

      end

      grfp_appl_extractor = lambda do |r|

      end

      grfp_ref_extractor = lambda do |r|

      end

      grfp_univ_attn_extractor = lambda do |r|

      end

      prsn_hdcp_extractor = lambda do |r|

      end

      grfp_appl_cert_dnld_extractor = lambda do |r|

      end

      grfp_oth_fwsp_offr_extractor = lambda do |r|

      end

      grfp_appl_oth_fwsp_offr_extractor = lambda do |r|

      end

      grfp_pgm_ack_srce_extractor = lambda do |r|

      end

      #*****************************************************
      # Main call
      # ****************************************************
      #lambda to extract the important information based on the provided file
      filtering = lambda do |file_name, records|
        [].tap do |record|
          records.each{|r| record << eval("#{file_name}_extractor").call(r)}
        end
      end

      filtering.call(ff, records)
    end

    private
    def to_boolean(f)
      f == 'Y'
    end

    def to_datetime(date_str)
      date_str.blank? || date_str.nil? ? nil : DateTime.parse(date_str)
    end

    def is_expired?(r)
      expiration_date = to_datetime(r)
      if expiration_date && expiration_date < DateTime.now
        false
      end
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