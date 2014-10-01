namespace :evolve do
  desc "Provisions remote machine via Ansible"
  task :provision do |task|
    begin
      run_locally do
        ansible_path = Dir.pwd + "/lib/ansible"
        provision = "ansible-playbook provision.yml -e stage=#{fetch(:stage)}"

        success = system("cd #{ansible_path} && #{provision}")

        unless success
          error "Unable to provision with SSH publickey for \"#{fetch(:user)}\" user"

          set :user, ask('user to provision as', fetch(:user))

          puts "password:"

          system("cd #{ansible_path} && #{provision} --user=#{fetch(:user)} --ask-pass --ask-sudo-pass")
        end
      end

      success=true
    ensure
      invoke "evolve:log", success, task.name
    end
  end
end
