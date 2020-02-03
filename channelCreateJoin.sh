#Run mch docker-compose
#docker-compose -f docker-compose.yaml up -d



#Create commonchannel for all peers
docker exec -e "CORE_PEER_LOCALMSPID=tfmMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@tfm.test/msp/" peer0.tfm.test peer channel create -o orderer.tfm.test:7050 -c commonchannel -f /etc/hyperledger/configtx/channel1.tx

#Create pair channel for importer and exporter
docker exec -e "CORE_PEER_LOCALMSPID=tfmMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@tfm.test/msp/" peer0.tfm.test peer channel create -o orderer.tfm.test:7050 -c iechannel -f /etc/hyperledger/configtx/channel2.tx

#Create pair channel for importer and importerbank
docker exec -e "CORE_PEER_LOCALMSPID=tfmMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@tfm.test/msp/" peer0.tfm.test peer channel create -o orderer.tfm.test:7050 -c iibchannel -f /etc/hyperledger/configtx/channel3.tx


#Join commonchannel by all  peers
docker exec -e "CORE_PEER_LOCALMSPID=exporterMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@exporter.test/msp/"  peer0.exporter.test peer channel join -b commonchannel.block


docker exec -e "CORE_PEER_LOCALMSPID=importerbankMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@importerbank.test/msp/"  peer0.importerbank.test peer channel join -b commonchannel.block


docker exec -e "CORE_PEER_LOCALMSPID=exporterbankMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@exporterbank.test/msp/"  peer0.exporterbank.test peer channel join -b commonchannel.block

docker exec -e "CORE_PEER_LOCALMSPID=importerMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@importer.test/msp/"  peer0.importer.test peer channel join -b commonchannel.block

#Join iechannel by  exporter/importer
docker exec -e "CORE_PEER_LOCALMSPID=importerMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@importer.test/msp/"  peer0.importer.test peer channel join -b iechannel.block

docker exec -e "CORE_PEER_LOCALMSPID=exporterMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@exporter.test/msp/"  peer0.exporter.test peer channel join -b iechannel.block


docker exec -e "CORE_PEER_LOCALMSPID=tfmMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@tfm.test/msp/"  peer0.tfm.test peer channel join -b iechannel.block

#Join iibchannel by  exporter/importer
docker exec -e "CORE_PEER_LOCALMSPID=importerMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@importer.test/msp/"  peer0.importer.test peer channel join -b iibchannel.block

docker exec -e "CORE_PEER_LOCALMSPID=importerbankMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@importerbank.test/msp/"  peer0.importerbank.test peer channel join -b iibchannel.block


docker exec -e "CORE_PEER_LOCALMSPID=tfmMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@tfm.test/msp/"  peer0.tfm.test peer channel join -b iibchannel.block

