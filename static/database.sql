/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Create schemas
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
CREATE SCHEMA IF NOT EXISTS chat;
CREATE SCHEMA IF NOT EXISTS config;
CREATE SCHEMA IF NOT EXISTS hooks;
CREATE SCHEMA IF NOT EXISTS media;
CREATE SCHEMA IF NOT EXISTS public;
CREATE SCHEMA IF NOT EXISTS secure;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Create types & domains
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

CREATE DOMAIN snowflake AS BIGINT;
CREATE DOMAIN uid AS VARCHAR(64);

CREATE DOMAIN rich_media_type AS SMALLINT CHECK ( 0 <= value AND value <= 1 );
CREATE DOMAIN hook_stage AS SMALLINT CHECK ( 0 <= value AND value <= 1 );
CREATE DOMAIN hook_status AS SMALLINT CHECK ( 0 <= value AND value <= 1 );

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Create tables
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-- Config
CREATE TABLE config.owners
(
    user_id uid NOT NULL PRIMARY KEY
);

CREATE TABLE config.data
(
    key   TEXT  NOT NULL PRIMARY KEY,
    value bytea NOT NULL
);

-- Public
CREATE TABLE public.users
(
    id             uid       NOT NULL PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    encryption_key bytea     NOT NULL,
    username       TEXT      NOT NULL,
    tag            INT       NOT NULL,
    profile        jsonb     NOT NULL,
    settings       TEXT      NOT NULL,
    last_online    TIMESTAMP,
    is_online      BOOLEAN   NOT NULL DEFAULT FALSE,
    is_banned      BOOLEAN   NOT NULL DEFAULT FALSE
);

CREATE TABLE public.roles
(
    id                snowflake NOT NULL PRIMARY KEY,
    guild_id          snowflake NOT NULL,
    name              TEXT      NOT NULL,
    guild_permissions BIGINT    NOT NULL DEFAULT 0,
    text_permissions  BIGINT    NOT NULL DEFAULT 0,
    voice_permissions BIGINT    NOT NULL DEFAULT 0,
    customisation     jsonb     NOT NULL
);

CREATE TABLE public.user_roles
(
    id      snowflake NOT NULL PRIMARY KEY,
    user_id uid       NOT NULL,
    role_id snowflake NOT NULL
);

CREATE TABLE public.invites
(
    id            snowflake NOT NULL PRIMARY KEY,
    guild_id      snowflake NOT NULL,
    channel_id    snowflake NOT NULL,
    attribution   uid,
    uses          REAL,
    customisation jsonb     NOT NULL,
    expires       TIMESTAMP,
    target        uid
);

-- Chat
CREATE TABLE chat.guilds
(
    id            snowflake NOT NULL PRIMARY KEY,
    owner_id      uid       NOT NULL,
    name          TEXT      NOT NULL,
    customisation jsonb     NOT NULL,
    config        jsonb     NOT NULL
);

CREATE TABLE chat.guild_members
(
    id                snowflake NOT NULL PRIMARY KEY,
    guild_id          snowflake NOT NULL,
    user_id           uid       NOT NULL,
    nickname          TEXT,
    g_customisation_o jsonb     NOT NULL,
    u_customisation_o jsonb     NOT NULL
);

CREATE TABLE chat.messages
(
    id           snowflake NOT NULL PRIMARY KEY,
    user_id      uid       NOT NULL,
    channel_id   snowflake NOT NULL,
    epoch        BIGINT, -- Epoch and sender index are optional, as not all messages will be part of a secure channel
    sender_index INT,
    body         bytea     NOT NULL,
    metadata     jsonb     NOT NULL
);

CREATE TABLE chat.channels
(
    id            snowflake NOT NULL PRIMARY KEY,
    guild_id      snowflake NOT NULL,
    name          TEXT      NOT NULL,
    parent        snowflake,
    index         INT       NOT NULL,
    customisation jsonb     NOT NULL,
    config        jsonb     NOT NULL
);

CREATE TABLE chat.channel_members
(
    id          snowflake NOT NULL PRIMARY KEY,
    user_id     uid       NOT NULL,
    channel_id  snowflake NOT NULL,
    permissions BIGINT    NOT NULL DEFAULT 0
);

