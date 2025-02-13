#!/usr/bin/env bash
set -euxo pipefail
cd "$(dirname "$0")/.."

rm -rf /tmp/nextcloud-neon
mkdir -p /tmp/nextcloud-neon

function generate_spec() {
    path="$1"
    codename="$2"
    ../nextcloud-openapi-extractor/generate-spec "$path" "/tmp/nextcloud-neon/$codename.openapi.json" --first-content-type --openapi-version 3.1.0

    # Use the full spec if it exists, otherwise use the default spec which is already the full spec.
    if [ -f "/tmp/nextcloud-neon/$codename.openapi-full.json" ]; then
      jq --indent 4 \
        ".info.title = \"$codename\"" \
        "/tmp/nextcloud-neon/$codename.openapi-full.json" \
        > "/tmp/nextcloud-neon/$codename.openapi.json"
    fi
}

(
  cd external/nextcloud-openapi-extractor
  composer install
)

(
  cd external/nextcloud-server

  for path in core apps/*; do
    if [ ! -f "$path/.noopenapi" ] &&
    [[ "$path" != "apps/cloud_federation_api" ]] &&
    [[ "$path" != "apps/federatedfilesharing" ]] &&
    [[ "$path" != "apps/federation" ]] &&
    [[ "$path" != "apps/oauth2" ]]; then
      generate_spec "$path" "$(basename "$path")"
    fi
  done
)

(
  cd external/nextcloud-notifications
  generate_spec "." "notifications"
)
(
  cd external/nextcloud-spreed
  generate_spec "." "spreed"
)
(
  cd external/nextcloud-drop_account
  generate_spec "." "drop_account"
)
(
  cd external/nextcloud-tables
  generate_spec "." "tables"
)
(
  cd external/nextcloud-password_policy
  generate_spec "." "password_policy"
)
(
  yq -s '.[0]."components"."schemas" = .[1] | .[0] | walk(if type == "object" then with_entries( if (.key == "$ref" and (.value | test("#\/components\/schemas\/") | not)  ) then .value |= sub("#\/"; "#/components/schemas/") else . end ) else . end) | .paths |= with_entries(.key = "/index.php/apps/cookbook\(.key)")' \
  external/nextcloud-cookbook/docs/dev/api/0.1.2/openapi-cookbook.yaml \
  external/nextcloud-cookbook/docs/dev/api/0.1.2/objects.yaml \
  > /tmp/nextcloud-neon/cookbook.openapi.json
)

./tool/generate-rich-objects-patch.php

for spec in /tmp/nextcloud-neon/*.openapi.json; do
  name="$(basename "$spec" | cut -d "." -f 1)"
  dir="packages/nextcloud/lib/src/api/$name/patches"
  if [ -d "$dir" ] && [[ "$name" != "core" ]]; then
    for patch in "$dir/"*; do
      jsonpatch --indent 4 --in-place "$spec" "$patch"
    done
  fi

  mkdir -p "packages/nextcloud/lib/src/api/$name"
  cp "$spec" "packages/nextcloud/lib/src/api/$name/"
done


./external/nextcloud-openapi-extractor/merge-specs \
  --core /tmp/nextcloud-neon/core.openapi.json \
  --merged /tmp/nextcloud-neon/merged.json \
  /tmp/nextcloud-neon/*.openapi.json \
  packages/nextcloud/lib/src/api/news/news.openapi.json \
  packages/nextcloud/lib/src/api/notes/notes.openapi.json \
  packages/nextcloud/lib/src/api/uppush/uppush.openapi.json \
  --openapi-version 3.1.0

jq \
  --indent 4 \
  -s \
  '.[0] * {components: {schemas: .[1].components.schemas | with_entries(select(.key | endswith("Capabilities")))}, paths: {"/ocs/v2.php/cloud/capabilities": {get: {responses: .[1].paths."/ocs/v2.php/cloud/capabilities".get.responses}}}}' \
  /tmp/nextcloud-neon/core.openapi.json \
  /tmp/nextcloud-neon/merged.json \
  > packages/nextcloud/lib/src/api/core/core.openapi.json

for patch in "packages/nextcloud/lib/src/api/core/patches/"*; do
  jsonpatch --indent 4 --in-place packages/nextcloud/lib/src/api/core/core.openapi.json "$patch"
done
