class FastlaneImporterThird

  EXTRACTORS = {
    'grfp_grad_stdy_stts' => {
        id: 0,
        nsf_level_text: 1,
        active: lambda {|r|
          expiration_date = to_datetime(r[4])
          !(expiration_date && expiration_date < DateTime.now)
        }
    },

    'grfp_maj_spec_fld' => {
        fastlane_code: 0,
        gross_field_code: 1,
        name: 2,
        field_name: 3,
        expired: lambda{|r|
          expiration_date = to_datetime(r[10])
          !(expiration_date && expiration_date < DateTime.now)
        }
    },

    'grfp_panl_name' => {
        id: 0,
        name: 1,
        major_field_code: 2,
        effective_date: lambda{|r| to_datetime(r[3])},
        expiration_date: lambda{|r| to_datetime(r[4])}
    },

    'grfp_prsn' => {
        applicant_id: 0,
        first_name: 1,
        last_name: 2,
        middle_name: 3,
        prefix: 4,
        suffix: 5,
        citizen: lambda{|r|
          case r[8]
            when 'C' then 'US Citizen'
            when 'P' then 'Permanent Resident'
            else 'Unknown'
          end
        },
        birth_date: lambda{|r| to_datetime(r[9])},
        gender: 12,
        disability: lambda{|r|
          case r[13]
            when 'Y' then 'D'
            when 'N' then 'N'
            else nil
          end
        },
        updated_at: lambda{|r| to_datetime(r[15])},
        other_name: 16,
        ethnicity: lambda{|r|
          case r[18]
            when 'H' then 'H'
            when 'NH' then 'N'
            when 'D' then 'X'
            when 'N' then nil
            when 'U' then nil
          end
        },
        high_school_city: 19,
        high_school_state: 20,
        high_school_country: 21,
        permanent_resident_date: lambda{|r|to_datetime(r[22])},
        disability_description: 23,
        birth_state: 24,
        birth_country: 25,
        veteran_status: 27
    },

    'grfp_cntc' =>  {
        applicant_id: 1,
        contact_type: 0,
        telephone: 2,
        fax: 3,
        email: 4,
        street_line1: 5,
        street_line2: 6,
        street_line3: 7,
        city: 8,
        state: 9,
        country: 11,
        updated_at: lambda{|r| to_datetime(r[14])},
        us_zip: 10,
        non_us_zip: 12
    },

    'prsn_race' =>  {
          applicant_id: 0,
          race: 1
    },

    'grfp_upld_file_loc' =>  {
          applicant_id: 0,
          contribution_statement: lambda{|r| get_filename(r[2])},
          career_statement: lambda{|r| get_filename(r[3])},
          proposed_research: lambda{|r| get_filename(r[4])},
          previous_research: lambda{|r| get_filename(r[5])},
          program_eligibility: lambda{|r| get_filename(r[6])},
    },

    'grfp_prev_expr' =>  {
          applicant_id: 0,
          order: 2,
          position: 3,
          employer: 4,
          start_date: lambda{|r| to_datetime(r[5])},
          end_date:  lambda{|r| to_datetime(r[8])}
    },

    'grfp_appl' =>  {
          applicant_id: 0,
          five_year_masters: lambda{|r| to_boolean(r[2])},
          four_year_masters: lambda{|r| to_boolean(r[3])},
          academic_honors: 4,
          proposed_school_name: 6,
          interdisciplinary:  lambda{|r| to_boolean(r[8])},
          field_one_id_major: 7,
          field_one_id_specialty: 8,
          field_one_percent: 10,
          field_two_id_major: 11,
          field_two_id_specialty: 12,
          field_two_percent: 13,
          field_three_id_major:14,
          field_three_id_specialty: 15,
          field_three_percent: 16,
          field_four_id_major: 17,
          field_four_id_specialty: 18,
          field_four_percent: 19,
          highest_degree: 20,
          other_degree: 21,
          highest_degree_field_id_major: 22,
          highest_degree_field_id_specialty: 23,
          grad_study_level_id: 24,
          display_honors_list: lambda{|r| to_boolean(r[25])},
          display_honors_email: lambda{|r| to_boolean(r[26])},
          submitted_at: lambda{|r| to_datetime(r[27])},
          status: 28,
          withdraw_reason: 29,
          proposed_school_dept: 32,
          proposed_school_city: 33,
          proposed_school_state: 34,
          proposed_school_country: 35,
          field_one_other_name: 36,
          fastlane_panel_choice_id: 37,
          proposed_research_title: 38,
          proposed_research_short_title: 39,
          proposed_research_international_component: lambda{|r| to_boolean(r[40])},
          proposed_research_country_code: 41,
          proposed_program: 42
    },

    'grfp_ref' =>  {
          applicant_id: 0,
          position: 2,
          last_name: 3,
          first_name: 4,
          middle_name: 5,
          institution: 6,
          rank: 13,
          email: 7,
          submitted_at: lambda{|r| to_datetime(r[9])},
          confidential: lambda{|r| to_boolean(r[10])},
          file_name: lambda{|r| get_filename(r[8])}
    },

    'grfp_univ_attn' =>  {
        applicant_id: 0,
        sequence_number: 2,
        fastlane_inst_id: 3,
        name: 4,
        city: 5,
        state: 6,
        country: 7,
        current: lambda{|r| to_boolean(r[8])},
        start_date: lambda{|r| to_datetime(r[9])},
        end_date: lambda{|r| to_datetime(r[10])},
        degree: 11,
        degree_date: lambda{|r| r[12]},
        field_id_major: 13,
        field_id_specialty: 14,
        field_detail: 15,
        graduate_courses: lambda{|r| to_boolean(r[16])},
        dept: 17,
        grad_semester_hours: 18,
        grad_quarter_hours: 19,
        bacc_inst: lambda{|r| to_boolean(r[24])},
        gpa: lambda{|r| r[25].to_f},
        gpa_base: 26,
        has_transcript: lambda{|r| to_boolean(r[27])},
        enrollment_status: lambda{|r|
          case r[20]
            when 'F' then 'Full Time'
            when 'P' then 'Part Time'
            when 'A' then 'Not Applicable'
            when 'N' then 'Redundant'
            else nil
          end
        },
        enrollment_level: lambda{|r|
          case r[21]
            when 'G' then 'Graduate'
            when 'U' then 'Undergraduate'
            when 'A' then 'Not Applicable'
            when 'N' then 'Redundant'
            else nil
          end
        }
    },

    'prsn_hdcp' =>  {
        applicant_id: 0,
        disability: lambda{|r|
          case r[1]
            when 'N'
              'None'
            when 'O'
              'Other'
            when 'MI'
              'Mobility Impairment'
            when 'HI'
              'Hearing Impairment'
            when 'D'
              'Unknown'
            when 'VI'
              'Visual Impairment'
          end
        },
        description: 2
    },

    'grfp_appl_cert_dnld' =>  {
        applicant_id: 0,
        unlawful_action: 1,
        delinquent: 2,
        debarred: 3,
        conviction: 4,
        criminal_charges: 5,
        public_transportation: 6,
        eligibility_criteria: 7,
        essays: 8,
        sig_last_name: 9,
        sig_first_name: 10,
        sig_middle_name: 11,
        sig_ip_addr: 12,
        sig_time_stamp: lambda{|r| to_datetime(r[13])}
    },

    'grfp_oth_fwsp_offr' =>  {
        code: 0,
        name: 1
    },

    'grfp_appl_oth_fwsp_offr' =>  {
        applicant_id: 0,
        fellowship_code: 3,
        fellowship_other_code: 4
    },

    'grfp_pgm_ack_srce' =>  {
        applicant_id: 0,
        poster: lambda{|r| r[2] == 'Y'},
        faculty_member: lambda{|r| r[3] == 'Y'},
        friend_or_student: lambda{|r| r[4] == 'Y'},
        university_office: lambda{|r| r[5] == 'Y'},
        website: lambda{|r| r[6] == 'Y'},
        conference: lambda{|r| r[7] == 'Y'},
        conference_name: 8,
        other: lambda{|r| r[9] == 'Y'},
        other_name: 10,
        social_media: lambda{|r| r[13] == 'Y'},
    },

  }

  class << self
    def extract(file)
      extractors = EXTRACTORS[file]
      split_file(file).map do |row|
        {}.tap do |out|
          extractors.map do |k,v|
            out[k] = v.respond_to?(:call) ? v.call(row) : row[v].try(:strip)
          end
        end
      end
    end


    private

    def to_boolean(f)
      f == 'Y'
    end

    def to_datetime(date_str)
      date_str.blank? || date_str.nil? ? nil : DateTime.parse(date_str)
    end

    def get_filename(filename)
      if filename.blank?
        return nil
      else
        return filename.split('/')[-1]
      end
    end

    def split_file(f)
      contents = File.read(import_path(f))
      contents = contents.dup.force_encoding('UTF-8')
      split_content = contents.split("#X:\n")
      split_content.map{|r|r.split("#_:")}
    end

    def import_path(file_name)
      "#{FastlaneImport::FileMover::LOCAL_DIRECTORY}/#{file_name}.txt"
    end
  end
end
