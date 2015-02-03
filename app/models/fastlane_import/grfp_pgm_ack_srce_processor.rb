#------------------------------------------------------------------------------
# FASTLANE FIELDS
#
# 0: Applicant ID
# 1: Cycle Year
# 2: Outreach response source: Poster
# 3: Outreach response source: Faculty Members
# 4: Outreach response source: Friend or Student
# 5: Outreach response source: University Office
# 6: Outreach response source: Website
# 7: Outreach response source: Conferences
# 8: Conference Name
# 9: Outreach response source: Other
# 10: Other source name
# 11: Last updated program
# 12: Last updated tmsp (whatever that is...)
# 13: Outreach response source: Social Media
#------------------------------------------------------------------------------
class FastlaneImport::GrfpPgmAckSrceProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "grfp_pgm_ack_srce.txt"
    end
    
    def process_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]}, :include => :jobs)
      return unless a
      
      source = (a.source || Source.create(:applicant => a))
      source.update_attributes(
        :poster => set_true_false(fields[2]),
        :faculty_member => set_true_false(fields[3]),
        :friend_or_student => set_true_false(fields[4]),
        :university_office => set_true_false(fields[5]),
        :website => set_true_false(fields[6]),
        :conference => set_true_false(fields[7]),
        :conference_name => fields[8],
        :other => set_true_false(fields[9]),
        :other_name => fields[10],
        :social_media => set_true_false(fields[13])
      )
      nil
    end
    
    def delete_fields(fields)
      s = Source.find(:first, :conditions => {:applicant_id => fields[0]})
      s.destroy if s
    end
    
    def set_true_false(value)
      if value == "Y"
        true
      else
        false
      end
    end
    
  end
end