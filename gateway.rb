require_relative "lib/menu"
require_relative "lib/transaction"
require_relative "lib/gateway"

the_gateway = Gateway.new
the_gateway.launch
