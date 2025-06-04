// Updated signature generator for farcaster.json manifest
const fid = 1046026;
const domain = "lava-escape.netlify.app";
const walletAddress = "0x137c2e26c634073BD42a91f79DEf41A9f80dc1cF";

// Header (base64 encoded)
const header = {
  fid: fid,
  type: "custody",
  key: walletAddress
};

// Payload (base64 encoded) 
const payload = {
  domain: domain
};

const headerBase64 = Buffer.from(JSON.stringify(header)).toString('base64');
const payloadBase64 = Buffer.from(JSON.stringify(payload)).toString('base64');

console.log("=== FOR FARCASTER MANIFEST GENERATION ===");
console.log("Header:", headerBase64);
console.log("Payload:", payloadBase64);
console.log("\nMessage to sign:", headerBase64 + "." + payloadBase64);
console.log("\n1. Copy the 'Message to sign' above");
console.log("2. Go to https://farcaster.xyz/~/developers/new");
console.log("3. Enter your domain: lava-escape.netlify.app");
console.log("4. Sign with your MetaMask wallet");
console.log("5. Copy the signature and update the manifest file");

// Expected values for the manifest:
console.log("\n=== FOR MANIFEST FILE ===");
console.log(`"header": "${headerBase64}",`);
console.log(`"payload": "${payloadBase64}",`);
console.log(`"signature": "REPLACE_WITH_SIGNATURE_FROM_WARPCAST_TOOL"`);