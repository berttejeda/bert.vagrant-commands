module VCMDUtilFSO

  class Controller

    def initialize
      @general_operations_err = 'There was a general failure in the attempt of this filesystem operation, error was: %s'
    end

    def rmtree(_dir)
      begin 
        FileUtils::rmtree _dir if File.exist?(_dir)
      rescue Exception => e
        $logger.error(@general_operations_err % e)
        return false
      end
      return true      
    end

    def read(_src_obj)
      if File.exist?(_src_obj)
        begin
          _contents = File.read(_src_obj).chomp()
        rescue Exception => e
          $logger.error(@general_operations_err % e)
          return false
        end
      else
        $logger.warn($warnings.fso.not_found % _src_obj) if $debug
        return false
      end
      return _contents
    end

    def copy(_src_obj, _dest_obj)
      if File.exist?(_src_obj) and File.exist?(_dest_obj)
        begin
          FileUtils.cp_r(_src_obj, _dest_obj)
        rescue Exception => e
          $logger.error(@general_operations_err % e)
          return false
        end
      else
        $logger.warn($warnings.fso.not_found % _src_obj) if $debug
        return false
      end     
      return true
    end

    def mkdir(_dir)
      begin 
        FileUtils::mkdir_p _dir if not File.exist?(_dir)
      rescue Exception => e
        $logger.error(@general_operations_err % e)
        return false
      end      
      return true
    end

    def write(_file, _file_content)

      # TODO: Revisit this logic
      # Do I need to check for the 
      # parent folder or the file itself?
      _file_parent_dir = File.dirname(_file)
      unless File.exist?(_file_parent_dir)
        $logger.warn("Parent dir '#{_file_parent_dir}' not found")
        return false
      else
        begin
          File.open(_file,"w") do |__file|
          __file.write _file_content
          end
        rescue Exception => e
          $logger.error(@general_operations_err % e)
          return false
        end
      end

      return true

    end

  end

end