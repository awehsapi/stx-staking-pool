# Enhanced STX Staking Pool Contract

## Overview
This smart contract provides a feature-rich Stacks (STX) staking pool that includes tiered rewards, governance capabilities, a referral system, and advanced security mechanisms. The contract enables users to stake STX tokens, earn rewards, participate in governance, and benefit from a referral program, all while ensuring robust security and compliance.

## Features

1. **Tiered Staking and Rewards:**
   - **Tier 1:** Minimum 100 STX with a 1x reward multiplier.
   - **Tier 2:** Minimum 1,000 STX with a 1.25x reward multiplier.
   - **Tier 3:** Minimum 10,000 STX with a 1.5x reward multiplier.

2. **Governance System:**
   - Create proposals if you stake at least 1,000 STX.
   - Cast votes based on your stake and tier level.
   - Each proposal has a voting period of ~10 days (1,440 blocks).

3. **Referral Program:**
   - Users can register referrals, where referrers earn a bonus equal to 1% of the total staked pool.

4. **Security Features:**
   - Unstake cooldown period of 100 blocks to prevent frequent unstaking.
   - Emergency withdrawal functionality with a 24-hour timelock.

5. **Reward Calculation:**
   - Rewards are distributed proportionally based on the stake, tier, and total pool size.

6. **Price Oracle Integration:**
   - Allows the contract owner to update external price information.

## Contract Details

### Constants
- **Contract Owner:** `tx-sender`
- **Error Codes:**
  - `u100` - Owner-only action.
  - `u101` - Insufficient funds.
  - `u102` - Not an active staker.
  - `u103` - No rewards available.
  - `u104` - Invalid tier.
  - `u105` - Proposal not active.
  - `u106` - Already voted.
  - `u107` - Cooldown period active.
  - `u108` - Insufficient stake amount.
  - `u109` - Governance proposal requirements not met.
  - `u110` - Emergency withdrawal timelock not met.

### Timelocks and Periods
- **Unstake Cooldown:** 100 blocks.
- **Governance Voting Period:** 1,440 blocks (~10 days).
- **Emergency Withdrawal Timelock:** 144 blocks (~24 hours).

### Tier Specifications
- **Minimum Stake Amounts:**
  - Tier 1: 100 STX.
  - Tier 2: 1,000 STX.
  - Tier 3: 10,000 STX.
- **Reward Multipliers:**
  - Tier 1: 1x (1,000 points).
  - Tier 2: 1.25x (1,250 points).
  - Tier 3: 1.5x (1,500 points).

## Functions

### Public Functions

#### Staking
- **`stake (amount uint)`**
  - Stakes a specified amount of STX.
  - Updates the staker's tier and balance.
  - Transfers STX to the contract.

#### Unstaking
- **`unstake (amount uint)`**
  - Withdraws a specified amount of STX.
  - Requires a cooldown period between unstakes.
  - Updates the staker's balance.

#### Referral Program
- **`register-referral (referrer principal)`**
  - Registers a referral and assigns a bonus to the referrer.
- **`get-referral-bonus (referrer principal, referee principal)`**
  - Retrieves the referral bonus for a specific referrer-referee pair.

#### Governance
- **`create-proposal (description (string-utf8 256))`**
  - Creates a governance proposal.
  - Requires at least Tier 2 staking balance.
- **`vote (proposal-id uint, vote-bool bool)`**
  - Casts a vote on an active proposal.
  - Voting power is calculated based on stake and tier.

#### Rewards
- **`calculate-rewards (staker principal)`**
  - Calculates pending rewards for a specific staker based on their stake, tier, and pool size.

#### Emergency Management
- **`initiate-emergency-withdrawal`**
  - Initiates a timelock for emergency withdrawal.
- **`execute-emergency-withdrawal`**
  - Transfers all contract funds to the owner after the timelock period.

#### Price Oracle
- **`update-price (new-price uint)`**
  - Updates the last recorded price in the contract.

### Private Functions
- **`determine-tier (balance uint)`**
  - Determines the staking tier based on the balance.
- **`get-vote-power (staker principal)`**
  - Calculates a staker's voting power based on their tier and stake.
- **`get-tier-multiplier (tier uint)`**
  - Retrieves the multiplier for a specific tier.

## How to Use

1. **Stake STX:**
   - Call `stake` with the desired amount of STX to deposit into the pool.
   - Your tier will be automatically determined based on your total stake.

2. **Earn Rewards:**
   - Rewards are calculated and distributed based on your stake, tier, and the pool's performance.

3. **Participate in Governance:**
   - Create and vote on proposals if you meet the tier requirements.

4. **Use Referral System:**
   - Register referrals to earn bonuses.

5. **Unstake STX:**
   - Withdraw your funds after observing the cooldown period.

## Security Notes
- **Cooldown Periods:** Prevent frequent unstaking and ensure fair pool management.
- **Timelocks:** Provide time to address potential issues before emergency withdrawals.
- **Owner Actions:** Restricted to the contract owner for security-sensitive operations.

## Development
### Requirements
- Clarity language runtime
- A Stacks blockchain node

### Deployment
1. Compile the contract using the Clarity compiler.
2. Deploy it to the Stacks blockchain.
3. Test all functionalities using a local testnet before deploying to the mainnet.

## License
This contract is open-source and distributed under the [MIT License](LICENSE).

