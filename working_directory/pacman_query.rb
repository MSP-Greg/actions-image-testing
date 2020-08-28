# frozen_string_literal: true
# encoding: UTF-8

# Copyright (C) 2017-2020 MSP-Greg

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

      ENV['Path'] = "C:/msys64/usr/bin;#{ENV['Path']}"

      if ENV['ImageOS'] and ENV['ImageVersion']
        puts ''
        highlight "Windows Image: #{ENV['ImageOS']} #{ENV['ImageVersion']}"
        puts "", "File dir: #{__dir__}", ""
      end

      a_i686  = `pacman.exe -Q | grep ^mingw-w64-i686- | sed 's/^mingw-w64-i686-//'`.split(/\r?\n/)
      a_x64   = `pacman.exe -Q | grep ^mingw-w64-x86_64- | sed 's/^mingw-w64-x86_64-//'`.split(/\r?\n/)

      unless a_i686.empty? && a_x64.empty?
        highlight "#{(dash + ' mingw-w64-x86_64 Packages ' + dash).ljust WID} #{dash} mingw-w64-i686 Packages #{dash}"
        max_len = [a_i686.length, a_x64.length].max - 1
        j, k = 0,0
        0.upto(max_len) { |i|
          # get package base name
          x64  = a_x64[j]
          i686 = a_i686[k]
          if x64 != i686
            if x64 < i686
              puts x64
              j += 1
            elsif i686 < x64
              puts "#{''.ljust WID} #{i686}"
              k += 1
            end
          else
            puts "#{x64.ljust WID} #{i686}"
            j += 1 ; k += 1
          end
        }
      end

      a_msys2 = `pacman.exe -Q | grep -v ^mingw-w64-`.split(/\r?\n/)

      unless a_msys2.empty?
        puts ''
        highlight "#{(dash + ' MSYS2 Packages ' + dash).ljust WID} #{dash} MSYS2 Packages #{dash}"
        half = a_msys2.length/2.ceil
        0.upto(half -1) { |i|
          puts "#{(a_msys2[i] || '').ljust WID} #{a_msys2[i + half] || ''}"
        }
      end
    end

    def highlight(str)
      puts "#{YELLOW}#{str}#{RESET}"
    end
  end
end
Msys2Info.run

exit 0
