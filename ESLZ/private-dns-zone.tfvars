privateDNSzone = {
  "privatelink.blob.core.windows.net" = { # Required: Key is the name of the private DNS zone
    resource_group = "DNS"                # Optional: Can be the name or ID of a resource group. Default: DNS RG
    # vnet_link = ""                        # Optional: Uncomment and enter a VNET ID that you want to link to your DNS zone
    # registration_enabled = false            # Optional: Possible values: true, false. Default: false
    # resolution_policy = "Default"          # Optional: Possible values: Default, NxDomainRedirect. Default: Default

    # Optional: Can uncomment if you need to set different defaults values. 
    # soa_record = {                         
    #   email = "maxime.mahdavian_ssc-spc.gc.ca"      # Email string cannot contain the @ sign
    #   expire_time = 2419200
    #   minimum_ttl = 60
    #   refresh_time = 3600
    #   ttl = 3600
    # }
  }
}
