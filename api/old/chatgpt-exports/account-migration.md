# Account Migration Between Servers

This feature enables users to move their account identity, profile, and optionally message history from one physical server instance to another. It’s designed for a privacy-first, federated system where each server controls its own users, but can permit trusted imports.

---

## 🎯 Why Support Migration?

- Users may want to leave a server for any reason: moderation, downtime, community issues, etc.
- Users should have the right to retain and move their identity and content.
- Migration must be user-initiated, cryptographically secure, and verifiable.

---

## 🔑 Key Assumptions

- Each user identity is tied to a **public-private keypair**.
- Servers map a public key to a user profile and permissions.
- The private key is always under the user's control.
- Migration is opt-in and requires explicit consent from the user.
- Servers are federated and independent — no global identity authority.

---

## 🔁 What Can Be Migrated?

| Item                    | Migrated?                              | Notes                                                   |
|-------------------------|----------------------------------------|---------------------------------------------------------|
| **Identity (Public Key)**| Yes                                    | This is the core of the account.                        |
| **Profile Metadata**     | Yes                                    | Display name, avatar, etc. are all user-owned.          |
| **Roles & Permissions**  | Optional                               | May require mapping between servers.                    |
| **Direct Messages**      | Optional                               | These can be encrypted and exported locally.            |
| **Channel/Guild Posts**  | Optional                               | Depends on original server policy.                      |
| **Media Attachments**    | Optional                               | May require rehosting or relinking.                     |

---

## 🔐 Identity Migration Process

### Step 1: Export from Original Server

The user requests their current server to create a signed export package. This contains:

- Their public key  
- Display name, avatar, etc.  
- Any optional profile metadata  
- Role assignments  
- A cryptographic signature by the source server proving the authenticity

Example export:

```json
{
  "pubkey": "ed25519:abc123...",
  "profile": {
    "display_name": "Ghostcat",
    "avatar": "https://media.example.com/ghostcat.jpg",
    "created_at": "2025-01-01T00:00:00Z"
  },
  "roles": ["moderator"],
  "sig": "signed by source server"
}
```

---

### Step 2: Export Messages (Optional)

If the user chooses to migrate their messages:
- They can download a bundle of their authored messages.
- Messages may include:
  - Content  
  - Channel ID  
  - Timestamps  
  - Optional signature by the source server (for verification)
- These messages can be:
  - Left as-is  
  - Re-encrypted by the client before import

---

### Step 3: Import to New Server

User uploads their export bundle to the destination server. The new server will:

- Verify that the data is signed by a known or trusted source  
- Check the integrity of the public key and metadata  
- Map any roles or permissions to local equivalents  
- Store the user profile and optional messages

A new account is created under the same public key, and the user can log in using their existing private key.

---

### Step 4: Optional Inter-Server Follow-Up

If the new server supports deeper integration:
- It may contact the old server to verify message hashes or fetch public content  
- The old server may flag or revoke accounts it no longer trusts, but cannot delete the user from the new server

---

## 📥 Message Transfer Options

There are several approaches:

1. **Client-side export only** – Easy to implement and gives the user full control. Less verifiable unless metadata is included.  
2. **Server-signed message exports** – Allows the new server to verify authenticity but requires server support for signing.  
3. **Federated syncing** – Complex, high-trust option for auto-fetching messages and history from the original server.  

**Recommended default:** Use client-exported messages optionally verified with server signatures or hashes.

---

## 🔒 Trust and Security Notes

- The new server must verify everything — never trust an unsigned migration bundle  
- Servers may refuse to export certain data (like guild posts or DMs) to protect others' privacy  
- The user always controls their private key, so all identity and signatures can be verified  
- A server might choose to reject imports from unknown or untrusted sources  

---

## 🧠 Additional Features to Consider

- A friendly migration UI in the client, showing profile preview and import options  
- Server-side flags to opt-in/out of supporting migrations  
- Rate limits or cooldowns to prevent abuse (e.g., mass migrations)  
- Ability to selectively migrate: only identity, only messages, or both  

---

## ✅ Summary Flow

1. User requests export from Server A  
2. Server A provides signed identity and optional messages  
3. Client optionally re-encrypts message history  
4. User presents the data to Server B  
5. Server B verifies the bundle and creates the new account under the same public key  

---

## 👍 Advantages

- **Decentralized** — No central authority required  
- **Private** — No usernames or emails exchanged  
- **Verifiable** — Everything can be cryptographically signed and validated  
- **User-Controlled** — Migration only happens when the user explicitly initiates it  

---

# 🔐 End-to-End Encryption in Account Migration

When using end-to-end encryption (E2EE), only the sender and recipients can decrypt messages — **servers can't**. This requires special handling when migrating messages between servers.

---

## 🧩 Types of Encrypted Messages

### 1. Messages Sent by the User
- Encrypted for recipients using their public keys  
- Can be exported in ciphertext form  
- May include session keys or metadata for later readability  

### 2. Messages Received by the User
- Encrypted for the user by someone else  
- Can still be exported and decrypted locally by the user  
- Cannot be decrypted by the destination server or re-imported unless the same keypair is used  

### 3. Self-Messages or Notes
- Fully under the user’s control  
- Can be exported, decrypted, and reimported freely  

---

## 🔄 Export Options for Encrypted Messages

### ✅ Option A: Encrypted Messages + Encrypted Session Keys (Recommended)

- Export messages with:
  - Ciphertext  
  - Metadata  
  - Encrypted session key (wrapped with the user’s public key)

```json
{
  "channel": "cats",
  "ciphertext": "8fda9230abc...",
  "enc_key": "encrypted_key_for_pubkey_X",
  "metadata": {
    "timestamp": "2025-01-03T15:32Z",
    "sender": "pubkey_A",
    "recipients": ["pubkey_B"]
  }
}
```

Pros:
- Maintains E2EE
- Fully decryptable on the client
- Servers remain blind

---

### ⚠️ Option B: Plaintext Export (Discouraged)

- Decrypt messages before exporting
- Re-encrypt after import

**Major risk**: plaintext leaks if not handled properly. Only for local-only migrations.

---

### 🔒 Option C: Encrypted Archive Format

- Bundle messages into a local archive encrypted with a passphrase  
- Decrypt and reimport client-side only  
- Can be used as an offline backup system  

---

## 🔐 Key Management Requirements

- Session key portability (or secure rekeying)  
- Metadata for decrypting and verifying message contents  
- Cryptographic wrappers around exported keys  

If advanced functionality is needed, consider:

- MLS (Message Layer Security) for encrypted group messaging with member syncing  
- Matrix MSC1767-style export bundles  

---

## 🧭 Best Practices

| Goal                         | Recommendation                         |
|------------------------------|----------------------------------------|
| Preserve E2EE confidentiality | Export ciphertext only                 |
| Allow future readability      | Include metadata and wrapped keys      |
| Avoid server trust            | Client-side export + decryption        |
| Enable re-import              | Require user private key or passphrase |
| Support archives              | Encrypt export bundles locally         |

---

## 💬 UI Recommendations

- Option to "Include encrypted messages in export"
- Password prompt for secure backup
- Warnings that messages remain private even post-migration

## Breadcrumbs - OPTIONAL

A user may elect to have their public key remain on their original server as a breadcrumb for their account's new home server. 
