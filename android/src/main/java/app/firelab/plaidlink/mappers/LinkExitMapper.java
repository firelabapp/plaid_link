package app.firelab.plaidlink.mappers;

import app.firelab.plaidlink.ArgumentMapper;
import com.plaid.link.result.LinkError;
import com.plaid.link.result.LinkExit;
import java.util.HashMap;
import java.util.Map;

public class LinkExitMapper implements ArgumentMapper<LinkExit> {

  public static LinkExitMapper INSTANCE = new LinkExitMapper(LinkErrorMapper.INSTANCE,
      LinkExitMetadataMapper.INSTANCE);

  private final LinkErrorMapper errorMapper;
  private final LinkExitMetadataMapper metadataMapper;


  public LinkExitMapper(LinkErrorMapper errorMapper, LinkExitMetadataMapper metadataMapper) {
    this.errorMapper = errorMapper;
    this.metadataMapper = metadataMapper;
  }

  @Override
  public Map<String, Object> apply(final LinkExit data) {
    return new HashMap<String, Object>() {{
      LinkError error = data.getError();
      if (error != null) {
        put("error", errorMapper.apply(data.getError()));
      }
      put("metadata", metadataMapper.apply(data.getMetadata()));
    }};
  }
}
