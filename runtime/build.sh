#!/usr/bin/env bash

(
    echo '#!/usr/bin/env bash'
    echo ''
    echo "export besharp_runtime_version=\"$( cat "${besharp_root_dir}/runtime/BRVERSION" )\""
) > "${besharp_root_dir}/runtime/src/runtime/base/runtime-version.sh"