-- Media
CREATE TABLE media.files
(
    id            snowflake NOT NULL PRIMARY KEY,
    last_accessed TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by    uid       NOT NULL
);

CREATE TABLE media.message_attachments
(
    id         snowflake NOT NULL PRIMARY KEY,
    message_id snowflake NOT NULL,
    file_id    snowflake NOT NULL,
    index      INT       NOT NULL DEFAULT 0
);

CREATE TABLE media.rich_media
(
    id            snowflake       NOT NULL PRIMARY KEY,
    guild_id      snowflake,
    name          TEXT            NOT NULL,
    type          rich_media_type NOT NULL DEFAULT 0,
    customisation jsonb           NOT NULL,
    file_id       snowflake       NOT NULL
);

-- Secured
CREATE TABLE secure.certificates
(
    id        snowflake NOT NULL PRIMARY KEY,
    signature bytea     NOT NULL,
    expires   TIMESTAMP NOT NULL,
    revoked   BOOLEAN   NOT NULL DEFAULT FALSE
);

CREATE TABLE secure.channel_commits
(
    id               snowflake NOT NULL PRIMARY KEY,
    user_id          uid       NOT NULL,
    channel_id       snowflake NOT NULL,
    epoch            BIGINT    NOT NULL,
    encrypted_commit bytea     NOT NULL
);

CREATE TABLE secure.mls_states
(
    id                snowflake NOT NULL PRIMARY KEY,
    last_updated      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    channel_member_id snowflake NOT NULL,
    nonce             bytea     NOT NULL,
    epoch             BIGINT    NOT NULL,
    encrypted_state   bytea     NOT NULL
);

-- Hooks

CREATE TABLE hooks.hooks
(
    id      snowflake  NOT NULL PRIMARY KEY,
    name    TEXT       NOT NULL,
    source  TEXT       NOT NULL,
    stage   hook_stage NOT NULL,
    context jsonb      NOT NULL,
    enabled bool       NOT NULL DEFAULT FALSE
);

CREATE TABLE hooks.hook_users
(
    id       snowflake NOT NULL PRIMARY KEY,
    hook_id  snowflake NOT NULL,
    user_id  uid       NOT NULL,
    approved bool      NOT NULL
);

CREATE TABLE hooks.history
(
    id            snowflake NOT NULL PRIMARY KEY,
    hook_id       snowflake NOT NULL,
    manifest_hash TEXT      NOT NULL,
    manifest      jsonb     NOT NULL,
    code_hash     TEXT      NOT NULL,
    code          TEXT      NOT NULL,
    valid         bool DEFAULT FALSE
);

CREATE TABLE hooks.runs
(
    id           snowflake NOT NULL PRIMARY KEY,
    history_id   snowflake NOT NULL,
    hook_user_id snowflake NOT NULL,
    result       SMALLINT  NOT NULL DEFAULT 0,
    output       jsonb     NOT NULL,
    log          TEXT      NOT NULL DEFAULT ''
);

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Create foreign keys
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-- Chat
ALTER TABLE chat.guilds
    ADD CONSTRAINT fk_guilds_owner_id FOREIGN KEY (owner_id) REFERENCES public.users (id);

ALTER TABLE chat.guild_members
    ADD CONSTRAINT fk_guild_members_guild_id FOREIGN KEY (guild_id) REFERENCES chat.guilds (id);
ALTER TABLE chat.guild_members
    ADD CONSTRAINT fk_guild_members_user_id FOREIGN KEY (user_id) REFERENCES public.users (id);

ALTER TABLE chat.channels
    ADD CONSTRAINT fk_channels_guild_id FOREIGN KEY (guild_id) REFERENCES chat.guilds (id);

ALTER TABLE chat.channel_members
    ADD CONSTRAINT fk_channel_members_user_id FOREIGN KEY (user_id) REFERENCES public.users (id);
ALTER TABLE chat.channel_members
    ADD CONSTRAINT fk_channel_members_channel_id FOREIGN KEY (channel_id) REFERENCES chat.channels (id);

