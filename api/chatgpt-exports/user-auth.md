# 🔐 Public-Private Key Identity System for Per-Server Chat App

This document outlines an identity/authentication system using cryptographic keypairs for Echo-Chat. It is tailored for a system where accounts exist per physical server instance, with optional cross-server login support.

---

## ✅ Benefits

| Feature                         | Benefit                                           |
|---------------------------------|---------------------------------------------------|
| No centralized ID registry      | Avoids global usernames & name-squatting          |
| Portable & pseudonymous         | Users can move freely, opt into trust             |
| No need for passwords or emails | Login is entirely cryptographic                   |
| Optional cross-server login     | Enables interop via Web-of-Trust                  |
| Client-side key control         | Empowers users with full freedom & privacy        |

---

## 🧩 Identity Structure

```json
{
  "display_name": "Ghostcat",
  "pubkey": "ed25519:9f02a…34c",
  "avatar": "https://example.com/media/ghostcat.png",
  "metadata": {
    "bio": "Privacy is power.",
    "created_at": "2025-04-13T14:33:00Z"
  },
  "sig": "signed_by_privkey"
}
```

- `pubkey` = stable identity (not a username)
- `sig` = proof that the data comes from the private key holder

---

## 🔐 Keypair-Based Login Flow (Per-Server)

### 1. Client Generates Keypair
- Locally, on first use
- Recommended: `ed25519` (fast, secure)

### 2. User Registers
- Client sends:
  - Public key
  - Display name (non-unique, changeable)
  - Optional profile data
- Server stores:
  - `pubkey → profile, roles, permissions`

### 3. Login
- Server sends a random challenge (nonce)
- Client signs it with their private key
- Server verifies the signature
- Access granted — no password or email involved

---

## 🌍 Optional Inter-Server Login (Federated Identity)

Enables a user to log into Server B using their identity from Server A.

### Cross-Server Auth Flow

1. **Challenge**: Server B sends nonce to client  
2. **Client Signs**: Uses private key to sign nonce  
3. **Identity Proof**: Server B requests identity data from Server A  
4. **Server A Responds**:

```json
{
  "pubkey": "ed25519:9f02...",
  "profile": {...},
  "sig": "signed by server A"
}
```

5. **Server B Verifies**:
   - Trusts Server A's signature
   - Accepts or rejects login based on policy

This allows decentralized login without a central authority.

---

## 🔒 Key Management (UX & Security)

- **Client-Side Storage**:
  - Browser: Web Crypto API
  - Desktop/Mobile: Secure enclave or keychain
- **Backup Options**:
  - Export encrypted key
  - Optional recovery phrase
- **Key Rotation**:
  - Old key signs new key to maintain identity continuity

---

## 🧠 Optional Enhancements

### 🛑 Revocation Support
- Users or servers can publish a signed revocation message
- Peers ignore revoked pubkeys

### 🪪 Identity Display
- Prefer display like:
  - `Ghostcat (chat.gcat.net)`
  - or: `Ghostcat [0x9f02]`

### 🔗 Signature Chains for Rotation
- New key is signed by old key
- Clients and servers verify the chain

---

## 👁️ Visual Flow

```
[Client]
  | generate keypair
  | store private key locally
  v
[Register to Server A]
  - Send pubkey + profile
  - Server stores user under pubkey

[Login]
  < Server sends nonce
  > Client signs with privkey
  < Server verifies signature
  = Access granted
```

---

## 🧭 Next Steps (Optional)

- Define identity message schemas (`user.json`, signed messages, etc.)
- Standardize inter-server identity verification
- Explore integration with DID (Decentralized Identity) standards if future compatibility is desired

---
