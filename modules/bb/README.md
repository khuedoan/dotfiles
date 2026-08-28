# bb

Set the password:

```sh
{ printf '%s:' "$(id -un)"; mkpasswd -m bcrypt; } \
  | sudo install -o root -g nginx -m 0640 /dev/stdin /var/lib/nginx/bb.htpasswd \
  && sudo systemctl restart nginx
```
