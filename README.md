# openshift-demo

## Template Parameters

```
- description: The name for the ruby application.
  name: RUBY_APP_NAME
  value: rubyharu
- description: The name for the redis application.
  name: REDIS_APP_NAME
  value: redisharu
- description: The name for the project.
  name: PROJECT_NAME
  value: boom1
- description: Redis trigger secret
  name: TRIGGER_SECRET_REDIS
  from: "[a-zA-Z0-9]{8}"
  generate: expression
- description: Ruby trigger secret
  name: TRIGGER_SECRET_RUBY
  from: "[a-zA-Z0-9]{8}"
  generate: expression
- description: Redis Password
  name: REDIS_PASSWORD
  from: "[a-zA-Z0-9]{8}"
  generate: expression
```

## I don't want TLS

run the template

`oc process -f project.yml | oc create -f -`

Run the builds...

```
oc start-build redis-build
oc start-build ruby-build
```

When the builds are finished , they will trigger a deploy and your app will be deployed


your app will be available at

`http://${RUBY_APP_NAME}-${PROJECT_NAME}.<apps-domain>/`


In the example..

`https://rubyharu-boom1.apps.haru.sh/`

## I want TLS!

Run the following commands..

```bash
oc create -fhttps://raw.githubusercontent.com/tnozicka/openshift-acme/master/deploy/letsencrypt-live/single-namespace/{role,serviceaccount,imagestream,deployment}.yaml
oc policy add-role-to-user openshift-acme --role-namespace="$(oc project --short)" -z openshift-acme
```

Wait a while and after that run the template for TLS

`oc process -f project-tls.yml | oc create -f -`

Run the builds...

```
oc start-build redis-build
oc start-build ruby-build
```

When the builds are finished , they will trigger a deploy and your app will be deployed

your app will be available at

`http://${RUBY_APP_NAME}-${PROJECT_NAME}.<apps-domain>/`


In the example..

`https://rubyharu-boom1.apps.haru.sh/`

## Setting up the Github Webhooks

Run the command

```
oc describe bc/redis-build
oc describe bc/ruby-build
```

Get the secrets...

`oc get secret redis-build-trigger -o yaml | grep "WebHookSecretKey" | cut -d':' -f2 | sed 's/ //g' | base64 --decode`

`oc get secret ruby-build-trigger -o yaml | grep "WebHookSecretKey" | cut -d':' -f2 | sed 's/ //g' | base64 --decode`

And add them to github by substituting the `<secret>` you get from `oc describe` with the secret.

Be sure to mark `application/json` as the content-type

Enjoy!!!
