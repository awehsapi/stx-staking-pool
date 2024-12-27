;; Enhanced STX Staking Pool Contract
;; Includes tiered rewards, governance, referrals, and advanced security

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-insufficient-funds (err u101))
(define-constant err-not-active-staker (err u102))
(define-constant err-no-rewards (err u103))
(define-constant err-invalid-tier (err u104))
(define-constant err-proposal-not-active (err u105))
(define-constant err-already-voted (err u106))
(define-constant err-cooldown-active (err u107))

;; Staking tiers (in STX)
(define-constant tier-1-minimum u100000000) ;; 100 STX
(define-constant tier-2-minimum u1000000000) ;; 1,000 STX
(define-constant tier-3-minimum u10000000000) ;; 10,000 STX

;; Reward multipliers (base points)
(define-constant tier-1-multiplier u1000) ;; 1x
(define-constant tier-2-multiplier u1250) ;; 1.25x
(define-constant tier-3-multiplier u1500) ;; 1.5x

;; Timelock and cooldown periods
(define-constant unstake-cooldown-blocks u100) ;; Blocks required between unstaking
(define-constant governance-voting-period u1440) ;; ~10 days in blocks

;; Data Variables
(define-data-var total-staked uint u0)
(define-data-var pool-active bool true)
(define-data-var reward-cycle uint u0)
(define-data-var total-rewards uint u0)
(define-data-var governance-proposal-id uint u0)
(define-data-var last-price uint u0)

;; Data Maps
(define-map staker-balances principal uint)
(define-map staker-rewards principal uint)
(define-map staker-tiers principal uint)
(define-map reward-distribution uint uint)
(define-map referral-rewards {referrer: principal, referee: principal} uint)
(define-map last-unstake-block principal uint)
(define-map governance-proposals uint {
    proposer: principal,
    start-block: uint,
    end-block: uint,
    description: (string-utf8 256),
    active: bool
})

;; Read-only functions
(define-read-only (get-staker-balance (staker principal))
    (default-to u0 (map-get? staker-balances staker))
)


(define-map governance-votes {proposal: uint, voter: principal} bool)
(define-map governance-vote-counts uint {yes: uint, no: uint})

;; Referral System
(define-public (register-referral (referrer principal))
    (let (
        (referee tx-sender)
        (referral-bonus (/ (var-get total-staked) u100)) ;; 1% bonus
    )
    (map-set referral-rewards {referrer: referrer, referee: referee} referral-bonus)
    (ok referral-bonus))
)

(define-read-only (get-referral-bonus (referrer principal) (referee principal))
    (default-to u0 (map-get? referral-rewards {referrer: referrer, referee: referee}))
)

;; Enhanced Staking with Tiers
(define-public (stake (amount uint))
    (let (
        (current-balance (get-staker-balance tx-sender))
        (new-balance (+ current-balance amount))
        (tier (determine-tier new-balance))
    )
    (asserts! (>= amount tier-1-minimum) (err u108))
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))

    ;; Update staker's balance and tier
    (map-set staker-balances tx-sender new-balance)
    (map-set staker-tiers tx-sender tier)

    ;; Update total staked amount
    (var-set total-staked (+ (var-get total-staked) amount))

    (ok amount))
)
