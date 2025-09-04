exports.handler = async (event) => {
  const request  = event.Records[0].cf.request;
  const host = (request.headers.host && request.headers.host[0] && request.headers.host[0].value) || "";

  const subdomainPrefix = "pr-"

  // Not a ephemeral subdomain: pr-123.<DOMAIN>
  const hostMatchRegex = host.match(new RegExp(`^${escapeRegex(subdomainPrefix)}(\\d+)\\.`));
  if (!hostMatchRegex) return request; // Not a PR host → leave untouched

  const pr = hostMatchRegex[1];
  let uri = request.uri || "/";

  // Normalize leading slash
  if (!uri.startsWith("/")) uri = `/${uri}`;

  // Heuristic: if the last path segment has a dot, it's a file; otherwise it's a route
  const last = uri.split("/").pop();
  const isFileLike = last.includes(".");

  // Always prepend the pr-XXX prefix
  if (isFileLike) {
    // e.g., /assets/app.123.js -> /pr-123/assets/app.123.js
    request.uri = `/pr-${pr}${uri}`;
  } else {
    // e.g., /, /about, /docs/ -> /pr-123/index.html (SPA entry)
    request.uri = `/pr-${pr}/index.html`;
  }

  return request;
};

