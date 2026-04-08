# youtube-chat
[![npm version](https://badge.fury.io/js/youtube-chat.svg)](https://badge.fury.io/js/youtube-chat)
![npm](https://img.shields.io/npm/dt/youtube-chat)
![NPM](https://img.shields.io/npm/l/youtube-chat)
[![CI](https://github.com/LinaTsukusu/youtube-chat/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/LinaTsukusu/youtube-chat/actions/workflows/ci.yml)

> Fetch YouTube live chat without API

☢ ***You will need to take full responsibility for your action*** ☢

## Getting started
1. Install
    - `npm i youtube-chat`
    - `yarn add youtube-chat`
2. Import
    - Javascript
    ```javascript
    const { LiveChat } = require("youtube-chat")
    ```
    - Typescript
    ```typescript
    import { LiveChat } from "youtube-chat"
    ```
3. Create instance with ChannelID or LiveID
    ```javascript
    // If channelId is specified, liveId in the current stream is automatically acquired.
    // Recommended
    const liveChat = new LiveChat({channelId: "CHANNEL_ID_HERE"})
    
    // Or specify LiveID in Stream manually.
    const liveChat = new LiveChat({liveId: "LIVE_ID_HERE"})
    ```
4. Add events
    ```typescript
    // Emit at start of observation chat.
    // liveId: string
    liveChat.on("start", (liveId) => {
      /* Your code here! */
    })
   
    // Emit at end of observation chat.
    // reason: string?
    liveChat.on("end", (reason) => {
      /* Your code here! */
    })
    
    // Emit at receive chat.
    // chat: ChatItem
    liveChat.on("chat", (chatItem) => {
      /* Your code here! */
    })
    
    // Emit when an error occurs
    // err: Error or any
    liveChat.on("error", (err) => {
      /* Your code here! */
    })
    ```
5. Start
    ```typescript
    // Start fetch loop
    const ok = await liveChat.start()
    if (!ok) {
      console.log("Failed to start, check emitted error")
    }
    ```
6. Stop loop
   ```typescript
   liveChat.stop()
   ```

## Types
### ChatItem
```typescript
interface ChatItem {
   author: {
      name: string
      thumbnail?: ImageItem
      channelId: string
      badge?: {
         thumbnail: ImageItem
         label: string
      }
   }
   message: MessageItem[]
   superchat?: {
      amount: string
      color: string
      sticker?: ImageItem
   }
   isMembership: boolean
   isVerified: boolean
   isOwner: boolean
   isModerator: boolean
   timestamp: Date
}
```

### MessageItem

```typescript
type MessageItem = { text: string } | EmojiItem
```

### ImageItem
```typescript
interface ImageItem {
  url: string
  alt: string
}
```

### EmojiItem
```typescript
interface EmojiItem extends ImageItem {
  emojiText: string
  isCustomEmoji: boolean
}
```

## References
- https://drroot.page/wp/?p=227
- https://github.com/taizan-hokuto/pytchat

## Development Security and Update Workflow

### Node.js version
- Minimum supported version is Node.js 20.12.0.
- Recommended development version is Node.js 25.
- Use one of the version manager files at repository root:
  - `.nvmrc`
  - `.node-version`

### Security checks
- Run supply-chain checks before and after dependency updates:

```bash
npm run check-supply-chain
npm run audit-security
npm run audit-signatures
```

### Update scripts
- Update development environment baseline:

```bash
npm run update-dev-environment
```

- Update modules safely (includes axios safe pin and validation):

```bash
npm run update-modules-safe
```

### Notes for axios
- This project pins axios to a safe explicit version instead of using `latest`.
- Do not use blocked versions reported in supply-chain incidents.
- Keep `package-lock.json` committed and prefer `npm ci` for reproducible installs.

Thank you!👍
