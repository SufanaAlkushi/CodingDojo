import hashlib

class Blocks:
   def __init__(self, previous_hash, transaction):
     self.transaction = transaction
     self.previous_hash = previous_hash
     string_to_hash = "".join(transaction) + previous_hash 
   # ^ string array for transactions and prev hash
     self.block_hash = hashlib.sha256(string_to_hash.encode()).hexdigest()
