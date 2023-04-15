
 

# Rails-Search-Engine

A Ruby on Rails application for searching articles and indexing and providing statistics of these searches and theirs results.

The app aims performance and organization, so the searches are asynchronously indexed in background.

## Features

- Article CRUD.
- Article search by title.
- Background statistics generation 

## Installing and running

Clone the project:

```bash
git clone git@github.com:souuja-ops/search_engine.git
cd search_engine
```


Update the gems:

```bash
bundle install
```

Run migrations (PostgreSQL):

```bash
# Your PostgreSQL database must exist
rails db:create
rails db:migrate
```

## Search indexing logic

Every search that hits the server is stored on a queue for processing. It does not matter if it is a complete or a parcial search.

So, imagine user typing:

```
1. Ho
2. How do
3. How do I canc
4. How do I cancel my acc
5. How do I cancel my subscription
```

At first, all these five terms are stored for the user's IP address.

But we only want keep final search terms. If we consider the example above, it would be: *How do I cancel my subscription*.

Every minute (it can be less frequent if necessary) a background cron job consumes the search queue and tries to extract the best search terms, aiming at only get final search terms. Its result is stores in DB for future visualization.

### Rule

A Search is considered as a final search and is stored in DB for statistics generation if:

- The user makes only one search.
- The user presses ENTER (or clicks the submit button).
- There are move than one search and the next search for the same user are separated by more than 3 seconds (empirically discovered).