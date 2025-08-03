# 🗳️ Voting Contract Project

A simple smart contract for running a small scale voting competition with paid voting, participant registration limits, and automatic deadline management.

---

## 📜 Contract Summary

The **Voting** smart contract facilitates a fee based voting process with a cap on participants and votes.

---

## 🔧 Key Features

- **Participant Registration**
  - Up to **5 participants** can register using their name and wallet address.
  - Registration closes automatically when the limit is reached.
  - Voting starts immediately after registration closes and lasts for **5 minutes**.

- **Fee-Based Voting**
  - Voters must pay a fixed fee (set during contract deployment) by calling `makePayment()`.
  - Payment is transferred to the contract coordinator.
  - Only paid voters can vote.

- **Voting Logic**
  - Voters call the `vote()` function to vote for a participant by ID.
  - Each voter is allowed **only one vote**.
  - Voting is blocked after 5 minutes or once **50 votes** have been cast, whichever comes first.

- **Winner Declaration**
  - Anyone can call `declareWinner()` **after the voting deadline** to view the winner.
  - The winner is the participant with the highest vote count.
  - The function returns the winner's name, address, and number of votes.

---

## ✅ Validations & Access Control

- ✔️ Only registered participants can be voted for.
- ✔️ Only users who have paid the fee can vote.
- ✔️ Each address can vote **once only**.
- ❌ Voting is rejected if:
  - The voter hasn’t paid.
  - The voter has already voted.
  - The selected participant is not registered.
  - Voting has ended or hasn’t started yet.
  - The maximum vote count (50) has been reached.
- ❌ Winner cannot be declared before the deadline or more than once.

---

## 📍 Deployment Info

- **Txn hash:**  
  0x1f3a0da67bcaaBa742e1b84F5c38Ab80709eDD78

- **Block Explorer (Lisk Sepolia):**  
  [View on Blockscout](https://sepolia-blockscout.lisk.com/address/0x1f3a0da67bcaaBa742e1b84F5c38Ab80709eDD78#code)

---

## 🧱 Tech Stack

- **Solidity:** `^0.8.28`
- **Network:** Lisk Sepolia Testnet
- **License:** MIT

---

## 📂 Functions Overview

| Function | Description |
|----------|-------------|
| `makePayment()` | Accepts voting fee from a voter |
| `registerParticipant(string name)` | Registers a participant (max 5) |
| `vote(uint8 participantId)` | Allows paid users to vote once |
| `declareWinner()` | Returns the winner after deadline |
| `getParticipant(uint8 id)` | Returns participant details by ID |

---

## 🗂️ Constants & Limits

- `maxParticipants = 5`
- `maxVotes = 50`
- `votingDuration = 5 minutes` (after registration closes)

---

Feel free to fork, modify, or test this contract as needed!
