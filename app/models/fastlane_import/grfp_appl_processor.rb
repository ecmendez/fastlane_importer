class FastlaneImport::GrfpApplProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "grfp_appl.txt"
    end
    
    def process_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]}, :include => :study)
      return unless a
      s = a.study || a.build_study
      
      s.five_year_masters = to_boolean(fields[2])
      s.four_year_masters = to_boolean(fields[3])
      s.academic_honors = fields[4]
      s.proposed_school_name = fields[6]
      
      s.field_one_id = make_field(fields[7], fields[8])
      s.interdisciplinary = to_boolean(fields[9])
      s.field_one_percent = fields[10]
      s.field_two_id = make_field(fields[11], fields[12])
      s.field_two_percent = fields[13]
      s.field_three_id = make_field(fields[14], fields[15])
      s.field_three_percent = fields[16]
      s.field_four_id = make_field(fields[17], fields[18])
      s.field_four_percent = fields[19]
      
      s.highest_degree = fields[20]
      s.other_degree = fields[21]
      
      s.highest_degree_field_id = make_field(fields[22], fields[23])
      s.grad_study_level_id = fields[24]
      
      a.display_honors_list = to_boolean(fields[25])
      a.display_honors_email = to_boolean(fields[26])
      a.submitted_at = to_datetime(fields[27])
      
      case fields[28]
      when "B" then a.late_submission!
      when "S" then a.submitted!
      when "U" then a.unsubmitted!
      when "W" then a.withdrawn!
      when "C" then a.deleted!
      else a.no_status!
      end
      
      a.withdraw_reason = fields[29]
      
      s.proposed_school_dept = fields[32]
      s.proposed_school_city = fields[33]
      s.proposed_school_state = fields[34]
      s.proposed_school_country = fields[35]
      s.field_one_other_name = fields[36]
      s.fastlane_panel_choice_id = fields[37]
      s.proposed_research_title = fields[38]
      s.proposed_research_short_title = fields[39]
      
      if fields[40]
        s.proposed_research_international_component = to_boolean(fields[40])
      end
      if fields[41]
        s.proposed_research_country_code = fields[41]
      end
      
      s.proposed_program = fields[42]
      
      s.save!
      a.save!
      nil
    end
    
    def delete_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]}, :include => :study)
      return unless a
      
      a.study.destroy if a.study
      
      a.display_honors_list = nil
      a.display_honors_email = nil
      a.submitted_at = nil
      a.no_status!
      a.withdraw_reason = nil
      
      a.save!
    end
  end
end