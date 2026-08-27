# config/private_dns_zone.tfvars
# Tracked, ready-to-run fixture for the test/live harness - one representative
# real-usage instance, not an engineered multi-path fixture.
#
# Mirrors what an actual landing-zone consumer deploys today: a single private
# DNS zone linked to a dedicated vnet. No for_each fan-out - one instance is
# enough to prove a breaking-change gate.
#
# The zone name must have 2+ labels (e.g. "live-test.internal") - Azure
# rejects single-label zone names with a 400 BadRequest.
#
# Maintained by whoever adds a new optional input to the module: update this
# file in the same PR if you want live coverage of it.

env = "livetest"

zone_name = "live-test.internal"

private_dns_zone = {
  resource_group = "DNS"
}
