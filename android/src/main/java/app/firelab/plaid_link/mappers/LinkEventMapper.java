package app.firelab.plaid_link.mappers;

import app.firelab.plaid_link.ArgumentMapper;
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
