# Cloudflare

## Domain Transfer

- previous registrar - iwebfusion
- new registrar Cloudflare
- https://my.iwebfusion.net/knowledgebase/33/How-do-I-transfer-my-domain-name.html
- https://developers.cloudflare.com/registrar/get-started/transfer-domain-to-cloudflare/

## Cloudflare API token

- click site > Overview > API > Get your API token
- Create API token
  - Edit zone DNS - Use Template
  - token name: `*.barrettotte.com`
  - Permissions: Zone, DNS, Edit
  - Zone Resources: Include, Specific zone, `barrettotte.com`
- Save token in secure place

```sh
# verify token

curl -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
     -H "Authorization: Bearer CLOUDFLARE_API_TOKEN" \
     -H "Content-Type:application/json"
```

## Nginx Proxy Manager + Cloudflare Wildcard Cert

Cloudflare: added DNS records

- no root record, I don't have a public box to point to...
- `CNAME, www, barretttotte.com, proxied`
- `CNAME, agartha, barrettotte.com, proxied`

SSL Certificates > Add SSL Certificate
- Domain names: `*.agartha.barrettotte.com`, `*.barrettotte.com`
- Email Address for Let's Encrypt: email
- Use a DNS Challenge: yes
- DNS Provider: Cloudflare
- Credentials File Content: Paste Cloudflare API token obtained earlier
- 

https://www.youtube.com/watch?v=AS0HydTEuA4


## Domain Changes Needed

- Changed DNS search domain of pihole: Proxmox > pihole > DNS

### Opnsense

Changed Domain of opnsense: System > Settings > General

See section titled "SSL Certs" in [opnsense.md](opnsense.md)

See section title "SSL Certs" in [proxmox.md](proxmox.md)
