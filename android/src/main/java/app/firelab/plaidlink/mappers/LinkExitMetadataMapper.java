package app.firelab.plaidlink.mappers;

import app.firelab.plaidlink.ArgumentMapper;
import com.plaid.link.result.LinkExitMetadata;
import com.plaid.link.result.LinkExitMetadataStatus;
import java.util.HashMap;
import java.util.Map;

public class LinkExitMetadataMapper implements ArgumentMapper<LinkExitMetadata> {

  public static final LinkExitMetadataMapper INSTANCE = new LinkExitMetadataMapper();

  @Override
  public Map<String, Object> apply(final LinkExitMetadata data) {
    return new HashMap<String, Object>() {{
      put("exitStatus", data.getExitStatus());
      if (data.getInstitutionName() != null && data.getInstitutionId() != null) {
        put("institution", new HashMap<String, Object>() {{
          put("id", data.getInstitutionId());
          put("name", data.getInstitutionName());
        }});
      }
      put("linkSessionId", data.getLinkSessionId());
      put("requestId", data.getRequestId());

      LinkExitMetadataStatus status = data.getStatus();
      if (status != null) {
        put("status", status.jsonValue.toLowerCase());
      }
    }};
  }
}
