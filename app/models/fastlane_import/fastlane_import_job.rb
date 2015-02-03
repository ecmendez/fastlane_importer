# A FastlaneImportJob is a nightly run of the fastlane import. 
class FastlaneImport::FastlaneImportJob < ActiveRecord::Base
  has_many :fastlane_import_records

  class << self
    def perform_import
      job = FastlaneImport::FastlaneImportJob.new
      job.update_attribute(:import_started, Time.now)
      job.import
      job.update_attribute(:import_finished, Time.now)

      ActiveRecord::Base.transaction do
        job.update_attribute(:processing_started, Time.now)
        job.process
        job.update_attribute(:processing_finished, Time.now)
      end
    end
    
    def latest 
      order('id desc').first
    end
  end
  
  def import
    FastlaneImport::FastlaneFile.all.each do |ff|
      ff.import_file(self) unless !ff.was_modified?
    end
  end
  
  # This method loads the imported records into the main schema,
  # translating between the Fastlane schema and the ASEE one.
  def process
    sanity_check!
    records = records_to_process
    bindin.pry
    # code tables
    run_processors([FastlaneImport::GrfpGradStdySttsProcessor,
      FastlaneImport::GrfpMajSpecFldProcessor,
      FastlaneImport::GrfpPanlNameProcessor
      ])

    # applicant creation
    applicants = run_processors([
      FastlaneImport::GrfpPrsnProcessor, FastlaneImport::GrfpCntcProcessor
    ])
    applicants.uniq!

    applicants.each do |a|
      a.reload
      a.skip_update_applicants = false
      a.update_applicants_applicant!
    end

    processors = [FastlaneImport::PrsnRaceProcessor,
      FastlaneImport::GrfpUpldFileLocProcessor,
      FastlaneImport::GrfpPrevExprProcessor,
      FastlaneImport::GrfpApplProcessor,
      FastlaneImport::GrfpRefProcessor,
      FastlaneImport::GrfpUnivAttnProcessor,
      FastlaneImport::PrsnHdcpProcessor,
      FastlaneImport::GrfpApplCertDnldProcessor,
      FastlaneImport::GrfpOthFwspOffrProcessor,
      FastlaneImport::GrfpApplOthFwspOffrProcessor,
      FastlaneImport::GrfpPgmAckSrceProcessor
    ]

    applicants = run_processors(processors)
    applicants.uniq!

    # do post-processing on the ASEE schema
    applicants.each do |a|
      a.reload
      a.set_minority_status!
      a.save!
    end
  end
  
  def records_to_process
    latest_import_id = FastlaneImport::FastlaneImportJob.latest.id
    binding.pry
    self.fastlane_import.records.where(:last_seen_import_job_id => latest_import_id).group(:fastlane_file_id).order(:id)

  end
  
  # A set of records (from previous jobs) that should be deleted,
  # because their keys were not found in the latest import job.
  def records_to_delete(fastlane_file)
    latest_import_id = FastlaneImport::FastlaneImportJob.latest.id
    FastlaneImport::FastlaneImportRecord.processed.all( 
      :conditions => ["fastlane_file_id = ? and fastlane_key not in 
        (select fastlane_key from fastlane_import_records where fastlane_file_id = ? 
        and last_seen_import_job_id = ?)", 
        fastlane_file.id, fastlane_file.id, latest_import_id], 
      :order => "fastlane_import_records.id")
  end
  
private
  def run_processors(processors)
    applicants = []
    processors.each do |p|
      new_applicants_ar = p.send(:process_records, self).select { |a| a.kind_of?(::Applicant) }
      
      applicants = applicants + new_applicants_ar
    end
    applicants
  end

  def sanity_check!
    # check for FastlaneImportRecords seen in this job - if 0, abort
    ff = FastlaneImport::FastlaneFile.find_by_file_name("grfp_prsn.txt")
    num_seen = FastlaneImport::FastlaneImportRecord.count(:conditions => 
      ["last_seen_import_job_id = ? and fastlane_file_id = ?", self.id, ff.id])
    if num_seen == 0
      raise "No records for grfp_prsn.txt!  Might be a problem with the fastlane files"
    end
  end
  
end
