class Ssh
    attr_accessor :digest, :type, :key
    def initialise(digest,type,key)
        @digest = digest
        @type = type
        @key = key
    end
end