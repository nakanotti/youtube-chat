#!/usr/bin/env node

const fs = require("fs")

const lockfilePath = "package-lock.json"
const blockedAxiosVersions = new Set(["1.14.1", "0.30.4"])

if (!fs.existsSync(lockfilePath)) {
  console.error("[check-supply-chain] package-lock.json not found")
  process.exit(1)
}

const lockRaw = fs.readFileSync(lockfilePath, "utf8")
let lock
try {
  lock = JSON.parse(lockRaw)
} catch (err) {
  console.error("[check-supply-chain] failed to parse package-lock.json")
  process.exit(1)
}

const findings = []

if (lockRaw.includes("plain-crypto-js")) {
  findings.push("plain-crypto-js was found in package-lock.json")
}

const packages = lock && typeof lock === "object" ? lock.packages || {} : {}
const axiosPkg = packages["node_modules/axios"]
if (axiosPkg && blockedAxiosVersions.has(axiosPkg.version)) {
  findings.push(`axios locked to blocked version ${axiosPkg.version}`)
}

if (lockRaw.includes('"version": "1.14.1"') || lockRaw.includes('"version": "0.30.4"')) {
  findings.push("blocked axios version marker exists in package-lock.json")
}

if (findings.length > 0) {
  console.error("[check-supply-chain] FAILED")
  for (const finding of findings) {
    console.error(`- ${finding}`)
  }
  process.exit(2)
}

console.log("[check-supply-chain] OK: blocked axios versions and plain-crypto-js not found")
