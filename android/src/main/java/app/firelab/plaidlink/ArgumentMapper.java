package app.firelab.plaidlink;

import java.util.Map;

public interface ArgumentMapper<T> {
  Map<String, Object> apply(T data);
}
