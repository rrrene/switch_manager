require 'bindata'

# openflow_service_header in openflow_service_interface.h
class OpenflowServiceHeader < BinData::Record
  endian :big

  uint64 :datapath_id
  uint16 :service_name_length
end
