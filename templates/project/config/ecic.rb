Ecic.project.configure do

  #Select the default type of RTL files you wish to generate:
  #VHDL or SystemVerilog:
  config.generator.library.type.default = 'vhdl'
  # config.generator.library.type.default = 'sv'   

  config.generator.design.vhdl.combine = ''
#  config.generator.design.vhdl.combine = 'entity + architecture'
#  config.generator.design.vhdl.combine = 'entity + component'
#  config.generator.design.vhdl.combine = 'entity + architecture + component'

end