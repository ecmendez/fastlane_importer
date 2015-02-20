class FastlaneImporter
  class << self
    def create_or_update(file_name, records)
      #*****************************************************
      # Importer's definitions
      # ****************************************************
      grfp_grad_stdy_stts_importer = lambda do |records|
        records.each do |attrs|
          gsl = GradStudyLevel.find_or_initialize_by(id: attrs[:id])
          gsl.update(attrs.slice(:name))
        end
      end

      grfp_maj_spec_fld_importer = lambda do |records|
        gross_fields = records.select{|r| r[:gross_field_code] == '0000'}
        gross_fields.each do |ggf|
          gf = GrossField.find_or_initialize_by(fastlane_code: ggf[:fastlane_code])
          gf.update(ggf.slice(:name))
        end

        sub_fields = records.select{|r| r[:gross_field_code] != '0000'}
        sub_fields.each do |sub_field|
            gf = GrossField.find_by(fastlane_code: sub_field[:fastlane_code])
            f = Field.find_or_initialize_by(gross_field_id: gf, fastlane_code: sub_field[:gross_field_code])
            f.update(full_name: sub_field[:name], gross_field: gf, field_name: sub_field[:field_name], expired: sub_field[:expired])
        end
      end

      grfp_panl_name_importer = lambda do |records|
        records.each do |attrs|
          p = FastlanePanelChoice.find_or_initialize_by(id: attrs[:id])
          p.update(attrs.slice(:name, :major_field_code, :effective_date, :expiration_date))
        end
      end

      grfp_prsn_importer = lambda do |records|
        records.each do |attrs|
          applicant = Applicant.find_or_initialize_by(id: attrs[:id])
          applicant.update(attrs.except(:id))
        end
      end

      grfp_cntc_importer = lambda do |records|
        records.each do |attrs|
          applicant = Applicant.find_by(id: attrs[:id])

          if attrs[:contact_type] == 'P'
            applicant.update(
                primary_address: create_or_update_address(a.primary_address, attrs),
                telephone_1: attrs[:telephone],
                fax_1: attrs[:fax],
                email: attrs[:email]
            )
          elsif attrs[:contact_type] == 'S'
            applicant.update(
                secondary_address: create_or_update_address(a.primary_address, attrs),
                telephone_2: attrs[:telephone],
                fax_2: attrs[:fax],
                email_2: attrs[:email]
            )
          end
        end
      end




      #*****************************************************
      # Main call
      # ****************************************************
      eval("#{file_name}_importer").call(records)

    end

    private
    def create_or_update_address(addr, fields)
      addr ||= Address.new
      addr.update( f.slice(:street_line1, :street_line2, :street_line3, :city, :state, :country, :updated_at)
                    .merge(f[:country] == 'US' ? f[:us_zip] : f[:non_us_zip]))
    end

  end
end