package app.firelab.plaid_link.mappers;

import app.firelab.plaid_link.ArgumentMapper;
import com.plaid.link.result.LinkSuccess;
import java.util.HashMap;
import java.util.Map;

public class LinkSuccessMapper implements ArgumentMapper<LinkSuccess> {

  public static LinkSuccessMapper INSTANCE = new LinkSuccessMapper(LinkSuccessMetadataMapper.INSTANCE);

  private final LinkSuccessMetadataMapper metadataMapper;

  public LinkSuccessMapper(LinkSuccessMetadataMapper metadataMapper) {
    this.metadataMapper = metadataMapper;
  }

  @Override
  public Map<String, Object> apply(final LinkSuccess data) {
    return new HashMap<String, Object>() {{
      put("publicToken", data.getPublicToken());
      put("metadata", metadataMapper.apply(data.getMetadata()));
    }};
  }
}
