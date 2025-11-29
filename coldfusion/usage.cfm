<cfscript>
cfprocessingdirective(pageEncoding = "utf-8");

include "lib.cfm";

outputFormat = "classic";

if (structKeyExists(url, "reloadEnv")) {
  reloadEnv();
}
dotenv(path: ".env.#request.ENVIRONMENT#");

bitgoApiURL  = "http://#env("BITGO_EXPRESS_HOST")#:#env("BITGO_EXPRESS_PORT")#/api/v2";
bitgoExpress = new "bitgo-express"(env("BITGO_ACCESS_TOKEN"), bitgoApiURL);

coin = "btc";
if (request.ENVIRONMENT != "production") {
  coin = "t" & coin;
}

// List wallets
wallets = bitgoExpress.getWallets(coin = coin);

echo("<h2>Wallets</h2>");
writeDump(var = wallets, label = "Wallets", format = outputFormat);
echo("<hr/>");

if (len(wallets.error) || !arrayLen(wallets.data.wallets)) {
  echo("No wallets found.");
  abort;
}

// Create address on the first wallet
wallet     = wallets.data.wallets[1];
newAddress = bitgoExpress.createWalletAddress(coin = coin, walletId = wallet.id);
echo("<h2>New Wallet Address</h2>");
writeDump(var = newAddress, label = "New Wallet Address", format = outputFormat);
echo("<hr/>");

if (len(newAddress.error) || !structKeyExists(newAddress.data, "address")) {
  echo("Failed to create wallet address.");
  abort;
}

// Send coins to the new address, on the same wallet
receiveAddress = newAddress.data.address;
amount         = 0.01;

sendCoins = bitgoExpress.send(
  coin     = coin,
  walletId = wallet.id,
  body     = {
    "walletPassphrase": env("BITGO_PASSPHRASE"),
    "address"         : receiveAddress,
    "amount"          : amount * 10^8, // convert to satoshi,
    "comment"         : "#amount# #coin# sent to #wallet.label# at #receiveAddress#"
  }
);

echo("<h2>Send Coins</h2>");
writeDump(var = sendCoins, label = "Send Coins", format = outputFormat);
echo("<hr/>");

if (len(sendCoins.error) || !structKeyExists(sendCoins.data, "txid")) {
  echo("Failed to send coins.");
  abort;
}

// Get transfer details
transferDetails = bitgoExpress.getWalletTransfer(coin = coin, walletId = wallet.id, transferId = sendCoins.data.txid);
echo("<h2>Transfer Details</h2>");
writeDump(var = transferDetails, label = "Transfer Details", format = outputFormat);
echo("<hr/>");
</cfscript>
