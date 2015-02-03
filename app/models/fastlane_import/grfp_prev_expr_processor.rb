class FastlaneImport::GrfpPrevExprProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "grfp_prev_expr.txt"
    end
    
    def process_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]}, :include => :jobs)
      return unless a
      
      order = fields[2]
      j = a.jobs.find(:first, :conditions => {:order => order})
      job = (j || Job.new(:applicant => a))
      job.attributes = {
        :order => order,
        :position => fields[3],
        :employer => fields[4], 
        :start_date => to_datetime(fields[5]),
        :end_date => to_datetime(fields[8])
      }
      job.save!
      nil
    end
    
    def delete_fields(fields)
      j = Job.find(:first, :conditions => {:applicant_id => fields[0], :order => fields[2]})
      j.destroy if j
    end
  end
end