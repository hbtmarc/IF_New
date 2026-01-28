# Workflow

## Fonte do app
- Somente `canvas/Src/*.pa.yaml` e a fonte de verdade do app.

## Como atualizar
1. Baixe o `.msapp` no Power Apps Studio.
2. Rode o script para extrair `.pa.yaml`:

```powershell
.\tools\Export-PaYamlFromMsapp.ps1 -MsappPath "C:\caminho\app.msapp" -RepoPath "C:\caminho\repo"
```

## Aviso
- `.pa.yaml` e para revisao e controle de versao.
- Mudancas manuais podem ser perdidas; prefira editar no Power Apps Studio.
- Merge avancado e suportado principalmente via Git Integration.
