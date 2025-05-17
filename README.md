# Aztec Network Sequencer Node
## Background
The Aztec sequencer node is critical infrastructure responsible for ordering transactions and producing blocks.

The sequencer node takes part in three key actions:

Assemble unprocessed transactions and propose the next block
Attest to correct execution of txs in the proposed block (if part of validator committee)
Submit the successfully attested block to L1
When transactions are sent to the Aztec network, sequencer nodes bundles them into blocks, checking various constraints such as gas limits, block size, and transaction validity. Before a block can be published, it must be validated by a committee of other sequencer nodes (validators in this context) who re-execute public transactions and verify private function proofs so they can attest to correct execution. These validators attest to the block's validity by signing it, and once enough attestations are collected (two-thirds of the committee plus one), the sequencer can submit the block to L1.
## Roles Info
Sequecner Nodes will receive a certain role for their contribution on Discord.
## Hardware Requirements
<table>
  <tr>
    <th colspan="3"> Sequencer Node HW Requirements </th>
  </tr>
  <tr>
    <td>RAM</td>
    <td>CPU</td>
    <td>Disk</td>
  </tr>
  <tr>
    <td><code>16 GB</code></td>
    <td><code>6-8 cores</code></td>
    <td><code>1 TB SSD</code></td>
  </tr>
</table>

## 1. Install Dependecies
* Update packages:
```bash
sudo apt-get update && sudo apt-get upgrade -y
```
## 2. Run this Auto script
* Auto Install:
```
curl -O https://raw.githubusercontent.com/RyzenXT-hub/Aztec/main/install.sh && chmod u+x install.sh && ./install.sh
```
## 3. TroubleShooting 
* Check logs
```
journalctl -u aztec -f -ocat
```
* Stop & Start Service
```
systemctl stop aztec
```
```
systemctl start aztec 
```
* Edit RPC OR Config Systemd
```
nano /etc/systemd/system/aztec.service
```
## 4. Remove all service & data
```
sudo systemctl stop aztec && \
sudo systemctl disable aztec && \
sudo rm -f /etc/systemd/system/aztec.service && \
sudo systemctl daemon-reload && \
sudo systemctl reset-failed && \
rm -rf ~/.aztec ~/.aztec-up ~/.aztec-logs
```
