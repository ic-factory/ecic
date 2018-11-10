module Ecic
  class ProjectCmd < Command

    #--------------------------------------------------------------------------
    # project root:
    #--------------------------------------------------------------------------
    desc "rootdir", Help.text('project')['root']['short']
    def rootdir
      begin
        project_root_path = Ecic::Project::root
        if project_root_path.nil?
          shell.error set_color("You must be within an ECIC project before calling this command",Thor::Shell::Color::RED)
          exit(1)
        else
         say project_root_path
        end
      rescue Exception => exc
        shell.error set_color(exc.message,Thor::Shell::Color::RED)
        exit(3)
      end
    end
  end
end
