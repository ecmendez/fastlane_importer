# Each FastlaneImportRecord represents a line in a text file received from fastlane.
class FastlaneImport::FastlaneImportRecord < ActiveRecord::Base
  belongs_to :fastlane_import_job
  belongs_to :fastlane_file
  
  before_create :create_key

  scope :records, where(aasm_state: 'imported')

  include ::AASM

  aasm do
    state :imported, :initial => true
    state :processed
    state :removed

    event :set_processed do
      transitions :to => :processed, :from => [:imported, :processed]
    end

    event :set_removed do
      transitions :to => :removed, :from => [:imported, :processed]
    end
  end
  class << self 
    # If this data is new, creates a FastlaneImportRecord
    def import_data(data, fastlane_file, job)
      data_hash = create_hash(data)
      record = where(:fastlane_file_id => fastlane_file.id, :data_hash => data_hash).first
      unless record
        record = create!(:data => data, :data_hash => h, 
          :fastlane_import_job => job, :fastlane_file => fastlane_file, 
          :last_seen_import_job_id => job.id)
      else
        record.update_attribute(:last_seen_import_job_id, job.id)
      end
      record
    end
  
    def create_hash(data)
      Digest::SHA1.hexdigest(data) 
    end
  end
  
  def fields
    fields = data.split('#_:')
    fields.last.gsub!(/#X:\z/, '')
    fields.each { |f| f.rstrip! }
    fields
  end
  
  def calculate_key
    fs = fields
    fastlane_file.key_fields.map { |index| fs[index] }.join('#_:') 
  end
  
  # Test whether this record has been processed into the main schema
  def main_record_exists?
    
    unchecked_files = ["grfp_grad_stdy_stts.txt", "grfp_cntc.txt", 
      "grfp_maj_spec_fld.txt", "grfp_panl_name.txt", "ctry.txt",
      "ctzn.txt", "ethn.txt", "pi_degr.txt", "pr_rno_code.txt", "grfp_appl_cert_txt.txt",
      "grfp_appl_oth_fwsp_offr.txt", "grfp_appl_stts.txt", "grfp_oth_fwsp_offr.txt",
      "grfp_pgm_ack_srce.txt", "grfp_prop_inst.txt"]
    
    return true if unchecked_files.include?(self.fastlane_file.file_name)
    
    key = self.fastlane_key
    case self.fastlane_file.file_name
    when "grfp_appl_cert_dnld.txt" 
      cert_exists?(key)
    when "grfp_appl.txt"
      applicant_exists?(key)
    when "grfp_gre_test.txt"
      gre_exists?(key)
    when "grfp_prev_expr.txt"
      job_exists?(key)
    when "grfp_prsn.txt"
      applicant_exists?(key)
    when "grfp_ref.txt"
      reference_exists?(key)
    when "grfp_univ_attn.txt"
      school_exists?(key)
    when "grfp_upld_file_loc.txt"
      essays_exists?(key)
    when "prsn_hdcp.txt"
      disability_exists?(key)
    when "prsn_race.txt"
      race_exists?(key)
    else
      raise "Couldn't determine if file exists for #{self.fastlane_file.file_name}"
    end
    
  end
  
private

  def create_key
    self.fastlane_key = calculate_key 
  end
  
  def cert_exists?(key)
    Cert.exists?(:applicant_id => key)
  end
  
  def applicant_exists?(key)
    Applicant.exists?(key)
  end
  
  def gre_exists?(key)
    keys = split_key(key)
    a = Applicant.find(keys[0])
    !!a.gres.find_by_sequence_number(keys[1])
  end
  
  def job_exists?(key)
    keys = split_key(key)
    Job.exists?(:applicant_id => keys[0], :order => keys[1])    
  end
  
  def reference_exists?(key)
    keys = split_key(key)
    Reference.exists?(:applicant_id => keys[0], :position => keys[1])
  end
  
  def school_exists?(key)
    keys = split_key(key)
    a = Applicant.find(keys[0])
    !!a.schools.find_by_sequence_number(keys[1])
  end
  
  def essays_exists?(key)
    Essay.exists?(:applicant_id => key)
  end
  
  def disability_exists?(key)
    keys = split_key(key)
    disability = FastlaneImport::PrsnHdcpProcessor.fix_disability_string(keys[1])
    Disability.exists?(:applicant_id => keys[0], :disability => disability)
  end
  
  def race_exists?(key)
    keys = split_key(key)
    r = FastlaneImport::PrsnRaceProcessor.find_race_from_fastlane_text(keys[1])
    a = Applicant.find(:first, :conditions => {:id => fields[0]})
    a.races.include?(r)
  end
  
  def split_key(key)
    key.split("#_:")
  end
end
