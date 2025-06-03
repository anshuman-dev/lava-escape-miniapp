// Updated with your MetaMask wallet
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

console.log("Header:", headerBase64);
console.log("Payload:", payloadBase64);
console.log("\nMessage to sign:", headerBase64 + "." + payloadBase64);