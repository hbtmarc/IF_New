# Merge Report — InspFlow-pa (Old → Merged com design New)

## Sumário executivo
- Base usada: Old (funcionalidade preservada).
- Design aplicado: New (apenas propriedades visuais permitidas).
- Telas mapeadas: 2.
- Controles com match exato de nome entre telas mapeadas: 0.
- Alterações aplicadas: somente propriedades visuais de nível de tela (Fill e LoadingSpinnerColor).
- Nenhuma lógica (OnVisible/OnSelect/Items/etc.) foi modificada.

## Diretórios
- Old: c:\Users\GC0P\OneDrive - PETROBRAS\Área de Trabalho\Desktop\InspFlow-pa\Old
- New: c:\Users\GC0P\OneDrive - PETROBRAS\Área de Trabalho\Desktop\InspFlow-pa\New
- Merged: c:\Users\GC0P\OneDrive - PETROBRAS\Área de Trabalho\Desktop\InspFlow-pa\Merged

## Mapeamento de telas (Old → New)
- TelaInicial 2.0 → Home
  - Heurística: similaridade semântica (tela inicial vs home)
- Passagem de Serviço 2.0 → PassagemdeServico
  - Heurística: similaridade de nome (remoção de espaços/acentos)

## Controles mapeados
- Mapeamento por nome exato dentro das telas mapeadas: nenhum controle com nome idêntico foi encontrado entre Old e New.
- Controles do New não foram adicionados ao Old por risco de quebra de navegação, ZIndex e estruturas de contêiner (regra 2 e 3).

## Propriedades visuais aplicadas
### TelaInicial 2.0 (Old) ← Home (New)
- Screen.Fill: aplicado
- Screen.LoadingSpinnerColor: aplicado

### Passagem de Serviço 2.0 (Old) ← PassagemdeServico (New)
- Screen.Fill: aplicado
- Screen.LoadingSpinnerColor: aplicado

## Propriedades bloqueadas (por lógica ou risco)
- Todas as propriedades funcionais: OnStart, OnVisible, OnHidden, OnSelect, OnChange, Items, Default, Update, Patch/SubmitForm/Remove/Navigate/Set/UpdateContext, etc.
- DisplayMode (bloqueado por padrão).
- Visible (mantido quando envolve fórmulas ou lógica; sem equivalência literal nos pares).
- X/Y/Width/Height (não aplicados por ausência de controles com match exato).

## Assets e temas
- Não foi feita migração automática de Themes.json/Resources/Assets por ausência de mapeamento seguro entre controles e risco de quebrar referências visuais.

## Validações (anti-quebra)
- Referências e datasources: preservadas, pois não houve renome de controles nem alteração de fórmulas.
- Navegação: preservada (nenhuma mudança em Navigate()).
- Sintaxe: alterações limitadas a propriedades visuais simples em nível de tela.

## Riscos e pontos de atenção
1) Diferença estrutural entre Old e New: sem controles com match exato, o design do New não foi propagado para controles internos.
2) Para aplicar o layout moderno do New, será necessário um mapeamento manual de containers e controles entre as telas correspondentes.
3) Caso seja desejado inserir controles decorativos do New no Old, recomenda-se revisão manual de ZIndex e verificação de interceptação de cliques.

## Próximos passos recomendados
- Validar manualmente a equivalência entre controles-chave (menu, cabeçalho, cards) e definir um mapa explícito para migração visual.
- Caso aprovado, executar uma segunda rodada de merge focada em containers principais (com revisão de referências e visibilidade).

