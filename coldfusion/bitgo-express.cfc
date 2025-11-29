component output="false" displayname="BitGo Express Client" {

  cfprocessingdirective(pageEncoding = "utf-8");

  /**
   * Constructor
   *
   * @param {string} accessToken
   * @param {string} apiURL
   *
   * @return {Object} this
   */
  public struct function init(required string accessToken, required string apiURL) output="false" {
    variables.accessToken = arguments.accessToken;
    variables.apiURL      = arguments.apiURL;

    return this;
  }


  /**
   * List wallets
   *
   * @description Lists all your wallets for a specific asset.
   * @param       {string} coin - A cryptocurrency or token ticker symbol.
   *
   * @return {Object}
   */
  public struct function getWallets(required string coin) output="false" {
    var response = _fetch(route = "#arguments.coin#/wallet");

    return _parse(response);
  }

  /**
   * Get wallet by ID
   *
   * @description Get one wallet by its 'walletId'. One 'walletId' can map to multiple receive addresses.
   * @param       {string} walletId
   * @param       {boolean} allTokens - Include data for all subtokens (i.e. ERC20 Tokens, Stellar Tokens)
   *
   * @return {Object}
   */
  public struct function getWallet(required string walletId, boolean allTokens = false) output="false" {
    var response = _fetch(route = "wallet/#arguments.walletId#?allTokens=#arguments.allTokens#");

    return _parse(response);
  }

  /**
   * Get wallet by address
   *
   * @description Get one wallet by its coin and receive address. Multiple receive addresses can map to one walletId.
   * @param       {string} coin - A cryptocurrency or token ticker symbol.
   * @param       {string length ≤ 250} address
   *
   * @return {Object}
   */
  public struct function getWalletByAddress(required string coin, required string address) output="false" {
    var response = _fetch(route = "#arguments.coin#/wallet/address/#arguments.address#");

    return _parse(response);
  }

  /**
   * Get gas tank balance
   *
   * @description Returns gas tank balance and address for an asset.
   * @param       {string} enterpriseId
   * @param       {string} coin - A cryptocurrency or token ticker symbol.
   *
   * @return {Object}
   */
  public struct function getGasTankBalance(required string enterpriseId, required string coin) output="false" {
    var response = _fetch(route = "#arguments.coin#/enterprise/#arguments.enterpriseId#/feeAddressBalance");

    return _parse(response);
  }

  /**
   * List wallet webhooks
   *
   * @description List webhooks set up on the wallet. Currently, the types of webhooks that can be attached to a wallet are transfer, pendingapproval, and address_confirmation notifications.
   * @param       {string} coin - A cryptocurrency or token ticker symbol.
   * @param       {string} walletId
   *
   * @return {Object}
   */
  public struct function listWalletWebhooks(required string coin, required string walletId) output="false" {
    var response = _fetch(route = "#arguments.coin#/wallet/#arguments.walletId#/webhooks");

    return _parse(response);
  }

  /**
   * List transfers
   *
   * @description Returns deposits and withdrawals for a wallet. Transfers are sorted in descending order by height, then id. Transfers with rejected and pendingApproval states are excluded by default.
   * @param       {string} coin - A cryptocurrency or token ticker symbol.
   * @param       {string} walletId
   * @param       {string} prevId - Return the next batch of results, based on the nextBatchPrevId value from the previous batch
   * @param       {string 1 to 500 Defaults to 25} limit - Maximum number of results to return
   * @param       {boolean} allTokens - Include data for all subtokens (i.e. ERC20 Tokens, Stellar Tokens)
   *
   * @return {Object}
   */
  public struct function getWalletTransfers(
    required string coin,
    required string walletId,
    string prevId     = "",
    string limit      = "25",
    boolean allTokens = false
  ) output="false" {
    var allTokensBitString = (arguments.allTokens) ? "&allTokens=#arguments.allTokens#" : "";
    var response           = _fetch(
      route = "#arguments.coin#/wallet/#arguments.walletId#/transfer?prevId=#arguments.prevId#&limit=#arguments.limit & allTokensBitString#"
    );

    return _parse(response);
  }

  /**
   * Get transfer details
   *
   * @param {string} coin - A cryptocurrency or token ticker symbol.
   * @param {string} walletId
   * @param {string} transferId - A transfer or transaction id
   *
   * @return {Object}
   */
  public struct function getWalletTransfer(required string coin, required string walletId, required string transferId)
    output="false"
  {
    var response = _fetch(route = "#arguments.coin#/wallet/#arguments.walletId#/transfer/#arguments.transferId#");

    return _parse(response);
  }

  /**
   * List addresses
   *
   * @description List receive addresses on a wallet.
   * @param       {string} coin - A cryptocurrency or token ticker symbol.
   * @param       {string} walletId
   * @param       {string} prevId - Return the next batch of results, based on the nextBatchPrevId value from the previous batch
   * @param       {string} sort - Sort order of returned addresses. (1 for default ascending, -1 for descending)
   * @param       {string 1 to 500 Defaults to 25} limit - Maximum number of results to return
   *
   * @return {Object}
   */
  public struct function getWalletAddresses(
    required string coin,
    required string walletId,
    string prevId = "",
    string sort   = "-1",
    string limit  = "25"
  ) output="false" {
    var response = _fetch(
      route = "#arguments.coin#/wallet/#arguments.walletId#/addresses?prevId=#arguments.prevId#&sort=#arguments.sort#&limit=#arguments.limit#"
    );

    return _parse(response);
  }

  /**
   * Create address
   *
   * @description Creates a new receive address for a wallet.
   * @param       {string} coin - A cryptocurrency or token ticker symbol.
   * @param       {string} walletId
   *
   * @return {Object}
   */
  public struct function createWalletAddress(required string coin, required string walletId) output="false" {
    var response = _fetch(route = "#arguments.coin#/wallet/#arguments.walletId#/address", method = "post");

    return _parse(response);
  }

  /**
   * Get fee estimate
   *
   * @description Returns the estimated fee for a transaction. UTXO coins will return a fee per kB, while Account-based coins will return a flat fee estimate.
   * @param       {string} coin - A cryptocurrency or token ticker symbol.
   *
   * @return {Object}
   */
  public struct function estimateFee(required string coin, numeric numBlocks = 2) output="false" {
    var response = _fetch(route = "#arguments.coin#/tx/fee?numBlocks=#arguments.numBlocks#");

    return _parse(response);
  }

  /**
   * Send transaction
   *
   * @description This call allows you to create and send cryptocurrency to a destination address.
   * @param       {string} coin - A cryptocurrency or token ticker symbol.
   * @param       {string} walletId
   * @param       {Object} body
   * @param       {string length ≤ 250} body.address - Destination address.
   * @param       {string} body.amount - Amount in base units (e.g. satoshi, wei, drops, stroops). For doge, only string is allowed.
   * @param       {string} body.walletPassphrase - Passphrase to decrypt the user key on the wallet.
   * @param       {string length ≤ 256} body.comment - Optional metadata (only persisted in BitGo) to be applied to the transaction
   *
   * @return {Object}
   */
  public struct function send(required string coin, required string walletId, required struct body) output="false" {
    var response = _fetch(
      route  = "#arguments.coin#/wallet/#arguments.walletId#/sendcoins",
      body   = arguments.body,
      method = "post"
    );

    return _parse(response);
  }

  /**
   * Accelerate Transaction (This route is only available for Bitcoin)
   * Used to increase the effective fee rate of a stuck low-fee transaction.
   *
   * @description Send a new transaction to accelerate the targeted unconfirmed transaction either by using Child-Pays-For-Parent (CPFP) or Replace-By-Fee (RBF).
   * @param       {string} coin - A cryptocurrency or token ticker symbol.
   * @param       {string} walletId
   * @param       {Object} body
   * @param       {string} body.walletPassphrase - (Hot wallet only) Passphrase to decrypt the user key on the wallet to sign the transaction.
   * @param       {string[]} body.cpfpTxIds - txids of the transactions to bump
   * @param       {integer} body.cpfpFeeRate - Desired effective feerate of the bumped transactions and the CPFP transaction in satoshi per kilobyte
   * @param       {integer} body.maxFee - Maximum allowed fee for the CPFP transaction in satoshi
   *
   * @return {Object}
   */
  public struct function accelerateTx(required string coin, required string walletId, required struct body)
    output="false"
  {
    var response = _fetch(
      route  = "#arguments.coin#/wallet/#arguments.walletId#/acceleratetx",
      body   = arguments.body,
      method = "post"
    );

    return _parse(response);
  }

  /**
   * Fetch data from BitGo API
   *
   * @param {string} route - The route to fetch data from
   * @param {string} method - The HTTP method to use
   * @param {struct} body - The body to send with the request
   *
   * @return {struct} Objecte
   */
  private struct function _fetch(required string route, string method = "get", struct body = {}) output="false" {
    var response = "";

    http url="#variables.apiURL#/#arguments.route#" method="#arguments.method#" result="response" {
      httpparam type="header" name="Authorization" value="Bearer #variables.accessToken#";
      httpparam type="header" name="Content-Type" value="application/json";
      if (structCount(arguments.body)) {
        httpparam type="body" value="#serializeJSON(arguments.body)#";
      }
    }

    return response;
  }

  /**
   * Parse the response from BitGo API
   *
   * @param {struct} response - The response from BitGo API
   *
   * @return {struct} Objectt
   */
  private struct function _parse(required struct response) output="false" {
    var result      = {"error": "", "data": {}};
    var status_code = arguments.response.status_code;
    var fileContent = arguments.response.fileContent;
    var statusCode  = arguments.response.statusCode;

    /**
     * BitGo API HTTP status codes
     * https://developers.bitgo.com/reference/overview#http-status-codes
     * 200: Success - The operation succeeded.
     * 201: Created - A new object was created.
     * 202: Accepted - The operation succeeded, but requires approval (e.g., initiating a withdrawal).
     * 206: Partial Content - The server is delivering only part of the resource.
     * 400: Bad Request - The client request is invalid.
     * 401: Unauthorized - Authentication failed (e.g., invalid token specified by the Authorization header).
     * 403: Forbidden - Authentication failed, but the operation is not allowed.
     * 404: Not Found - Requested resource does not exist.
     * 429: Too Many Requests - Client request rate exceeded the limit.
     */

    if (not listFind("200,201,202,206", status_code)) {
      var errorMessage = "";
      if (isJSON(fileContent)) {
        var errorFileContent = deserializeJSON(fileContent);
        if (structKeyExists(errorFileContent, "error")) {
          errorMessage = errorFileContent.error;
        } else if (structKeyExists(errorFileContent, "message")) {
          errorMessage = errorFileContent.message;
        }
      }

      result.error = statusCode;
      if (len(trim(errorMessage))) {
        result.error &= " - " & errorMessage;
      }
    } else {
      var jsonResponse = fileContent;

      if (not isJSON(jsonResponse)) {
        result.error = "Response is not valid JSON.";
      } else {
        var structResponse = deserializeJSON(jsonResponse);

        result.data = structResponse;
      }
    }

    return result;
  }

}
