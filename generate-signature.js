// FRESH signature generator - completely new approach
const fid = 1046026;
const domain = "lava-escape.netlify.app";
const walletAddress = "0x137c2e26c634073BD42a91f79DEf41A9f80dc1cF";

// Create header and payload with exact formatting
const header = {
  "fid": fid,
  "type": "custody",
  "key": walletAddress
};

const payload = {
  "domain": domain
};

// Convert to base64 - ensuring no extra whitespace
const headerBase64 = btoa(JSON.stringify(header));
const payloadBase64 = btoa(JSON.stringify(payload));

console.log("=== FRESH SIGNATURE GENERATION ===");
console.log("Header JSON:", JSON.stringify(header));
console.log("Payload JSON:", JSON.stringify(payload));
console.log();
console.log("Header Base64:", headerBase64);
console.log("Payload Base64:", payloadBase64);
console.log();
console.log("Message to sign:", headerBase64 + "." + payloadBase64);
console.log();
console.log("=== NEXT STEPS ===");
console.log("1. Copy the 'Message to sign' above");
console.log("2. Use the manual signing method below");
console.log();
console.log("=== MANUAL SIGNING CODE ===");
console.log("// Paste this in browser console:");
console.log(`
const message = "${headerBase64}.${payloadBase64}";
window.ethereum.request({
  method: 'personal_sign',
  params: [message, window.ethereum.selectedAddress]
}).then(signature => {
  console.log("✅ Your signature:", signature);
  console.log("Copy this signature and use it in the manifest");
});
`);