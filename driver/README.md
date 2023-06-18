# driver

Esse é o projeto do aplicativo do motorista do xBus.

O xBus é um projeto que consiste em oferecer um serviço de transporte, para alunos e funcionários da PUC-Rio, através da tilização de solução completa de software.

Esse foi desenvolvido com flutter versão 3.3.2.

## Arquitetura

Na pasta `driver/lib` encontra-se as pastas `config`, `models`, `screens`, `service` e `shared`, além do arquivo `main.dart`, que é onde chamamos funcão `main()`, entrypoint da aplicação.

Na pasta `config`, está o arquivo `google_maps_api_key.dart`, que possui a chave secreta do firebase e não deve ser commitado por motivos de segurança. Nesta pasta está também o arquivo `.gitignore`, que esconde os arquivos sensíveis no versionamento de código.

Na pasta `models` estão os arquivos que mapeiam os das entidades do banco de dados, indicando tipo e nullabilidade.

Na pasta `screens` estão os arquivos que implementam as telas do aplicativo.

Na pasta `service` temos os arquivos que intermedeiam  os dados entre o aplicativo e o firebase. Por ele acessamos as coleções e usuários salvos nessa nuvem.

Na pasta `shared` temos componentes reutilizáveis, como o `Loading`.

## Rodando

Para rodar o projeto, basta rodar o comando `flutter run` na pasta `driver`.

## Fluxo

Com o projeto rodando, a primeira tela que aparece é a de login.

Se o usuário já possuir credenciais para logar, basta fornecer os dados e clicar em Entrar para seguir em frente, caso contrário, pode clicar em Cadastrar para criar uma senha.

Na página de cadastro, o motorista pode fornecer seu número de documento para cadastrar uma senha de acesso ao app.

Caso o motorista, na página de cadastro, forneça um número de documento que não foi cadastrado previamente pelo administrador no sistema, a tela mostrará a mensagem "Digite um documento válido".

Na página inicial, o motorista seleciona uma rota. Aparecerá, então, um mapa com a rota destacada. Aparecerão, também, os horários programados para a rota selecionada. Ao selecionar um desses horários, aparecerá então a lista de veículos com capacidade suficiente para aquela viagem. Selecionando um veículo, pode- se, por fim, apertar o botão para iniciar a viagem. Caso não houver nenhuma rota cadastrada no sistema, a tela mostrará a mensagem "Nenhuma rota cadastrada". 

Caso uma rota tenha sido selecionada, mas não houver nenhum horário programado para essa rota no sistema, aparecerá a mensagem "Nenhum horário cadastrado" na tela. Caso uma rota e um horário tenham sido selecionados, mas não houver nenhum veículo cadastrado com a capacidade mínima requerida pelo administrador para tal viagem, aparecerá a mensagem "Nenhum veículo cadastrado" na tela.

Na página da viagem atual, pode-se ver as informações de qual rota está em andamento, a quantidade de passageiros no ônibus, os pontos em ordem e quais já foram visitados. Além disso, é possível clicar no ícone no canto inferior direito para ir para a página de validação de ticket, clicar ir para o próximo ponto para marcar o ponto atual como visitado ou finalizar a viagem.

Na página da validação de ticket, quando a câmera detecta um código, validade-se se o ticket está ativo e não foi usado ainda para mostrar a tela de sucesso. Ao voltar para a página da viagem atual, é possível perceber que a quantidade de passageiros no ônibus foi acrescida em uma unidade. 

Se a câmera detectar um código de um ticket que não está ativo ou já foi usado, a tela de falha será mostrada.