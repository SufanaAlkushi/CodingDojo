# consists blocks
# blocks consist transaction
# blocks are connected through hashing
      # unique digital fingerprent = transaction + prev hash

from Blocks import Blocks
blockchain = []

genesis_block = Blocks(" Genesis BlockChain", ["Satoshi sent 10 BTC to Me",
 "I sent 7 BTC to my teamwork"])

second_block = Blocks(genesis_block.block_hash, ["I sent 3 BTC to Juma", 
"Juma sent 2 BTC to Moe"])

third_block = Blocks(second_block.block_hash, ["A to C 5 BTC", 
"G to D 4 BTC"])

print("Block hash: Genesis Block")
print(genesis_block.block_hash)

print("Block hash: Second Block")
print(second_block.block_hash)

print("Block hash: Third Block")
print(third_block.block_hash)
