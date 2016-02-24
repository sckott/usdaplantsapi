class Base < ActiveRecord::Base
  attr_accessor :with_id

  self.abstract_class = true
  self.pluralize_table_names = false

  def self.endpoint(params)
    params.delete_if { |k, v| v.nil? || v.empty? }

    %i(limit offset).each do |p|
      unless params[p].nil?
        begin
          params[p] = Integer(params[p])
        rescue ArgumentError
          raise Exception.new("#{p.to_s} is not an integer")
        end
      end
    end
    raise Exception.new('limit too large (max 5000)') unless (params[:limit] || 0) <= 5000
    return where(primary_key => params[:id]) if params[:id]
    fields = columns.map(&:name)
    if !params[:fields].nil?
      params[:fields] = params[:fields].split(',').select { |p| fields.include?(p) }.map {|f| "`#{f}`" }
    end
    where(params.select { |param| fields.any? { |s| s.to_s.casecmp(param.to_s)==0 } })
        .limit(params[:limit] || 10)
        .offset(params[:offset])
        .select(params[:fields])
  end
end
