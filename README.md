# Skybert GitOps-mal

Dette repositoryet er ment å brukes som en mal når man lager et nytt GitOps repository for bruk i Skybert


## Innhold
Dette repoet inneholder det grunnleggende for å komme i gang med GitOps ved hjelp av blåløypa til Skybert. Det baserer seg på Helm, og benytter et [base chart](https://github.com/FHISkybert/Fhi.Skybert.HelmCharts/tree/main/base-app) for en enkel webapplikasjon med fornuftige standardverdier. Det anbefales å utforske [values-fila](https://github.com/FHISkybert/Fhi.Skybert.HelmCharts/blob/main/base-app/values.yaml) for en oversikt over hvilke ting som kan konfigureres, og hva standardverdiene er.

Det inneholder også en GitHub workflow for å bygge og pushe innhold til Skybert's container registry. Denne workflowen er konfigurert til å bygge ett image per mappe i repoet - utgangspunktet produserer `<APPLICATION_NAME>_test`, og om test-mappen kopieres til `prod`, vil man få et nytt image `<APPLICATION_NAME>_prod`

## Kom i gang

[Klikk her](https://github.com/new?owner=FHIDev&template_name=Fhi.Skybert.Template.GitOps&template_owner=FHISkybert) for å opprette et nytt repo basert på denne malen.

Når nytt repo er opprettet, må det gjøres endringer i `test/values.yaml` og `.github/workflows/oci-push.yaml`. For Workflow er det KUN env-variabler øverst i fila som behøver å endres. Imidlertid lener denne workflowen seg på tre variabler som må være konfigurert for repoet: 
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

Disse brukes for federert tilgang til en Managed Identity i Azure, som skal ha push-tilgang til ACR-repoet for applikasjonen

I dette repoet finnes også en pre-commit hook som kan kopieres inn til `.git/hooks` - dette kan hjelpe med å validere Helm-chartet.

---

Ta kontakt på NHN Slack, kanal #ext-fhi-skybert - eller kontakt Sindre Alvær for tilgang til denne.