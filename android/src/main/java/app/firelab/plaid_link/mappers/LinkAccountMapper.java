package app.firelab.plaid_link.mappers;

import app.firelab.plaid_link.ArgumentMapper;
import com.plaid.link.result.LinkAccount;
import java.util.HashMap;
import java.util.Map;

public class LinkAccountMapper implements ArgumentMapper<LinkAccount> {

  public static final LinkAccountMapper INSTANCE = new LinkAccountMapper();

  @Override
  public Map<String, Object> apply(final LinkAccount data) {
    return new HashMap<String, Object>() {{
      put("id", data.getAccountId());
      put("name", data.getAccountName());
      put("mask", data.getAccountNumber());
      put("type", data.getAccountType());
      put("subtype", data.getAccountSubType());
      put("verificationStatus", data.getVerificationStatus());
    }};
  }
}
