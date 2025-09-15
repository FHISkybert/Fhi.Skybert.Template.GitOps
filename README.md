# Skybert GitOps-mal

Dette repositoryet er ment å brukes som en mal når man lager et nytt GitOps repository for bruk i Skybert


## Innhold
Dette repoet inneholder det grunnleggende for å komme i gang med GitOps ved hjelp av blåløypa til Skybert. Det baserer seg på en egenutviklet WebApp-ressurs som gjør det enkelt å sette opp en grunnleggende webapplikasjon. Full dokumentasjon på denne kommer straks, men enn så lenge kan plattformteamet bistå i utformingen.

Det inneholder også en GitHub workflow `oci-push.yaml` for å bygge og pushe innhold til Skybert's container registry. Denne workflowen er konfigurert til å bygge ett image per mappe i repoet - utgangspunktet produserer `<APPLICATION_NAME>_test`, og om test-mappen kopieres til `prod`, vil man få et nytt image `<APPLICATION_NAME>_prod`. Workflowen vil bruke Helm eller Kustomize for å bygge innholdet dersom det benyttes.

Workflowen `update-tag.yaml` kan brukes med webhook for å trigge en deploy ved bygging av nye applikasjonsimages. 

## Kom i gang

[Klikk her](https://github.com/new?owner=FHIDev&template_name=Fhi.Skybert.Template.GitOps&template_owner=FHISkybert) for å opprette et nytt repo basert på denne malen.

Når nytt repo er opprettet, må det gjøres endringer i `.github/workflows/oci-push.yaml` - det er KUN env-variablen `APP_NAME` øverst i fila som behøver å endres. Imidlertid lener denne workflowen seg på tre variabler som må være konfigurert for repoet: 
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

Disse brukes for federert tilgang til en Managed Identity i Azure, som skal ha push-tilgang til ACR-repoet for applikasjonen. Disse variablene skal du ha fått av plattformteamet.


---

Ta kontakt på NHN Slack, kanal #ext-fhi-skybert - eller kontakt Sindre Alvær for tilgang til denne.