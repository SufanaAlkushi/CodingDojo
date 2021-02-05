    @property
    def unconfirmed(self):
        """A list of unconfirmed transactions."""
        return self.unconfirmedTransaction[:]

    def lastChain(self):
        """last block. """
        if len(self.__chain) < 1:
            return None
        return self.__chain[-1]

    def addTransaction(self, sender, receiver, amount=0.90):
        """ Append a new transactions"""
        transaction = Transaction(sender, receiver, amount)
        self.unconfirmedTransaction.append(transaction)


    def addBlcok(self):
        """Add a new block and append unconfirmed transactions similar to a mining block"""
        last_block = self.__chain[-1]
        hashed_block = hashBlock(last_block)
        proof = self.proofOfWork()
        reward_transaction = Transaction(
            'MINING', 'receiverAddress', self.REWAED)
        copied_transactions = self.unconfirmedTransaction[:]
        copied_transactions.append(reward_transaction)
        block = Block(len(self.__chain), hashed_block, copied_transactions, proof)
        block.hash = hashBlock(block)
        self.__chain.append(block)
        self.unconfirmedTransaction = []
        return block
