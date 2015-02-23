namespace :fastlane do
  task :importer => :environment do
    # AseeUtility::NotifyOnError.notify_on_error do

      Rails.logger.info("Starting Fastlane import at #{Time.now}")

      # deal with files
      FastlaneImport::FileMover.retrieve_files

      Rails.logger.info("Files retrieved.  Starting processing at #{Time.now}")
      FastlaneProcessor.process
      binding.pry
      Rails.logger.info("Processing complete. Starting file cleanup at #{Time.now}")

      # archive files
      FastlaneImport::FileMover.archive_files

      Rails.logger.info("Updating uploaded pdfs at #{Time.now}")

      UploadedPdf.refresh_all_from_filesystem

      Rails.logger.info("Updating school-to-transcript-pdf matching at #{Time.now}")

      TranscriptUploadedPdfMatcher.match_transcript_uploaded_pdfs

      Rails.logger.info("Completed Fastlane import at #{Time.now}")

    # end
  end
end
