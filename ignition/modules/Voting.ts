import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const _voteFee = "2600000000000"; 
const coordinatorAddress = "0x09eeAa5da8F69E313B1FF568F0d6C2BA35d4e533"; 

const VotingModule = buildModule("VotingModule", (m) => {
  const voteFee = m.getParameter("voteFee", _voteFee);

  const coordinator = m.getParameter("coordinator", coordinatorAddress);

  const voting = m.contract("Voting", [voteFee, coordinator]);

  return { voting };
});

export default VotingModule;
