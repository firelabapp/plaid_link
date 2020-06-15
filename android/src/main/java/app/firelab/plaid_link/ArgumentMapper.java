package app.firelab.plaid_link;

import java.util.Map;

public interface ArgumentMapper<T> {
  Map<String, Object> apply(T data);
}
