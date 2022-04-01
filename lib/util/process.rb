module VCMDUtilProcess

  class Controller

    def initialize
      require 'open3'
        @ssh_cmd = Vagrant::Util::Which.which("ssh")
    end

    def Controller.vagrant_cmd
        @@vagrant_cmd = Vagrant::Util::Which.which("vagrant")
    end

    def run(cmd, env={})
      #
      # Launch subprocess
      #

      begin
        
        Open3.popen3(env, cmd) do |stdin, stdout, stderr|
          stdin.close
          readers = [stdout, stderr]
          while readers.any?
            # Implement IO.select as per
            # https://ruby-doc.org/stdlib-2.1.2/libdoc/open3/rdoc/Open3.html#method-c-popen3
            ready = IO.select(readers, [], readers)
            ready[0].each do |fd|
              if fd.eof?
                fd.close
                readers.delete fd
              else
                line = fd.readline
                puts('' + line.gsub(/\n/,""))
              end
            end
          end
        end

      rescue Exception => e
        $logger.error("Error running command #{cmd}, error was #{e}")
      end 


      
    end
    
  end

end

