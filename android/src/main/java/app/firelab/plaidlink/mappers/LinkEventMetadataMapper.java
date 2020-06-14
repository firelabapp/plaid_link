package app.firelab.plaidlink.mappers;

import app.firelab.plaidlink.ArgumentMapper;
import com.plaid.link.event.LinkEventMetadata;
import com.plaid.link.event.LinkEventViewName;
import java.util.HashMap;
import java.util.Map;

public class LinkEventMetadataMapper implements ArgumentMapper<LinkEventMetadata> {

  public static final LinkEventMetadataMapper INSTANCE = new LinkEventMetadataMapper();

  @Override
  public Map<String, Object> apply(final LinkEventMetadata data) {
    return new HashMap<String, Object>() {{
      put("errorCode", data.getErrorCode());
      put("errorMessage", data.getErrorMessage());
      put("errorType", data.getErrorType());
      put("exitStatus", data.getExitStatus());
      if (data.getInstitutionName() != null && data.getInstitutionId() != null) {
        put("institution", new HashMap<String, Object>() {{
          put("id", data.getInstitutionId());
          put("name", data.getInstitutionName());
        }});
      }
      put("institutionSearchQuery", data.getInstitutionSearchQuery());
      put("linkSessionId", data.getLinkSessionId());
      put("mfaType", data.getMfaType());
      put("requestId", data.getRequestId());
      put("timestamp", data.getTimestamp());

      LinkEventViewName viewName = data.getViewName();
      put("viewName", viewName == null ? null : viewName.getJsonValue().toLowerCase());
    }};
  }
}
