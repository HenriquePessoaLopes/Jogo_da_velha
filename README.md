# Jogo da Velha

Jogo da velha para dois jogadores feito em **Flutter** (Dart), em azul e branco, com placar, layout que se adapta a qualquer tela e as regras do jogo separadas da interface e cobertas por testes.

## A história

Foi um dos primeiros projetos em Flutter: um jogo da velha de uma tela só, com botão "Start" e um cronômetro de 30 segundos para recomeçar. Ele funcionava no celular em pé, mas tinha pontas soltas: em tela larga o tabuleiro ficava cortado, depois de cada partida era preciso esperar o cronômetro para jogar de novo, o jogador O era escrito com o número zero e, com as atualizações do Flutter, o projeto parou de compilar por causa do pacote de fontes.

Nesta versão o jogo foi refeito por dentro e por fora, mantendo o tema azul e branco:

- As **regras** (quem joga, quem ganhou, empate) ficam num código à parte, sem nada de tela, e por isso são fáceis de testar.
- O **X** e o **O** são desenhados na tela (em vez de letras de uma fonte), então ficam nítidos em qualquer tamanho e não dependem de internet.
- O **layout se adapta**: em pé (placar em cima, tabuleiro no meio, botões embaixo) ou deitado/janela larga (tabuleiro de um lado, placar e botões do outro).
- Em vez de esperar 30 segundos, há um botão **"Jogar de novo"**.

## O que ele faz

- Dois jogadores, **X** e **O**, jogando no mesmo aparelho, alternando a vez.
- **Placar** com as vitórias de cada um e os empates. O cartão de quem joga agora fica branco, e o de quem venceu também.
- A **linha vencedora** fica destacada em roxo.
- **Quem abre o jogo alterna** a cada rodada, para ninguém jogar sempre primeiro.
- Botões **"Jogar de novo"** (ganha destaque quando a rodada termina; durante o jogo vira "Reiniciar rodada") e **"Zerar placar"**.
- Casas com leitura para leitores de tela ("Linha 1, coluna 2, X").

## Como rodar

Você precisa do **Flutter SDK** (<https://docs.flutter.dev/get-started/install>). Confira com `flutter --version`.

```powershell
git clone https://github.com/HenriquePessoaLopes/Jogo_da_velha.git
cd Jogo_da_velha
flutter pub get
flutter run -d chrome
```

Troque `chrome` por `windows` (precisa do Visual Studio com C++) ou pelo código do seu celular/emulador Android (`flutter devices` lista os disponíveis).

### Testes

```powershell
flutter test
```

São 55 testes, sem internet:

- **Regras:** as 8 linhas de vitória para o X e para o O, empate, vitória na nona jogada (que é vitória, não empate), jogadas inválidas (casa ocupada, fora do tabuleiro, depois do fim).
- **Placar e rodadas:** pontos, empates, quem abre o jogo e o "zerar placar".
- **Tela:** jogar, vitória, empate, "Jogar de novo", "Zerar placar" e que o tabuleiro cabe inteiro em 8 tamanhos de tela, em pé e deitada.

## Como o código está organizado

```
lib/
  main.dart               # app e tema
  main_color.dart         # cores (azul, branco, roxo e as cores do X e do O)
  tictactoe_page.dart     # a tela: escolhe o layout (em pé ou deitado) e liga tudo
  jogo/
    jogo_da_velha.dart    # as regras de UMA rodada (tabuleiro, vez, vencedor, empate)
    partida.dart          # várias rodadas: placar e quem abre o jogo
  widgets/
    tabuleiro.dart        # as 9 casas
    marca.dart            # o X e o O desenhados, com animação
    placar.dart           # o placar
test/                     # testes das regras, do placar e da tela
```

## Decisões

- **Lógica separada da tela** (`lib/jogo`): as regras não importam o Flutter, então os testes delas rodam em milissegundos e uma mudança de visual não pode quebrar o jogo.
- **Sem pacote de fontes**: o `google_fonts` foi removido. Ele baixava a fonte pela internet e deixou de compilar com versões novas do Flutter; sem ele o app é menor, funciona offline e usa a fonte padrão do sistema, que é legível.
- **Sem cronômetro**: o recomeço automático de 30 segundos deu lugar a um botão, que respeita o ritmo de quem está jogando.
