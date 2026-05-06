# 📱 Lista de Tarefas

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com/)
[![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)](https://developer.apple.com/ios/)

Um aplicativo móvel elegante e intuitivo para gerenciamento de tarefas pessoais, desenvolvido com Flutter. Este projeto foi criado como parte da disciplina **Desenvolvimento Mobile com Flutter [26E2_2]**.

## ✨ Funcionalidades

- **📝 Criar Tarefas**: Adicione novas tarefas com nome, data e hora programada
- **📍 Localização Integrada**: Associe tarefas a locais específicos usando GPS e geocodificação
- **🗓️ Agendamento**: Defina datas e horários para suas tarefas
- **📱 Interface Responsiva**: Design moderno e adaptável para diferentes tamanhos de tela
- **🌍 Suporte Multi-idioma**: Interface em português brasileiro e inglês
- **🗑️ Gerenciamento Completo**: Visualize, edite e exclua tarefas facilmente
- **📊 Detalhes Completos**: Veja informações detalhadas de cada tarefa, incluindo localização formatada

## 🛠️ Tecnologias Utilizadas

- **Framework**: Flutter
- **Linguagem**: Dart
- **Localização**: Geolocator + Geocoding
- **Internacionalização**: Flutter Localizations + Intl
- **Arquitetura**: Clean Architecture (Domain-Driven Design)
- **Gerenciamento de Estado**: Stateful Widgets

### Dependências Principais

- `geolocator: ^14.0.2` - Para obter localização GPS
- `geocoding: ^4.0.0` - Para converter coordenadas em endereços
- `intl: ^0.20.2` - Para formatação de datas e internacionalização

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão 3.11.1 ou superior)
- [Dart SDK](https://dart.dev/get-dart) (incluído no Flutter)
- Um editor de código como [Visual Studio Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio)
- Dispositivo físico ou emulador para testes

### Verificar Instalação

```bash
flutter doctor
```

## 🚀 Instalação e Execução

1. **Clone o repositório**:

   ```bash
   git clone https://github.com/seu-usuario/lista-de-tarefas.git
   cd lista-de-tarefas
   ```

2. **Instale as dependências**:

   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo**:
   ```bash
   flutter run
   ```

### Plataformas Suportadas

O aplicativo pode ser executado em:

- **📱 Android**: `flutter run` (dispositivo/emulador Android)
- **🍎 iOS**: `flutter run` (dispositivo/simulador iOS, apenas macOS)
- **🖥️ Desktop**:
  - Linux: `flutter run -d linux`
  - macOS: `flutter run -d macos`
  - Windows: `flutter run -d windows`
- **🌐 Web**: `flutter run -d chrome`

## 📖 Como Usar

### Criando uma Nova Tarefa

1. Toque no botão **+** (flutuante) na tela principal
2. Preencha o **nome da tarefa**
3. Selecione a **data e hora** desejada
4. Toque em **"Localização"** para usar sua posição atual (requer permissão de GPS)
5. Toque em **"Salvar"**

### Gerenciando Tarefas Existentes

- **Visualizar**: Toque em qualquer tarefa da lista para ver detalhes
- **Editar**: Na tela de detalhes, toque em "Editar" para modificar
- **Excluir**: Deslize a tarefa para a esquerda ou use o botão de exclusão

### Permissões Necessárias

O aplicativo solicita as seguintes permissões:

- **Localização**: Para associar tarefas a locais específicos
- **Armazenamento**: Para salvar dados temporariamente (atual implementação usa memória)

## 🏗️ Estrutura do Projeto

```
lib/
├── app.dart                    # Configuração principal do app
├── main.dart                   # Ponto de entrada
├── core/                       # Componentes compartilhados
│   ├── services/               # Serviços utilitários
│   │   ├── location_service.dart    # Serviço de localização
│   │   └── brazil_date_format.dart  # Formatação de datas BR
│   └── widgets/                # Widgets reutilizáveis
├── features/                   # Funcionalidades do app
│   └── tasks/                  # Módulo de tarefas
│       ├── data/               # Camada de dados
│       │   ├── task_repository.dart  # Repositório de tarefas
│       │   └── task_storage.dart     # Armazenamento (memória)
│       ├── domain/             # Camada de domínio
│       │   ├── task.dart            # Modelo Task
│       │   └── geo_location.dart    # Modelo GeoLocation
│       └── presentation/       # Camada de apresentação
│           ├── pages/          # Páginas/screens
│           ├── widgets/        # Widgets específicos
│           └── helpers/        # Utilitários de UI
```

### Arquitetura

O projeto segue os princípios da **Clean Architecture**:

- **Domain**: Regras de negócio e modelos de dados
- **Data**: Acesso a dados e repositórios
- **Presentation**: Interface do usuário e controladores

## 🧪 Testes

Execute os testes incluídos:

```bash
flutter test
```

## 📦 Build e Distribuição

### Android APK

```bash
flutter build apk --release
```

### iOS (apenas macOS)

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## 🤝 Contribuição

Contribuições são bem-vindas! Para contribuir:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Melhorias Sugeridas

- [ ] Persistência de dados (SQLite/Hive)
- [ ] Notificações push para lembretes
- [ ] Sincronização com nuvem
- [ ] Temas dark/light
- [ ] Categorias de tarefas
- [ ] Compartilhamento de tarefas

## 📄 Licença

Este projeto é parte de um trabalho acadêmico e não possui licença específica para distribuição comercial. Use para fins educacionais.

## 👨‍💻 Autor

**Breno Leiria Neto** - Desenvolvimento Mobile com Flutter [26E2_2]

---

⭐ Se este projeto foi útil, dê uma estrela no GitHub!

---

_Desenvolvido com ❤️ usando Flutter_
