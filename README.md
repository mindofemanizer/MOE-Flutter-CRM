# MOE-Flutter-CRM

CRM package for MOE Flutter ecosystem — customer management, interactions.

## Installation

```yaml
dependencies:
  moe_flutter_crm:
    git:
      url: https://github.com/mindofemanizer/MOE-Flutter-CRM.git
      ref: main
```

## Usage

### Setup

```dart
import 'package:moe_flutter_foundation/moe_flutter_foundation.dart';
import 'package:moe_flutter_crm/moe_flutter_crm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  await MoeFoundation.setup(
    envConfig: EnvConfig.fromEnvironment(),
    sharedPreferences: prefs,
  );

  MoeCrm.setup(
    config: MoeCrmConfig(
      apiUrl: 'https://api.kioskit.com/api/crm',
      enableLeadScoring: true,
    ),
  );

  runApp(MoeFoundationProviderScope(child: MyApp()));
}
```

### List Contacts

```dart
final state = ref.watch(contactsProvider.notifier);

await ref.read(contactsProvider.notifier).loadContacts(
  segment: CustomerSegment.business, // Filter by business customers only
);

switch (state) {
  case ContactsLoaded(:final contacts):
    ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (ctx, i) => Card(
        child: ListTile(
          title: Text(contacts[i].fullName),
          subtitle: Text(contacts[i].email),
          trailing: Chip(
            label: Text(contacts[i].segment.displayName),
          ),
          isThreeLine: true,
          subtitle2: Text(contacts[i].company ?? ''),
          trailingChipCount: contacts[i].leadScore > 0 
              ? Text('${contacts[i].leadScore}', style: TextStyle(color: Colors.green))
              : null,
        ),
      ),
    );
    
    // Record interaction (sales follow-up)
    final interaction = await ref.read(crmRepositoryProvider).createInteraction(
      contactId: contacts[i].id,
      type: 'call',
      subject: 'Follow up on order inquiry',
      notes: 'Customer interested in bulk discount',
    );
}
```

### Create New Contact

```dart
final result = await ref.read(contactsProvider.notifier).createContact(
  firstName: 'Budi',
  lastName: 'Santoso',
  email: 'budi@example.com',
  phone: '081234567890',
  segment: CustomerSegment.business,
  company: 'PT Toko Maju',
  jobTitle: 'Purchasing Manager',
  leadScore: 75, // High priority lead
  notes: 'Interested in wholesale pricing',
);

if (result is Ok) {
  print('Contact created: ${result.data.fullName}');
}
```

### Get Contact Details

```dart
final contactResult = await ref
  .read(crmRepositoryProvider)
  .getContact('contact_123');

if (contactResult is Ok) {
  final contact = contactResult.data;
  
  // View full interaction history
  final interactions = await ref
    .read(crmRepositoryProvider)
    .listInteractions(contact.id);
}
```

## What's Included

| Module | Description |
|--------|-------------|
| `ContactModel` | Customer contact record with segment & lead score |
| `InteractionModel` | Call/Email/Meeting/WhatsApp history |
| `CustomerSegment` | Individual vs Business classification |
| `InteractionType` | Communication channel types |
| `CrmRepository` | CRUD operations, interaction logging |
| `ContactsNotifier` | Search/filter contacts, auto-update UI |

## Use Cases

**E-commerce:**
- Track high-value B2B buyers
- Record sales calls and follow-ups
- Segment customers by purchase behavior

**Service Business:**
- Manage client relationships
- Schedule meetings and reminders
- Log service interactions

**Sales Team:**
- Lead scoring for prioritization
- Contact pipeline management
- Activity history tracking
