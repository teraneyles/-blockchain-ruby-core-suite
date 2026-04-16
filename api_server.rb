require 'sinatra'
require 'json'
require_relative 'blockchain_core'
require_relative 'block_explorer'

set :port, 4567
blockchain = BlockchainCore.new
explorer = BlockExplorer.new(blockchain)

get '/chain' do
  content_type :json
  {
    chain: blockchain.chain,
    length: blockchain.chain.length
  }.to_json
end

post '/transactions/new' do
  data = JSON.parse(request.body.read)
  index = blockchain.add_transaction(data['sender'], data['recipient'], data['amount'])
  { message: "交易将加入区块 #{index}" }.to_json
end

get '/mine' do
  block = blockchain.mine_block
  content_type :json
  block.to_json
end

get '/balance/:address' do
  balance = explorer.address_balance(params[:address])
  { address: params[:address], balance: balance }.to_json
end

get '/stats' do
  explorer.chain_statistics.to_json
end
