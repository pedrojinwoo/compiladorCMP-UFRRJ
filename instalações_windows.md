# Configurar MinGW
Utilizar o site: https://winlibs.com/ e pegar a versão mais atual.

Extrair para local desejado

Incluir no Path global.

# Configurar Flex/Bison
Utilizar o comando: winget install -e --id WinFlexBison.win_flex_bison
Aceitar os termos

Geralmente o winget já faz inclusão dos Paths... se não o fizer, basa fazê-lo.

Mudar comandos de "flex" para "win_flex" e de "bison" para "win_bison".

# Configurar make
Utilizar o comando: winget install -e --id GnuWin32make

Adicionar Path do make

Mudar comandos de "./glf" para "glf"