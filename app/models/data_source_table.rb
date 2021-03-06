class DataSourceTable
  attr_reader :data_source, :schema_name, :table_name, :full_table_name, :defined_at

  delegate :data_source_adapter, to: :data_source

  def initialize(data_source, schema_name, table_name)
    @data_source = data_source
    @schema_name = schema_name
    @table_name = table_name
    @full_table_name = "#{schema_name}.#{table_name}"
    @defined_at = Time.now
  end

  def columns
    @columns ||= data_source.access_logging { data_source_adapter.fetch_columns(self) }
  end

  def fetch_rows(limit=20)
    @data_source.access_logging { data_source_adapter.fetch_rows(self, limit) }
  end

  def fetch_count
    @data_source.access_logging { data_source_adapter.fetch_count(self) }
  end
end
