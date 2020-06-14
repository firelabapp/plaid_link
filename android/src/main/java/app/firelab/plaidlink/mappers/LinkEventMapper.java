package app.firelab.plaidlink.mappers;

import app.firelab.plaidlink.ArgumentMapper;
import com.plaid.link.event.LinkEvent;
import java.util.HashMap;
import java.util.Map;

public class LinkEventMapper implements ArgumentMapper<LinkEvent> {

  public static LinkEventMapper INSTANCE = new LinkEventMapper(LinkEventMetadataMapper.INSTANCE);
  private final LinkEventMetadataMapper metadataMapper;


  public LinkEventMapper(LinkEventMetadataMapper metadataMapper) {
    this.metadataMapper = metadataMapper;
  }

  @Override
  public Map<String, Object> apply(final LinkEvent data) {
    return new HashMap<String, Object>() {{
      put("eventName", data.getEventName().toString().toLowerCase());
      put("metadata", metadataMapper.apply(data.getMetadata()));
    }};
  }
}