ALTER TABLE chat.messages
    ADD CONSTRAINT fk_messages_user_id FOREIGN KEY (user_id) REFERENCES public.users (id);
ALTER TABLE chat.messages
    ADD CONSTRAINT fk_messages_channel_id FOREIGN KEY (channel_id) REFERENCES chat.channels (id);

-- Config
ALTER TABLE config.owners
    ADD CONSTRAINT fk_owners_user FOREIGN KEY (user_id) REFERENCES public.users (id);

-- Media
ALTER TABLE media.files
    ADD CONSTRAINT fk_files_created_by FOREIGN KEY (created_by) REFERENCES public.users (id);

ALTER TABLE media.message_attachments
    ADD CONSTRAINT fk_message_attachments_message_id FOREIGN KEY (message_id) REFERENCES chat.messages (id);
ALTER TABLE media.message_attachments
    ADD CONSTRAINT fk_message_attachments_file_id FOREIGN KEY (file_id) REFERENCES media.files (id);

ALTER TABLE media.rich_media
    ADD CONSTRAINT fk_rich_media_guild_id FOREIGN KEY (guild_id) REFERENCES chat.guilds (id);
ALTER TABLE media.rich_media
    ADD CONSTRAINT fk_rich_media_file_id FOREIGN KEY (file_id) REFERENCES media.files (id);

-- Public
ALTER TABLE public.roles
    ADD CONSTRAINT fk_roles_guild_id FOREIGN KEY (guild_id) REFERENCES chat.guilds (id);

ALTER TABLE public.user_roles
    ADD CONSTRAINT fk_user_roles_user_id FOREIGN KEY (user_id) REFERENCES public.users (id);
ALTER TABLE public.user_roles
    ADD CONSTRAINT fk_user_roles_role_id FOREIGN KEY (role_id) REFERENCES public.roles (id);

ALTER TABLE public.invites
    ADD CONSTRAINT fk_invites_guild_id FOREIGN KEY (guild_id) REFERENCES chat.guilds (id);
ALTER TABLE public.invites
    ADD CONSTRAINT fk_invites_channel_id FOREIGN KEY (channel_id) REFERENCES chat.channels (id);
ALTER TABLE public.invites
    ADD CONSTRAINT fk_invites_created_by FOREIGN KEY (attribution) REFERENCES public.users (id);
ALTER TABLE public.invites
    ADD CONSTRAINT fk_invites_target_user FOREIGN KEY (target) REFERENCES public.users (id);

-- Secured
ALTER TABLE secure.channel_commits
    ADD CONSTRAINT fk_channel_commits_user_id FOREIGN KEY (user_id) REFERENCES public.users (id);
ALTER TABLE secure.channel_commits
    ADD CONSTRAINT fk_channel_commits_channel_id FOREIGN KEY (channel_id) REFERENCES chat.channels (id);

ALTER TABLE secure.mls_states
    ADD CONSTRAINT fk_mls_states_channel_member_id FOREIGN KEY (channel_member_id) REFERENCES chat.channel_members (id);

-- Hooks
ALTER TABLE hooks.hook_users
    ADD CONSTRAINT fk_hook_users_user_id FOREIGN KEY (user_id) REFERENCES public.users (id);
ALTER TABLE hooks.hook_users
    ADD CONSTRAINT fk_hook_users_hook_id FOREIGN KEY (hook_id) REFERENCES hooks.hooks (id);

ALTER TABLE hooks.history
    ADD CONSTRAINT fk_history_hook_id FOREIGN KEY (hook_id) REFERENCES hooks.hooks (id);

ALTER TABLE hooks.runs
    ADD CONSTRAINT fk_runs_hook_user_id FOREIGN KEY (hook_user_id) REFERENCES hooks.hook_users (id);
ALTER TABLE hooks.runs
    ADD CONSTRAINT fk_runs_history_id FOREIGN KEY (history_id) REFERENCES hooks.history (id);


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Indexes
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-- TODO: Do indexes

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Views
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-- Message Count View
    create OR REPLACE VIEW chat.message_count AS
SELECT user_id,
       channel_id,
       COUNT(*) AS message_count
FROM chat.messages
GROUP BY user_id, channel_id;
