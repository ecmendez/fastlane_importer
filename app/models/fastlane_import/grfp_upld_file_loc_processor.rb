#------------------------------------------------------------------------------
# FASTLANE FIELDS
#
# 0: Applicant ID
# 1: Cycle Year
# 2: Location of contribution statement pdf
# 3: Location of career statement pdf
# 4: Location of proposed research pdf
# 5: Location of previous research pdf
# 6: Location of program eligibility pdf
# 7: Last updated user
# 8: Last updated program
# 9: Last updated tmsp (whatever that is...)
#------------------------------------------------------------------------------
class FastlaneImport::GrfpUpldFileLocProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "grfp_upld_file_loc.txt"
    end
    
    def process_fields(fields)
      applicant_id = fields[0]
      a = Applicant.find(:first, :conditions => {:id => applicant_id})
      return unless a
      
      es = [ContributionStatement, CareerStatement, ProposedResearch, PreviousResearch, ProgramEligibility]
      i = 2
      es.each do |e|
        fn = get_filename(fields[i])
        if fn
          essay = e.send(:find_by_applicant_id, a.id) || e.send(:create!, {:applicant => a})
          up = essay.uploaded_pdf || UploadedPdf.find_by_file_name(fn) || UploadedPdf.new(:file_name => fn)
          up.file_name = fn
          up.save!
          essay.uploaded_pdf = up
          essay.save!
        else
          essay = e.send(:find_by_applicant_id, a.id)
          essay.destroy if essay
        end
        i += 1
      end
      nil
    end
    
    def delete_fields(fields)
      applicant_id = fields[0]
      a = Applicant.find(:first, :conditions => {:id => applicant_id})
      return unless a
      
      es = [ContributionStatement, CareerStatement, ProposedResearch, PreviousResearch, ProgramEligibility]
      i = 2
      es.each do |e|
        fn = get_filename(fields[i])
        if fn
          e.send(:destroy_all, {:applicant_id => a.id})
        end
        i += 1
      end
    end
  end
end
