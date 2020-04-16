# -*- coding: utf-8 -*-
#
#--
# Copyright (C) 2009-2016 Thomas Leitner <t_leitner@gmx.at>
#
# This file is part of kramdown which is licensed under the MIT.
#++
#

require 'kramdown/converter'

module Kramdown

  module Converter

    # Converts a Kramdown::Document to a manpage in groff format. See man(7), groff_man(7) and
    # man-pages(7) for information regarding the output.
    class Man < Base

      def convert(el, opts = {:indent => 0, :result => ''}) #:nodoc:
        send("convert_#{el.type}", el, opts)
      end

      private

      def inner(el, opts, use = :all)
        arr = el.children.reject {|e| e.type == :blank}
        arr.each_with_index do |inner_el, index|
          next if use == :rest && index == 0
          break if use == :first && index > 0
          options = opts.dup
          options[:parent] = el
          options[:index] = index
          options[:prev] = (index == 0 ? nil : arr[index - 1])
          options[:next] = (index == arr.length - 1 ? nil : arr[index + 1])
          convert(inner_el, options)
        end
      end

      def convert_root(el, opts)
        @title_done = false
        opts[:result] = ".\\\" generated by kramdown\n"
        inner(el, opts)
        opts[:result]
      end

      def convert_blank(*)
      end
      alias :convert_hr :convert_blank
      alias :convert_xml_pi :convert_blank

      def convert_p(el, opts)
        if (opts[:index] != 0 && opts[:prev].type != :header) ||
            (opts[:parent].type == :blockquote && opts[:index] == 0)
          opts[:result] << macro("P")
        end
        inner(el, opts)
        newline(opts[:result])
      end

      def convert_header(el, opts)
        return unless opts[:parent].type == :root
        case el.options[:level]
        when 1
          unless @title_done
            @title_done = true
            data = el.options[:raw_text].scan(/([^(]+)\s*\((\d\w*)\)(?:\s*-+\s*(.*))?/).first ||
              el.options[:raw_text].scan(/([^\s]+)\s*(?:-*\s+)?()(.*)/).first
            return unless data && data[0]
            name = data[0]
            section = (data[1].to_s.empty? ? el.attr['data-section'] || '7' : data[1])
            description = (data[2].to_s.empty? ? nil : " - #{data[2]}")
            date = el.attr['data-date'] ? quote(el.attr['data-date']) : nil
            extra = (el.attr['data-extra'] ? quote(escape(el.attr['data-extra'].to_s)) : nil)
            opts[:result] << macro("TH", quote(escape(name.upcase)), quote(section), date, extra)
            if description
              opts[:result] << macro("SH", "NAME") << escape("#{name}#{description}") << "\n"
            end
          end
        when 2
          opts[:result] << macro("SH", quote(escape(el.options[:raw_text])))
        when 3
          opts[:result] << macro("SS", quote(escape(el.options[:raw_text])))
        else
          warning("Header levels greater than three are not supported")
        end
      end

      def convert_codeblock(el, opts)
        opts[:result] << macro("sp") << macro("RS", 4) << macro("EX")
        opts[:result] << newline(escape(el.value, true))
        opts[:result] << macro("EE") << macro("RE")
      end

      def convert_blockquote(el, opts)
        opts[:result] << macro("RS")
        inner(el, opts)
        opts[:result] << macro("RE")
      end

      def convert_ul(el, opts)
        compact = (el.attr['class'] =~ /\bcompact\b/)
        opts[:result] << macro("sp") << macro("PD", 0) if compact
        inner(el, opts)
        opts[:result] << macro("PD") if compact
      end
      alias :convert_dl :convert_ul
      alias :convert_ol :convert_ul

      def convert_li(el, opts)
        sym = (opts[:parent].type == :ul ? '\(bu' : "#{opts[:index] + 1}.")
        opts[:result] << macro("IP", sym, 4)
        inner(el, opts, :first)
        if el.children.size > 1
          opts[:result] << macro("RS")
          inner(el, opts, :rest)
          opts[:result] << macro("RE")
        end
      end

      def convert_dt(el, opts)
        opts[:result] << macro(opts[:prev] && opts[:prev].type == :dt ? "TQ" : "TP")
        inner(el, opts)
        opts[:result] << "\n"
      end

      def convert_dd(el, opts)
        inner(el, opts, :first)
        if el.children.size > 1
          opts[:result] << macro("RS")
          inner(el, opts, :rest)
          opts[:result] << macro("RE")
        end
        opts[:result] << macro("sp") if opts[:next] && opts[:next].type == :dd
      end

      TABLE_CELL_ALIGNMENT = {:left => 'l', :center => 'c', :right => 'r', :default => 'l'}

      def convert_table(el, opts)
        opts[:alignment] = el.options[:alignment].map {|a| TABLE_CELL_ALIGNMENT[a]}
        table_options = ["box"]
        table_options << "center" if el.attr['class'] =~ /\bcenter\b/
        opts[:result] << macro("TS") << "#{table_options.join(" ")} ;\n"
        inner(el, opts)
        opts[:result] << macro("TE") << macro("sp")
      end

      def convert_thead(el, opts)
        opts[:result] << opts[:alignment].map {|a| "#{a}b"}.join(' ') << " .\n"
        inner(el, opts)
        opts[:result] << "=\n"
      end

      def convert_tbody(el, opts)
        opts[:result] << ".T&\n" if opts[:index] != 0
        opts[:result] << opts[:alignment].join(' ') << " .\n"
        inner(el, opts)
        opts[:result] << (opts[:next].type == :tfoot ? "=\n" : "_\n") if opts[:next]
      end

      def convert_tfoot(el, opts)
        inner(el, opts)
      end

      def convert_tr(el, opts)
        inner(el, opts)
        opts[:result] << "\n"
      end

      def convert_td(el, opts)
        result = opts[:result]
        opts[:result] = ''
        inner(el, opts)
        if opts[:result] =~ /\n/
          warning("Table cells using links are not supported")
          result << "\t"
        else
          result << opts[:result] << "\t"
        end
      end

      def convert_html_element(*)
        warning("HTML elements are not supported")
      end

      def convert_xml_comment(el, opts)
        newline(opts[:result]) << ".\"#{escape(el.value, true).rstrip.gsub(/\n/, "\n.\"")}\n"
      end
      alias :convert_comment :convert_xml_comment


      def convert_a(el, opts)
        if el.children.size == 1 && el.children[0].type == :text &&
            el.attr['href'] == el.children[0].value
          newline(opts[:result]) << macro("UR", escape(el.attr['href'])) << macro("UE")
        elsif el.attr['href'].start_with?('mailto:')
          newline(opts[:result]) << macro("MT", escape(el.attr['href'].sub(/^mailto:/, ''))) <<
            macro("UE")
        else
          newline(opts[:result]) << macro("UR", escape(el.attr['href']))
          inner(el, opts)
          newline(opts[:result]) << macro("UE")
        end
      end

      def convert_img(el, opts)
        warning("Images are not supported")
      end

      def convert_em(el, opts)
        opts[:result] << '\fI'
        inner(el, opts)
        opts[:result] << '\fP'
      end

      def convert_strong(el, opts)
        opts[:result] << '\fB'
        inner(el, opts)
        opts[:result] << '\fP'
      end

      def convert_codespan(el, opts)
        opts[:result] << "\\fB#{escape(el.value)}\\fP"
      end

      def convert_br(el, opts)
        newline(opts[:result]) << macro("br")
      end

      def convert_abbreviation(el, opts)
        opts[:result] << escape(el.value)
      end

      def convert_math(el, opts)
        if el.options[:category] == :block
          convert_codeblock(el, opts)
        else
          convert_codespan(el, opts)
        end
      end

      def convert_footnote(*)
        warning("Footnotes are not supported")
      end

      def convert_raw(*)
        warning("Raw content is not supported")
      end



      def convert_text(el, opts)
        text = escape(el.value)
        text.lstrip! if opts[:result][-1] == ?\n
        opts[:result] << text
      end

      def convert_entity(el, opts)
        opts[:result] << unicode_char(el.value.code_point)
      end

      def convert_smart_quote(el, opts)
        opts[:result] << unicode_char(::Kramdown::Utils::Entities.entity(el.value.to_s).code_point)
      end

      TYPOGRAPHIC_SYMS_MAP = {
        :mdash => '\(em', :ndash => '\(em', :hellip => '\.\.\.',
        :laquo_space => '\[Fo]', :raquo_space => '\[Fc]', :laquo => '\[Fo]', :raquo => '\[Fc]'
      }

      def convert_typographic_sym(el, opts)
        opts[:result] << TYPOGRAPHIC_SYMS_MAP[el.value]
      end

      def macro(name, *args)
        ".#{[name, *args].compact.join(' ')}\n"
      end

      def newline(text)
        text << "\n" unless text[-1] == ?\n
        text
      end

      def quote(text)
        "\"#{text.gsub(/"/, '\\"')}\""
      end

      def escape(text, preserve_whitespace = false)
        text = (preserve_whitespace ? text.dup : text.gsub(/\s+/, ' '))
        text.gsub!('\\', "\\e")
        text.gsub!(/^\./, '\\\\&.')
        text.gsub!(/[.'-]/) {|m| "\\#{m}"}
        text
      end

      def unicode_char(codepoint)
        "\\[u#{codepoint.to_s(16).rjust(4, '0')}]"
      end

    end

  end
end
