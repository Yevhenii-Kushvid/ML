class Plotter
  # Display data
  require 'nyaplot'
  require 'nyaplot_utils'

  def self.plot(type, x, y, to)
    dataframe = Nyaplot::DataFrame.new({ x: x, y: y })
    plot = Nyaplot::Plot.new
    plot.add_with_df(dataframe, type, :x, :y)
    plot.export_html(to)
  end
end