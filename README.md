# githubapi

## Solução adotada

A solução adotada foi montar duas telas listando os repositórios populares em swift e listando os PRs de cada repositório, na segunda tela é possivel escolher entre mostrar os PRs abertos, fechados ou todos

- O app possui cores dinâmicas em light e dark mode
<div align=center>
  <img src="https://github.com/user-attachments/assets/87070b69-c15f-44d8-89ed-64b77232a4e2" width=375 />
  <img src="https://github.com/user-attachments/assets/17467563-877f-4de5-b23d-65373a160928" width=375 />
</div>

- Fonte dinâmica
<div align=center>
  <img src="https://github.com/user-attachments/assets/b03a9acc-4763-4853-823e-4386ca74927a" width=375 />
  <img src="https://github.com/user-attachments/assets/1772ee13-b354-41e9-9b58-07bc6bf72861" width=375 />
</div>

- Fonte em negrito e accessibilidade de leitura de célula inteira da lista
<div align=center>
  <img src="https://github.com/user-attachments/assets/86a6c283-44a5-4d63-a838-cd65d0f80091" width=375 />
  <img src="https://github.com/user-attachments/assets/f0e45e8e-299f-4f7f-90c3-413b72079e4e" width=375 />
</div>

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
