# frozen_string_literal: true

DPI_TENANT_NAME = 'dpi'
FAO_TENANT_NAME = 'fao'
DEFAULT_TENANT_NAME = 'public'

# https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400
# We will return this for locked elements of the exchange: CDS-2062.
BAD_REQUEST = 'BAD_REQUEST'
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/403
# Authenticated user, but don't have permission to perform this action.
FORBIDDEN = 'FORBIDDEN'
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/401
# Unauthenticated user trying to access a protected resource.
UNAUTHORIZED = 'UNAUTHORIZED'

VIEWING_CONTEXT = 'viewing'
EDITING_CONTEXT = 'editing'
DELETING_CONTEXT = 'deleting'
CREEATING_CONTEXT = 'creating'
