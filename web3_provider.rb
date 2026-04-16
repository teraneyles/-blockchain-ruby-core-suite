require 'json'
require 'net/http'

class Web3Provider
  def initialize(rpc_url)
    @rpc_url = rpc_url
  end

  def rpc_request(method, params = [])
    payload = {
      jsonrpc: '2.0',
      id: rand(1000..9999),
      method: method,
      params: params
    }
    post_request(payload)
  end

  def get_balance(address)
    rpc_request('eth_getBalance', [address, 'latest'])
  end

  def get_block_by_number(number)
    rpc_request('eth_getBlockByNumber', [number, true])
  end

  def send_raw_transaction(tx_data)
    rpc_request('eth_sendRawTransaction', [tx_data])
  end

  private

  def post_request(payload)
    uri = URI(@rpc_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    request = Net::HTTP::Post.new(uri, { 'Content-Type' => 'application/json' })
    request.body = payload.to_json
    response = http.request(request)
    JSON.parse(response.body)
  end
end
