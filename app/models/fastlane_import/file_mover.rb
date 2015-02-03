require "fileutils"

class FastlaneImport::FileMover

  # REMOTE_BASE = "/home/nsfgrfp/prod"
  REMOTE_BASE = '/local-store/nsfgrfp/fastlane/data'

  REMOTE_DIRECTORY = "#{REMOTE_BASE}/data"
  REMOTE_PDF_DIRECTORY = "#{REMOTE_BASE}/pdf"
  EXPORT_DIRECTORY = "#{REMOTE_BASE}/status"

  LOCAL_DIRECTORY = "#{Rails.root}/tmp/fastlane_current"
  LOCAL_PDF_DIRECTORY = UploadedPdf::PATH

  ARCHIVE_DIRECTORY = "#{Rails.root}/uploads/fastlane_backups"
  ARCHIVE_PDF_DIRECTORY = "#{Rails.root}/uploads/fastlane_backups/pdf"

  class << self
    def retrieve_files

      FileUtils.mkdir_p(LOCAL_DIRECTORY)

      files = FastlaneImport::FastlaneFile.find(:all)
      file_names = files.map { |f| f.file_name }

      file_names.each do |file|
        local_path = "#{LOCAL_DIRECTORY}/#{file}"
        remote_path = "#{REMOTE_DIRECTORY}/#{file}"
        FileUtils.rm_f(local_path)
        FileUtils.cp(remote_path, local_path)
      end

      retrieve_pdfs
    end

    def retrieve_pdfs
      FileUtils.mkdir_p(LOCAL_PDF_DIRECTORY)
      FileUtils.mkdir_p(ARCHIVE_PDF_DIRECTORY)

      res = `ls -tr #{REMOTE_PDF_DIRECTORY}/*.tar`
      files = res.split("\n")
      files.each do |file|
        file_name = file.split("/").last
        FileUtils.mv(file, LOCAL_PDF_DIRECTORY)

        # extract files; keep track of the extracted file names as they come in
        `cd #{LOCAL_PDF_DIRECTORY}; tar xvf #{file_name} > extracted_files.txt`

        # move files out of subdirectories--they will be refiled later by
        # UploadedPdf
        subdirs = []
        extracted_files = File.read("#{LOCAL_PDF_DIRECTORY}/extracted_files.txt")
        extracted_files.split("\n").each do |extracted_file_name|
          extracted_base_name = File.basename(extracted_file_name)
          subdirs |= [File.dirname(extracted_file_name)]
          FileUtils.mv("#{LOCAL_PDF_DIRECTORY}/#{extracted_file_name}", "#{LOCAL_PDF_DIRECTORY}/#{extracted_base_name}")
        end

        # clean up
        # subdirs.each{|subdir| FileUtils.rmdir("#{LOCAL_PDF_DIRECTORY}/#{subdir}")}
        FileUtils.rm("#{LOCAL_PDF_DIRECTORY}/extracted_files.txt")

        # archive tar file
        FileUtils.mv("#{LOCAL_PDF_DIRECTORY}/#{file_name}", ARCHIVE_PDF_DIRECTORY)
      end
    end

    def archive_files
      FileUtils.mkdir_p(ARCHIVE_DIRECTORY)
      archive_path = "#{ARCHIVE_DIRECTORY}/#{Time.now.strftime('%Y-%m-%d')}"
      FileUtils.mv(LOCAL_DIRECTORY, archive_path)
    end

    # Copy the given file to a directory where Fastlane can pick it up
    def fastlane_export(file_path)
      file_name = file_path.split("/").last
      export_path = "#{EXPORT_DIRECTORY}/#{file_name}"
      FileUtils.rm_f(export_path)
      FileUtils.mv(file_path, export_path)
    end
  end
end
