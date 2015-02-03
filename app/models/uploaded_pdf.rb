require 'fileutils'

class UploadedPdf < ActiveRecord::Base

  has_one :essay
  has_one :reference

  validates_presence_of :file_name
  validates_uniqueness_of :file_name  
  
  # PATH = "#{Rails.root}/uploads/pdfs/#{PROGRAM_CONFIG[:year]}"
  PATH = "#{Rails.root}/uploads/pdfs/2015"
  MINIMUM_FILE_SIZE = 3.kilobytes
  MAXIMUM_FILE_SIZE = 5.megabytes
  MAXIMUM_PAGES = 15
  
  scope :files_missing_or_invalid,
    -> {
      where("file_modified_at is null OR corrupt is true OR file_size_bytes < #{MINIMUM_FILE_SIZE} OR file_size_bytes > #{MAXIMUM_FILE_SIZE} OR pdf_pages > #{MAXIMUM_PAGES} and (essays.id is not null or `references`.id is not null)")
      .joins([{:essay => :applicant}, {:reference => :applicant}])
      .order('IFNULL(essays.applicant_id, references.applicant_id)')
    }

  class << self
    def refresh_all_from_filesystem
      Dir.glob("#{PATH}/*.pdf") do |file_path|
        f = File.new(file_path)
        file_name = File.basename(file_path)
        up = UploadedPdf.find_or_create_by_file_name(file_name)
        up.update_file_info(f)
        up.move_to_directory(f)
      end
    end
  end
  
  # Move the PDF file to a subdirectory
  # This is done for performance - it's slow to read files in very large directories
  # If the file does not exist, does nothing
  def move_to_directory(file)
    if File.basename(file.path) != self.file_name
      raise "Can't move to directory UploadedPdf id #{id}.  File name #{file_name} doesn't match given File #{file.path}"
    end
    
    # Two characters of a SHA1 hash = 256 potential subdirectories with pseudo-random spread
    self.dir_name = Digest::SHA1.hexdigest(file_name)[0..1]
    FileUtils.mkdir_p(File.dirname(full_path))
    FileUtils.mv(file.path, full_path)
    save! if self.changed?

  end
  
  def file_errors 
    errors = []
    if !file_exists?
      errors << "File does not exist on disk."
    end
    if corrupt
      errors << "File cannot be opened as a PDF."
    end
    if file_size_bytes && file_size_bytes < MINIMUM_FILE_SIZE
      errors << "File is smaller than #{to_k(MINIMUM_FILE_SIZE)} kb (#{to_k(file_size_bytes)} kb)"
    end
    if file_size_bytes && file_size_bytes > MAXIMUM_FILE_SIZE
      errors << "File is larger than #{to_m(MAXIMUM_FILE_SIZE)} mb (#{to_m(file_size_bytes)} mb)."
    end
    if pdf_pages && pdf_pages > MAXIMUM_PAGES
      errors << "PDF document is longer than #{MAXIMUM_PAGES} pages (#{pdf_pages} pages)."
    end
    errors.join('  ')
  end
  
  def file_type_desc
    if essay
      "Essay: #{essay.type.tableize.humanize.singularize}"
    elsif reference
      "Reference"
    else
      "(none)"
    end
  end
  
  def applicant
    parent_record.try(:applicant)
  end
  
  def parent_record_updated_at
    parent_record.try(:updated_at)
  end
  
  def full_path
    File.join([PATH, dir_name, file_name].compact)
  end
  
  def file_exists?
    !!file_modified_at
  end
  
  def update_file_info(file)
    if File.basename(file.path) != self.file_name
      raise "Can't update file info for UploadedPdf id #{id}.  File name #{file_name} doesn't match given File #{file.path}"
    end
    timestamp = file.mtime
    if self.file_modified_at.nil? || (timestamp > self.file_modified_at)
      self.file_modified_at = timestamp
      self.file_size_bytes = File.size(file.path)
      
      begin
        self.wordcount = `pdftotext #{file.path} - | wc -w`.to_i
      rescue
        # Don't tank it if we can help it
      end      
      
      pdf_info = ValidatePDF::Validations::fetch_pdf_info(file.path) rescue nil
      if pdf_info
        self.pdf_pages = pdf_info['Pages']
      else
        self.corrupt = true
      end
      save! if self.changed?
    end
  end

private
  def parent_record
    if essay
      essay
    elsif reference
      reference
    else 
      nil
    end
  end
  
  def to_k(i)
    i / 1.kilobyte
  end
    
  def to_m(i)
    i / 1.megabyte
  end
  
end
