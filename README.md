# IF_New
InspFlow New

## Estrutura
- `canvas/Src` - fonte do app (`*.pa.yaml`)
- `tools` - scripts auxiliares
- `docs` - fluxo recomendado

## Exportar .pa.yaml do .msapp
```powershell
.\tools\Export-PaYamlFromMsapp.ps1 -MsappPath "C:\caminho\app.msapp" -RepoPath "C:\caminho\repo"
```

Veja `docs/WORKFLOW.md` para detalhes.
