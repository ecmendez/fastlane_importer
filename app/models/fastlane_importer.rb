class FastlaneImporter

  IMPORTERS = {
      'grfp_grad_stdy_stts' => lambda{|attrs|
        gsl = GradStudyLevel.find_or_initialize_by(id: attrs[:id])
        gsl.update(attrs.slice(:name))
      },

      'grfp_maj_spec_fld' => lambda{|attrs|
         if attrs[:gross_field_code] == '0000'
           gf = GrossField.find_or_initialize_by(fastlane_code:  attrs[:gross_field_code])
           gf.update(attrs.slice(:name))
         else
           gf = GrossField.find_by(fastlane_code:  attrs[:gross_field_code])
           f = Field.find_or_initialize_by(gross_field_id: gf, fastlane_code: attrs[:fastlane_code])
           f.update(full_name: attrs[:name], gross_field: gf, field_name: attrs[:field_name], expired: attrs[:expired])
         end
      },

      'grfp_panl_name' => lambda{|attrs|
        p = FastlanePanelChoice.find_or_initialize_by(id: attrs[:id])
        p.update(attrs.slice(:name, :major_field_code, :effective_date, :expiration_date))
      },

      'grfp_prsn' => lambda{|attrs|
        applicant = Applicant.find_or_initialize_by(id: attrs[:applicant_id])
        applicant.update(attrs.except(:applicant_id))
      },

      'grfp_cntc' => lambda{|attrs|
        applicant = Applicant.find_by(id: attrs[:applicant_id])
        applicant.update(attrs.except(:applicant_id))
        if attrs[:contact_type] == 'P'
          applicant.update(
              primary_address: create_or_update_address(applicant.primary_address, attrs),
              telephone_1: attrs[:telephone],
              fax_1: attrs[:fax],
              email: attrs[:email]
          )
        elsif attrs[:contact_type] == 'S'
          applicant.update(
              secondary_address: create_or_update_address(applicant.primary_address, attrs),
              telephone_2: attrs[:telephone],
              fax_2: attrs[:fax],
              email_2: attrs[:email]
          )
        end
      },

      'prsn_race' => lambda{|attrs|
        applicant = Applicant.find(attrs[:applicant_id]).include(:races)
        race = Race.find_by(fastlane_text: attrs[:fastlane_text])
        unless race.nil? || applicant.races.include?(race)
          applicant.races << race
          applicant.save!
        end
      },

      'grfp_upld_file_loc' => lambda{|attrs|
        statement_files = attrs.except(:applicant_id)
        statement_files.each do |k,v|
          essay = Essay.find_or_initialize_by(applicant_id: attrs[:applicant_id], file_type: k)
          if v
            up = essay.uploaded_pdf || UploadedPdf.find_by_file_name(v) || UploadedPdf.new(:file_name => v)
            up.update(file_name: v)
            essay.update(uploaded_pdf: up, file_type: k.to_s.camelize)
          else
            essay.try(:destroy)
          end
        end
      },

      'grfp_prev_expr' => lambda{|attrs|
        applicant = Applicant.find(attrs[:applicant_id]).include(:jobs)
        j = applicant.jobs.where(:order => attrs[:order]).first
        job = (j || Job.new(:applicant_id => applicant))
        job.update(attrs.except(:id))
      },

      'grfp_appl' => lambda{|attrs|
        applicant = Applicant.find(attrs[:applicant_id]).include(:study)
        study = (applicant.study || Study.new(:applicant_id => applicant))
        study.update(attrs.slice(
                     :five_year_masters, :four_year_masters, :academic_honors, :proposed_school_name,
                     :interdisciplinary, :highest_degree, :other_degree, :grad_study_level_id,
                     :display_honors_list, :display_honors_email, :submitted_at, :field_one_percent,
                     :field_two_percent, :field_three_percent, :field_four_percent)
                 .merge(:field_one_id => make_field(attrs[:field_one_id_major], attrs[:field_one_id_specialty]))
                 .merge(:field_two_id => make_field(attrs[:field_two_id_major], attrs[:field_two_id_specialty]))
                 .merge(:field_three_id => make_field(attrs[:field_three_id_major], attrs[:field_three_id_specialty]))
                 .merge(:field_four_id => make_field(attrs[:field_four_id_major], attrs[:field_four_id_specialty]))
              )

        case attrs[:status]
          when 'B' then applicant.late_submission!
          when 'S' then applicant.submitted!
          when 'U' then applicant.unsubmitted!
          when 'W' then applicant.withdrawn!
          when 'C' then applicant.deleted!
          else applicant.no_status!
        end
        applicant.save!
      },

      'grfp_ref' => lambda{|attrs|
        applicant = Applicant.find(attrs[:applicant_id]).include(:references)
        ref = applicant.references.find_by(position: attrs[:position]) || applicant.references.build

        ref.update(attrs.except(:applicant_id, :file_name).merge(:complete => !attrs[:submitted_at].nil?))

        if attrs[:file_name].blank?
          ref.uploaded_pdf = nil
        else
          up = UploadedPdf.find_by_file_name(attrs[:file_name]) || UploadedPdf.new
          up.update(file_name: attrs[:file_name])
          ref.update(uploaded_pdf: up)
        end
      },

      'grfp_univ_attn' => lambda{|attrs|
        applicant = Applicant.where(:id => attrs[:applicant_id]).first
        schools = applicant.schools.where(sequence_number: attrs[:sequence_number]).first
        schools = applicant.build_school
        schools.update(attrs.except(:applicant_id))
      },

      'prsn_hdcp' => lambda{|attrs|
        applicant = Applicant.where(:id => attrs[:applicant_id]).first
        disability = applicant.disabilities.find_by_disability(attrs[:disability]) || applicant.disabilities.build
        disability.update(description: attrs[:description])
      },

      'grfp_appl_cert_dnld' => lambda{|attrs|
        applicant = Applicant.where(:id => attrs[:applicant_id]).include(:cert).first
        cert = a.cert || a.build_cert
        cert.update(attrs.except(:applicant_id))
      },

      'grfp_oth_fwsp_offr' => lambda{|attrs|
        fellowship = Fellowship.find_or_initiliaze(code: attrs[:code])
        fellowship.update(attrs.except(:code))
      },

      'grfp_appl_oth_fwsp_offr' => lambda{|attrs|
        applicant = Applicant.where(:id => attrs[:applicant_id]).first
        fellowship = ApplicantsFellowship.find_or_initialize_by(applicant_id: attrs[:applicant_id], fellowship_code: attrs[:fellowship_code])
        fellowship.update(other_code: attrs[:other_code])
      },

      'grfp_pgm_ack_srce' => lambda{|attrs|
        applicant = Applicant.where(:id => attrs[:applicant_id]).include(:jobs).first
        source = (applicant.source || Source.create(:applicant => applicant))
        source.update(attrs.except(:applicant_id))
      }
  }

  class << self
    def create_or_update(file, records)
      puts "* Importing #{file}..."
      importer = IMPORTERS[file]
      records.map do |record|
        importer.call(record)
      end
    end

    private
    def create_or_update_address(addr, fields)
      addr ||= Address.new
      addr.update( f.slice(:street_line1, :street_line2, :street_line3, :city, :state, :country, :updated_at)
                    .merge(f[:country] == 'US' ? f[:us_zip] : f[:non_us_zip]))
    end

    def make_field(major,specialty)
      Field.find(:first,
                 :include => :gross_field,
                 :conditions => ['gross_fields.fastlane_code = ? and fields.fastlane_code = ? and fields.expired is not true', major, specialty])
    end

  end
end