package app.firelab.plaidlink.mappers;

import app.firelab.plaidlink.ArgumentMapper;
import com.plaid.link.result.LinkError;
import java.util.HashMap;
import java.util.Map;

public class LinkErrorMapper implements ArgumentMapper<LinkError> {

  public static LinkErrorMapper INSTANCE = new LinkErrorMapper();

  @Override
  public Map<String, Object> apply(final LinkError data) {
    return new HashMap<String, Object>() {{
      put("errorCode", data.getErrorCode());
      put("errorMessage", data.getErrorMessage());
      put("errorType", data.getErrorType());
      put("displayMessage", data.getDisplayMessage());
    }};
  }
}
