# frozen_string_literal: true
# encoding: UTF-8

# Copyright (C) 2017-2021 MSP-Greg

module Msys2Info

  YELLOW = "\e[33m"
  RESET  = "\e[0m"

  WID = 45

  class << self
    def run
      t = `chcp 65001`
      dash = (case ARGV[0]
        when 'utf-8'
          "\u2015".dup.force_encoding 'utf-8'
        when 'Windows-1252'
          151.chr
        else
          "\u2015".dup.force_encoding 'utf-8'
        end) * 7

      if ENV['ImageOS'] and ENV['ImageVersion']
        puts ''
        highlight "Windows Image: #{ENV['ImageOS']} #{ENV['ImageVersion']}"
        puts "", "File dir: #{__dir__}", ""
      end

      a_ucrt = `dir C:\\msys64\\ucrt64\\bin\\*.exe /B`.split(/\s+/).reject  { |s| s.start_with? 'x86_64-w64-mingw32-' }
      a_x64  = `dir C:\\msys64\\mingw64\\bin\\*.exe /B`.split(/\s+/).reject { |s| s.start_with? 'x86_64-w64-mingw32-' }
      a_i686 = `dir C:\\msys64\\mingw32\\bin\\*.exe /B`.split(/\s+/).reject { |s| s.start_with? 'i686-w64-mingw32-'   }

      unless a_ucrt.empty? && a_x64.empty? && a_i686.empty?
        highlight "#{(dash + ' ucrt exe files ' + dash).ljust WID} #{(dash + ' mingw64 exe files ' + dash).ljust WID} #{dash} mingw32 exe files #{dash}"

        j_len = a_ucrt.length
        k_len = a_x64.length
        l_len = a_i686.length

        j, k, l = 0, 0, 0
        while j < j_len &&  k < k_len && l < l_len do
          ucrt = a_ucrt[j]
          x64  = a_x64[k]
          i686 = a_i686[l]

          min = [ucrt, x64, i686].min { |a, b| a.downcase <=> b.downcase }

          out = ''.dup
          if min == ucrt
            j += 1
            out << "#{ucrt.ljust WID} "
          else
            out << "#{' '.ljust WID} "
          end
          if min == x64
            k += 1
            out << "#{x64.ljust WID} "
          else
            out << "#{' '.ljust WID} "
          end
          if min == i686
            l += 1
            out << i686
          end
          puts out.rstrip
        end
        puts ''
      end
    end

    def highlight(str)
      puts "#{YELLOW}#{str}#{RESET}"
    end
  end
end
Msys2Info.run

exit 0
