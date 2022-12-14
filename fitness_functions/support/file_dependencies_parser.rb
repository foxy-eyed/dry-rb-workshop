# frozen_string_literal: true

require "parser/current"

module FitnessFunctions
  module Support
    class FileDependenciesParser
      def call(file_path)
        file = File.read("#{__dir__}/../../#{file_path}")

        node = Parser::CurrentRuby.parse(file).loc.node
        find_dependencies(node.to_sexp_array)
      end

      private

      def find_dependencies(sexp)
        di_imports = []

        loop do
          sexp = sexp.pop
          next unless sexp[0] == :begin

          di_import_nodes = select_di_import_node(select_include_nodes(sexp))
          di_imports = get_imported_dependencies(di_import_nodes)
          break
        end

        di_imports
      end

      def get_imported_dependencies(import_sexps)
        import_sexps.empty? ? [] : import_sexps.flat_map { |sexp| sexp[3][3][1..].map { |n| n[2][1] } }
      end

      def select_di_import_node(import_sexps)
        import_sexps.select { |node| Array(node[3][1])[2] == :Import }
      end

      def select_include_nodes(sexp)
        sexp.select { |node| node[0] == :send && node[1].nil? && node[2] == :include }
      end
    end
  end
end
