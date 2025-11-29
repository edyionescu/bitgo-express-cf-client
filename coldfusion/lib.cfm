<cfscript>
cfprocessingdirective(pageEncoding = "utf-8");

public void function dotenv(string path = ".env") output=false {
  var shoudLoad = (not structKeyExists(application, "env") or !isStruct(application.env) || !structCount(application.env)) || (
    structKeyExists(application, "env") and isStruct(application.env) && structKeyExists(
      application.env,
      "__ENVIRONMENT__"
    )
      and !application.env.__ENVIRONMENT__ == request.ENVIRONMENT
  );

  if (shoudLoad) {
    if (structKeyExists(application, "env") && !isStruct(application.env)) {
      application.env = {};
    }

    if (fileExists("/disk_root/#arguments.path#")) {
      var content = fileRead("/disk_root/#arguments.path#");

      for (var item in listToArray(content, chr(13) & chr(10))) {
        var isComment = left(trim(item), 1) is "##";
        if (!isComment) {
          var firstEqualSign = find("=", item);

          if (firstEqualSign gt 0) {
            var key   = trim(left(item, firstEqualSign));
            var value = trim(replace(item, key, ""));
            key       = trim(left(key, len(key) - 1));

            application.env[key] = value;
          }
        }
      }
    }

    application.env.__ENVIRONMENT__ = request.ENVIRONMENT;
  }
}

public void function reloadEnv() output=false {
  application.env = {};
  dotenv(path: ".env.#request.ENVIRONMENT#");
}

public string function env(required string name) output=false {
  if (!structKeyExists(application.env, arguments.name)) {
    reloadEnv();

    if (!structKeyExists(application.env, arguments.name)) {
      throw(message = "Unknown environment variable '#arguments.name#'.");
    }
  }

  return application.env[arguments.name];
}
</cfscript>
