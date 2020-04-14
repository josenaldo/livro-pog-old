---
title: Sleeper Human Factor
description: 
image: 
sentence: Até ontém quando eu mexi estava tudo funcionando!
sentence-author: Resposta do POGramador ao ser questionado sobre a pane geral no sistema
---
Se a ação é rápida demais para o usuário perceber, coloque um atraso!

```java
public class MedidorDePOGresso implements Runnable {
    public void run() {
        while (true) {
            // Realiza um processamento rápido aqui...
            try {
                // ... atrasa propositalmente aqui
                Thread.sleep(1000);
            } catch (InterruptedException exc) {
            }
            progress.setValue(blablabla.getPorcentagem());
        }
    }
}
```