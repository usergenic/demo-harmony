require 'rubygems'
require 'json'
require 'harmony'
require 'hpricot'
require 'ruby-debug'

Debugger.start

module Harmoniousness

    def page(*args)
        args.empty? and @page or new_page(*args)
    end

    def new_page(*args)
        @page = Harmony::Page.new(*args)
    end

    def last_run
        type = page.execute_js(<<-js)
            (function(value){
                var type = typeof value;
                if(type != "object")
                    return type;
                if(value == null)
                    return "null";
                if(value.constructor.toString().indexOf("Array") == -1)
                    return "hash";
                return "array";
            })(__result__)
        js
        value = page.execute_js('__result__')
        case type
        when "undefined", "null"
            nil
        when "string"
            value.to_s
        when "array"
            value.to_a
        when "object"
            value.to_hash
        else
            raise "Type of #{value.inspect} unknown: #{type}."
        end

    end

end

module AppStructureHelpers

    def javascript_path(filename)
        public_path(File.join('javascripts', filename))
    end

    def public_path(filename)
        root_path(File.join('public', filename))
    end

    def root_path(filename)
        File.expand_path(File.join(File.dirname(__FILE__), '..', '..', filename))
    end

end

class MyWorld
    include AppStructureHelpers
    include Harmoniousness
end

World do
    MyWorld.new
end
