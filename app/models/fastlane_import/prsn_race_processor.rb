class FastlaneImport::PrsnRaceProcessor < FastlaneImport::BaseProcessor
  
  class << self 
    
    private
    
    def file_name
      "prsn_race.txt"
    end
    
    def process_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]}, :include => :races)
      return unless a

      race = find_race_from_fastlane_text(fields[1])
      unless race
        raise "could not find Race for #{fields[1]} #{r}"
      end
      unless a.races.include?(race)
        a.races << race
      end
      nil
    end
    
    def delete_fields(fields)
      a = Applicant.find(:first, :conditions => {:id => fields[0]})
      return unless a
      r = find_race_from_fastlane_text(fields[1])
      a.races.delete(r)
    end
    
    public
    
    def find_race_from_fastlane_text(str)
      r = case str
        when "A"  then "American Indian or Alaska Native"
        when "B1" then "Asian"
        when "B2" then "Native Hawaiian or Other Pacific Islander"
        when "C"  then "Black or African American"
        when "E"  then "White"
        when "G"  then "I do not wish to respond"
      end
      Race.find_by_race(r)
    end
  end
end