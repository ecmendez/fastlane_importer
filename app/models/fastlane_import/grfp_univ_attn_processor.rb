#------------------------------------------------------------------------------
# FASTLANE FIELDS
#
# 0: Applicant ID
# 1: Cycle Year
# 2: Sequence Number
# 3: Fastlane Institucion ID
# 4: Institution Name
# 5: City where the institution is located
# 6: State Code
# 7: Country Code
# 8: Current
# 9: Start Date
# 10: End Date
# 11: Degree
# 12: Degree Date
# 13: The field of study major code.
# 14: The field of study specialization code
# 15: Field Detail
# 16: Graduate Courses?
# 17: Departament Name
# 18: grad_semester_hours. The course hours (in semester) that applicant completed at this institution.
# 19: grad_quarter_hours. The course hours (in quarter) that applicant completed at this institution.
# 20: Enrollment Status
# 21: Enrollment Level
# 22: Last updated program
# 23: Last updated tmsp (whatever that is...)
# 24: if is the baccalaurete institution of the applicant(bacc_inst)
# 25: gpa
# 26: gpa_base
# 27: has_transcript?
#------------------------------------------------------------------------------
class FastlaneImport::GrfpUnivAttnProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "grfp_univ_attn.txt"
    end
    
    def process_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]})
      return unless a
      
      s = a.schools.find(:first, :conditions => {:sequence_number => fields[2]})
      unless s
        s = a.build_school
      end
      s.attributes = {
        :sequence_number => fields[2],
        :fastlane_inst_id => fields[3],
        :name => fields[4],
        :city => fields[5],
        :state => fields[6],
        :country => fields[7],
        :current => to_boolean(fields[8]),
        :start_date => to_datetime(fields[9]),
        :end_date => to_datetime(fields[10]),
        :degree => fields[11],
        :degree_date => to_datetime(fields[12]),
        :field_id => make_field(fields[13], fields[14]),
        :field_detail => fields[15],
        :graduate_courses => to_boolean(fields[16]),
        :dept => fields[17],
        :grad_semester_hours => fields[18],
        :grad_quarter_hours => fields[19],
        :bacc_inst => to_boolean(fields[24]),
        :gpa => fields[25].to_f,
        :gpa_base => fields[26],
        :has_transcript => to_boolean(fields[27])
      }
      
      case fields[20]
      when "F" then s.enrollment_status = "Full Time"
      when "P" then s.enrollment_status = "Part Time"
      when "A" then s.enrollment_status = "Not Applicable"
      when "N" then s.enrollment_status = "Redundant"
      else s.enrollment_status = nil
      end
      
      case fields[21]
      when "G" then s.enrollment_level = "Graduate"
      when "U" then s.enrollment_level = "Undergraduate"
      when "A" then s.enrollment_level = "Not Applicable"
      when "N" then s.enrollment_level = "Redundant"
      else s.enrollment_level = nil
      end
            
      #reset deleted_from_fastlane in case this record was marked as deleted
      s.deleted_from_fastlane = false
      
      s.save!
      nil
    end
    
    def delete_fields(fields) 
      a = Applicant.find(:first, :conditions => {:id => fields[0]})
      return unless a
      s = a.schools.find(:first, :conditions => {:sequence_number => fields[2]})
      s.update_attribute(:deleted_from_fastlane, true) if s
    end
  end
end