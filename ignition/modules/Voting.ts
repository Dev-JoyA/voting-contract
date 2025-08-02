import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const _voteFee = "2600000000000"; 

const VotingModule = buildModule("VotingModule", (m) => {
  const voteFee = m.getParameter("voteFee", _voteFee);

  const coordinator = m.getParameter("coordinator");

  const voting = m.contract("Voting", [voteFee, coordinator]);

  return { voting };
});

export default VotingModule;
