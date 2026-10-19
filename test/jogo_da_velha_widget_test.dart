import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/main_color.dart';
import 'package:flutter_application_1/widgets/marca.dart';
import 'package:flutter_test/flutter_test.dart';

Finder casa(int i) => find.byKey(Key('casa-$i'));

String texto(WidgetTester tester, String chave) =>
    tester.widget<Text>(find.byKey(Key(chave))).data!;

String mensagem(WidgetTester tester) => texto(tester, 'mensagem');

Future<void> abrir(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
}

/// Toca nas casas, uma depois da outra (as cores e animações terminam em cada passo).
Future<void> tocar(WidgetTester tester, List<int> casas) async {
  for (final i in casas) {
    await tester.tap(casa(i));
    await tester.pumpAndSettle();
  }
}

const vitoriaDoX = [0, 3, 1, 4, 2];
const empate = [0, 1, 2, 4, 3, 5, 7, 6, 8];

void main() {
  testWidgets('começa com o tabuleiro vazio, vez do X e placar zerado', (
    tester,
  ) async {
    await abrir(tester);

    expect(find.byType(Marca), findsNothing);
    expect(mensagem(tester), 'Vez do jogador X');
    expect(texto(tester, 'placar-x-valor'), '0');
    expect(texto(tester, 'placar-o-valor'), '0');
    expect(texto(tester, 'placar-empates-valor'), '0');
    expect(find.text('Reiniciar rodada'), findsOneWidget);
  });

  testWidgets('os jogadores se chamam X e O (letra O, não zero)', (
    tester,
  ) async {
    await abrir(tester);

    expect(find.text('Jogador X'), findsOneWidget);
    expect(find.text('Jogador O'), findsOneWidget);
    expect(
      find.textContaining('0'),
      findsWidgets,
    ); // só aparecem como números do placar
    expect(find.text('Jogador 0'), findsNothing);
  });

  testWidgets('jogar alterna a vez e desenha as marcas', (tester) async {
    await abrir(tester);

    await tocar(tester, [4]);
    expect(find.byType(Marca), findsOneWidget);
    expect(mensagem(tester), 'Vez do jogador O');

    await tocar(tester, [0]);
    expect(find.byType(Marca), findsNWidgets(2));
    expect(mensagem(tester), 'Vez do jogador X');
  });

  testWidgets('tocar numa casa ocupada não faz nada', (tester) async {
    await abrir(tester);

    await tocar(tester, [4, 4]);
    expect(find.byType(Marca), findsOneWidget);
    expect(mensagem(tester), 'Vez do jogador O');
  });

  testWidgets(
    'vitória: mostra quem venceu, soma ponto, destaca a linha e bloqueia o tabuleiro',
    (tester) async {
      await abrir(tester);
      await tocar(tester, vitoriaDoX);

      expect(mensagem(tester), 'Jogador X venceu!');
      expect(texto(tester, 'placar-x-valor'), '1');
      expect(find.text('Jogar de novo'), findsOneWidget);

      // As três casas da linha de cima ficam roxas; as outras continuam brancas.
      Color fundoDa(int i) =>
          (tester
                      .widget<AnimatedContainer>(
                        find.descendant(
                          of: casa(i),
                          matching: find.byType(AnimatedContainer),
                        ),
                      )
                      .decoration
                  as BoxDecoration)
              .color!;
      for (final i in [0, 1, 2]) {
        expect(fundoDa(i), MainColor.accentColor, reason: 'casa $i');
      }
      expect(fundoDa(5), MainColor.secondaryColor);

      // Depois da vitória, tocar não muda o jogo.
      await tocar(tester, [8]);
      expect(find.byType(Marca), findsNWidgets(5));
    },
  );

  testWidgets('empate: mostra "Empate!" e soma um empate', (tester) async {
    await abrir(tester);
    await tocar(tester, empate);

    expect(mensagem(tester), 'Empate!');
    expect(texto(tester, 'placar-empates-valor'), '1');
    expect(find.text('Jogar de novo'), findsOneWidget);
  });

  testWidgets(
    '"Jogar de novo" limpa o tabuleiro, mantém o placar e troca quem abre',
    (tester) async {
      await abrir(tester);
      await tocar(tester, vitoriaDoX);

      await tester.tap(find.byKey(const Key('jogar-de-novo')));
      await tester.pumpAndSettle();

      expect(find.byType(Marca), findsNothing);
      expect(texto(tester, 'placar-x-valor'), '1');
      expect(mensagem(tester), 'Vez do jogador O');
    },
  );

  testWidgets(
    '"Reiniciar rodada" no meio do jogo limpa o tabuleiro sem trocar quem abre',
    (tester) async {
      await abrir(tester);
      await tocar(tester, [0, 1]);

      await tester.tap(find.byKey(const Key('jogar-de-novo')));
      await tester.pumpAndSettle();

      expect(find.byType(Marca), findsNothing);
      expect(mensagem(tester), 'Vez do jogador X');
    },
  );

  testWidgets('"Zerar placar" só fica ativo com placar e zera tudo', (
    tester,
  ) async {
    await abrir(tester);
    OutlinedButton botao() =>
        tester.widget<OutlinedButton>(find.byKey(const Key('zerar-placar')));

    expect(botao().onPressed, isNull);

    await tocar(tester, vitoriaDoX);
    expect(botao().onPressed, isNotNull);

    await tester.tap(find.byKey(const Key('zerar-placar')));
    await tester.pumpAndSettle();

    expect(texto(tester, 'placar-x-valor'), '0');
    expect(find.byType(Marca), findsNothing);
    expect(mensagem(tester), 'Vez do jogador X');
    expect(botao().onPressed, isNull);
  });

  group('cabe em qualquer tela, em pé ou deitada', () {
    for (final tamanho in const [
      Size(320, 568), // celular pequeno
      Size(360, 640),
      Size(390, 844),
      Size(768, 1024), // tablet em pé
      Size(844, 390), // celular deitado
      Size(800, 600), // janela pequena do computador
      Size(1280, 800),
      Size(1920, 1080),
    ]) {
      testWidgets('${tamanho.width.toInt()}x${tamanho.height.toInt()}', (
        tester,
      ) async {
        tester.view.physicalSize = tamanho;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await abrir(tester);
        await tocar(tester, vitoriaDoX);

        expect(tester.takeException(), isNull);
        // As 9 casas continuam inteiras dentro da tela (nenhuma cortada).
        for (var i = 0; i < 9; i++) {
          final retangulo = tester.getRect(casa(i));
          expect(retangulo.left, greaterThanOrEqualTo(0), reason: 'casa $i');
          expect(retangulo.top, greaterThanOrEqualTo(0), reason: 'casa $i');
          expect(
            retangulo.right,
            lessThanOrEqualTo(tamanho.width),
            reason: 'casa $i',
          );
          expect(
            retangulo.bottom,
            lessThanOrEqualTo(tamanho.height),
            reason: 'casa $i',
          );
        }
      });
    }
  });
}
