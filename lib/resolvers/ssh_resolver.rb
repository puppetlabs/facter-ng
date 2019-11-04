# frozen_string_literal: true

module Facter
    module Resolvers
        class Ssh < BaseResolver
            @semaphore = Mutex.new
            @fact_list ||= {}
            @file_names = {rsa_key => 'ssh_host_rsa_key.pub',
                           dsa_key => 'ssh_host_dsa_key.pub"',
                           ecdsa_key => 'ssh_host_ecdsa_key.pub',
                           ed25519_key => 'ssh_host_ed25519_key'}
            @file_paths = %w(/etc/ssh /usr/local/etc/ssh /etc /usr/local/etc','/etc/opt/ssh)
            class << self
                def resolve(fact_name)
                    @semaphore.synchronize do
                        result ||= @fact_list[fact_name]
                        subscribe_to_manager
                        result || retrieve_ssh_information(fact_name)
                    end
                end

                private

                def retrieve_ssh_information(fact_name)
                    @file_paths.each do |file_path|
                        if(File.directory?(file_path))
                            @file_names.each do |file_name|
                                if File.file?(file_name)
                                    result = File.read(file_path + "/" + file_name).split(" ")

                                end
                            end
                        end
                    end
                end

                def determine_ssh_key_type(key)
                    case key
                    when "ssh-dss"
                        return "dsa"
                    when "ecdsa-sha2-nistp256"
                        return "ecdsa"
                    when "ssh-ed25519"
                        return "ed25519"
                    when "ssh-rsa"
                        return "rsa"
                    end
                end

                def decode_key(key)
                    result = Base64.decode(key)
                end
            end
        end
    end
end
