# githubapi

## Solução adotada

A solução adotada foi montar duas telas listando os repositórios populares em swift e listando os PRs de cada repositório, na segunda tela é possivel escolher entre mostrar os PRs abertos, fechados ou todos

## Libs Utilizadas

Apenas 'Stevia' para facilitar a construção de auto-layout

## Arquitetura

MVVM com separação de responsabilidade em View para layout, Service para requisições online, Coordinator para navegação e Factory para injeção de dependências 

## Escolhas feitas

Decidi separar o módulo de networking com funções de contrução de request para facilitar a construção de diversas classes de serviço e desacoplar a dependência da API através de protocolos

Decidi separar o módulo de componentes para agrupar classes e funções reaproveitáveis relacionadas apenas as features implementadas

## Instruções

Antes de abrir o projeto é necessário instalar o Pod utilizado
É necessário possuir cocoapods instalado na sua máquina, para mais detalhes visite "https://cocoapods.org"
Para isso, com o terminal, vá até o local do projeto e digite o seguinte comando para instalação dos Pods:
```
pod install
``` 

Dentro do projeto no modulo 'Networking' abra o arquivo 'GitHubApiTarget.swift'
Nele há um campo vazio chamado token, é necessário gerar e adicionar um token do github para evitar o limite de acesso da API
Para mais detalhes visite "https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens"

Deve ficar algo como:
```
let token = "ghp_xxxxxxxxxxxxxxxx"
```

Com o token devidamente colocado e os pods instalados, abra o arquivo 'GithubApi.xcworkspace' selecione um simulador no projeto e clique no ícone play no canto superior esquerdo do XCode
Caso queira instalar num device físico, será necessário uma conta de desenvolvedor no projeto
