class Usda < ActiveRecord::Base
  self.table_name = 'usda'

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
