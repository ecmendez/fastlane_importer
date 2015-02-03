#The data from this file it will be loaded in Panelists database due to it has to be
#selected the equivalence between the Panel and the FastlanePanelChoice from GRFP team. (panel/edit)
class FastlaneImport::GrfpPanlNameProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "grfp_panl_name.txt"
    end
    
    def process_fields(fields)
      p = Panelists::FastlanePanelChoice.find(:first, :conditions => ["id = ?", fields[0]])
      unless p 
        p = Panelists::FastlanePanelChoice.new
        p.id = fields[0]
      end
      p.name = fields[1]
      p.major_field_code = fields[2]
      p.effective_date = to_datetime(fields[3])
      p.expiration_date = to_datetime(fields[4])
      p.save!
    end
    
    def delete_fields(fields)
      p = Panelists::FastlanePanelChoice.find(:first, :conditions => ["id = ?", fields[0]])
      p.destroy if p
    end
  end
end