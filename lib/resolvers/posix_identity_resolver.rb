# frozen_string_literal: true

require 'etc'

module Facter
  module Resolvers
    class PosixIdentity < BaseResolver
      # :user
      # :uid
      # :group
      # :gid
      # :privileged

      @semaphore = Mutex.new
      @fact_list ||= {}

      @instance = self
      class << @instance
        def resolve(fact_name)
          @semaphore.synchronize do
            result ||= @fact_list[fact_name]
            subscribe_to_manager
            result || read_identity_data(fact_name)
          end
        end

        def read_identity_data(fact_name)
          login = Etc.getlogin
          login_info = Etc.getpwnam(login)
          group_info = Etc.getgrgid(login_info.gid)
          @fact_list = {
              :user => login_info.name,
              :uid => login_info.uid,
              :group => group_info.name,
              :gid => login_info.gid,
              :privileged => login_info.uid == 0
          }
          @fact_list[fact_name]
        end
      end
    end
  end
end