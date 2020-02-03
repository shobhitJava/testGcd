#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}


# remove previous crypto material and config transactions
rm -fr config/*
rm -fr crypto-config/*

# generate crypto material
cryptogen generate --config=./crypto-config.yaml
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

# generate genesis block for orderer
configtxgen -profile  CommonOrgsOrdererGenesis -outputBlock ./commonConfig/genesis1.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block for common..."
  exit 1
fi

# generate channel configuration transaction
configtxgen -profile CommonOrgChannel -outputCreateChannelTx ./commonConfig/channel1.tx -channelID commonchannel
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction for common channel..."
  exit 1
fi

# generate anchor peer transaction
configtxgen -profile CommonOrgChannel -outputAnchorPeersUpdate ./commonConfig/tfmMSPanchors.tx -channelID commonchannel -asOrg tfm 
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for common channel..."
  exit 1
fi



# generate channel configuration transaction
configtxgen -profile IEOrgChannel -outputCreateChannelTx ./commonConfig/channel2.tx -channelID iechannel
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction for Importer Exporter..."
  exit 1
fi

# generate anchor peer transaction
configtxgen -profile IEOrgChannel -outputAnchorPeersUpdate ./commonConfig/ieMSPanchors.tx -channelID iechannel -asOrg tfm
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Importer Exporter..."
  exit 1
fi

# generate channel configuration transaction
configtxgen -profile IIBOrgChannel -outputCreateChannelTx ./commonConfig/channel3.tx -channelID iibchannel
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction for Importer Importer Bank..."
  exit 1
fi

# generate anchor peer transaction
configtxgen -profile IIBOrgChannel -outputAnchorPeersUpdate ./commonConfig/iibMSPanchors.tx -channelID iibchannel -asOrg tfm
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Importer Importer Bank..."
  exit 1
fi




