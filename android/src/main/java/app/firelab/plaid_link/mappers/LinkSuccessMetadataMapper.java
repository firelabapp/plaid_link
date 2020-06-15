package app.firelab.plaid_link.mappers;

import app.firelab.plaid_link.ArgumentMapper;
import com.plaid.link.result.LinkAccount;
import com.plaid.link.result.LinkSuccess.LinkSuccessMetadata;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class LinkSuccessMetadataMapper implements ArgumentMapper<LinkSuccessMetadata> {

  public static final LinkSuccessMetadataMapper INSTANCE = new LinkSuccessMetadataMapper(
      LinkAccountMapper.INSTANCE);

  private final LinkAccountMapper accountMapper;

  public LinkSuccessMetadataMapper(LinkAccountMapper accountMapper) {
    this.accountMapper = accountMapper;
  }

  @Override
  public Map<String, Object> apply(final LinkSuccessMetadata data) {
    return new HashMap<String, Object>() {{
      put("linkSessionId", data.getLinkSessionId());
      if (data.getInstitutionName() != null && data.getInstitutionId() != null) {
        put("institution", new HashMap<String, Object>() {{
          put("id", data.getInstitutionId());
          put("name", data.getInstitutionName());
        }});
      }
      put("accounts", new ArrayList<Map<String, Object>>() {{
        for (LinkAccount account : data.getAccounts()) {
          add(accountMapper.apply(account));
        }
      }});
    }};
  }
}
