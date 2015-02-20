class FastlaneProcessor
  FASTLANE_FILES = %w(grfp_grad_stdy_stts grfp_maj_spec_fld grfp_panl_name grfp_prsn grfp_cntc
                      prsn_race grfp_upld_file_loc grfp_prev_expr grfp_appl grfp_ref grfp_univ_attn
                      prsn_hdcp grfp_appl_cert_dnld grfp_oth_fwsp_offr grfp_appl_oth_fwsp_offr grfp_pgm_ack_srce)
  class << self
    def process
      FASTLANE_FILES.each do |ff|
        puts "Processing #{ff}..."
        records = move_content_file_to_array(ff)
        extracted_info = FastlaneExtractor.extract(ff, records)
        FastlaneImporter.create_or_update(ff, extracted_info)
      end
    end

    private
    def import_path(file_name)
      "#{FastlaneImport::FileMover::LOCAL_DIRECTORY}/#{file_name}.txt"
    end

    def move_content_file_to_array(f)
      contents = File.read(import_path(f))
      contents = contents.dup.force_encoding('UTF-8')
      split_content = contents.split("#X:\n")
      split_content.map{|r|r.split("#_:")}
    end
  end

end