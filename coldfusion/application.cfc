component {

  this.name               = "bitgo-express-client";
  this.mappings           = {"/disk_root": getDirectoryFromPath(getCurrentTemplatePath())};
  this.applicationTimeout = createTimespan(0, 2, 0, 0);

  public void function onRequestStart(string targetPage) {
    request.ENVIRONMENT = "dev";
  }

}
