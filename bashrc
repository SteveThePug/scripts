alias vim=nvim

# Drop interactive host shells straight into the "dev" distrobox.
# Skip with: NO_DISTROBOX=1 bash
if [[ $- == *i* && -z $CONTAINER_ID && ! -e /run/.containerenv && -z $NO_DISTROBOX ]] \
   && command -v distrobox >/dev/null && podman container exists dev 2>/dev/null; then
  distrobox enter dev && exit  # falls back to host shell if enter fails
fi
