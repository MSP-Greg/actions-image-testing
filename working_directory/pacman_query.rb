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

      all_pkgs = `pacman.exe -Q`.split(/\r?\n/)
      a_ucrt = find_pkgs(all_pkgs, 'mingw-w64-ucrt-x86_64-')
      a_x64  = find_pkgs(all_pkgs, 'mingw-w64-x86_64-')
      a_i686 = find_pkgs(all_pkgs, 'mingw-w64-i686-')

      unless a_ucrt.empty? && a_x64.empty? && a_i686.empty?
        highlight "#{(dash[0..-3] + ' mingw-w64-ucrt-x86_64 Packages ' + dash[0..-3]).ljust WID} #{(dash + ' mingw-w64-x86_64 Packages ' + dash).ljust WID} #{dash} mingw-w64-i686 Packages #{dash}"

        j_len = a_ucrt.length
        k_len = a_x64.length
        l_len = a_i686.length

        j, k, l = 0, 0, 0
        while j < j_len &&  k < k_len && l < l_len do
          # get package base name
          ucrt = a_ucrt[j]
          x64  = a_x64[k]
          i686 = a_i686[l]

          b_ucrt = ucrt[/\S+/]
          b_x64  = x64[/\S+/]
          b_i686 = i686[/\S+/]

          b_min = [b_ucrt, b_x64, b_i686].min { |a, b| a.downcase <=> b.downcase }

          out = ''.dup
          if b_min == b_ucrt
            j += 1
            out << "#{ucrt.ljust WID} "
          else
            out << "#{' '.ljust WID} "
          end
          if b_min == b_x64
            k += 1
            out << "#{x64.ljust WID} "
          else
            out << "#{' '.ljust WID} "
          end
          if b_min == b_i686
            l += 1
            out << i686
          end
          puts out.rstrip
        end
      end

      a_msys2 = all_pkgs.reject { |str| str.start_with? 'mingw-w64-' }.sort_by(&:downcase)

      unless a_msys2.empty?
        puts ''
        highlight "#{(dash + ' MSYS2 Packages ' + dash).ljust WID} #{dash} MSYS2 Packages #{dash}"
        half = a_msys2.length/2.ceil
        0.upto(half -1) { |i|
          puts "#{(a_msys2[i] || '').ljust WID} #{a_msys2[i + half] || ''}"
        }
      end
    end

    def find_pkgs(ary, query)
      ary.select { |str| str.start_with? query }.map { |str| str.sub query, '' }.sort_by(&:downcase)
    end

    def highlight(str)
      puts "#{YELLOW}#{str}#{RESET}"
    end
  end
end
Msys2Info.run

exit 0
