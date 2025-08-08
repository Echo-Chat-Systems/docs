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
  Create tables
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-- Config
CREATE TABLE config.owners
(
    user_id varchar(64) NOT NULL PRIMARY KEY
);

CREATE TABLE config.data
(
    key   TEXT  NOT NULL PRIMARY KEY,
    value bytea NOT NULL
);

-- Public
CREATE TABLE public.users
(
    id             varchar(64) NOT NULL PRIMARY KEY,
    created_at     TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    encryption_key bytea       NOT NULL,
    username       TEXT        NOT NULL,
    tag            INT         NOT NULL,
    profile        jsonb       NOT NULL DEFAULT '{}',
    settings       text       NOT NULL DEFAULT '{}',
    last_online    TIMESTAMP,
    is_online      BOOLEAN     NOT NULL DEFAULT FALSE,
    is_banned      BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE TABLE public.roles
(
    id            NUMERIC NOT NULL PRIMARY KEY,
    guild_id      NUMERIC NOT NULL,
    name          TEXT    NOT NULL,
    guild_permissions NUMERIC NOT NULL DEFAULT 0,
    text_permissions  NUMERIC NOT NULL DEFAULT 0,
    voice_permissions NUMERIC NOT NULL DEFAULT 0,
    customisation jsonb   NOT NULL DEFAULT '{}'
);

CREATE TABLE public.user_roles
(
    id      NUMERIC     NOT NULL PRIMARY KEY,
    user_id varchar(64) NOT NULL,
    role_id NUMERIC     NOT NULL
);

CREATE TABLE public.invites
(
    id            NUMERIC     NOT NULL PRIMARY KEY,
    guild_id      NUMERIC     NOT NULL,
    channel_id    NUMERIC     NOT NULL,
    created_by    varchar(64) NOT NULL,
    uses          REAL        NOT NULL DEFAULT -1,
    customisation jsonb       NOT NULL DEFAULT '{}',
    expires_at    TIMESTAMP,
    target_user   varchar(64)
);

-- Chat
CREATE TABLE chat.guilds
(
    id            NUMERIC     NOT NULL PRIMARY KEY,
    owner_id      varchar(64) NOT NULL,
    name          TEXT        NOT NULL,
    customisation jsonb       NOT NULL DEFAULT '{}',
    config        jsonb       NOT NULL DEFAULT '{}'
);

CREATE TABLE chat.guild_members
(
    id            NUMERIC     NOT NULL PRIMARY KEY,
    guild_id      NUMERIC     NOT NULL,
    user_id       varchar(64) NOT NULL,
    nickname      TEXT,
    g_customisation_o jsonb       NOT NULL DEFAULT '{}',
    u_customisation_o jsonb       NOT NULL DEFAULT '{}'
);

CREATE TABLE chat.messages
(
    id           NUMERIC     NOT NULL PRIMARY KEY,
    user_id      varchar(64) NOT NULL,
    channel_id   NUMERIC     NOT NULL,
    epoch        NUMERIC, -- Epoch and sender index are optional, as not all messages will be part of a secure channel
    sender_index INT,
    body         bytea       NOT NULL,
    metadata     jsonb       NOT NULL DEFAULT '{}'
);

CREATE TABLE chat.channels
(
    id            NUMERIC  NOT NULL PRIMARY KEY,
    guild_id      NUMERIC  NOT NULL,
    name          TEXT     NOT NULL,
    type          SMALLINT NOT NULL DEFAULT 0,
    customisation jsonb    NOT NULL DEFAULT '{}',
    config        jsonb    NOT NULL DEFAULT '{}'
);

CREATE TABLE chat.channel_categories
(
    id            NUMERIC NOT NULL PRIMARY KEY,
    guild_id      NUMERIC NOT NULL,
    name          TEXT    NOT NULL,
    type          INT     NOT NULL DEFAULT 0,
    customisation jsonb   NOT NULL DEFAULT '{}',
    config        jsonb   NOT NULL DEFAULT '{}'
);

CREATE TABLE chat.channel_members
(
    id          NUMERIC     NOT NULL PRIMARY KEY,
    user_id     varchar(64) NOT NULL,
    channel_id  NUMERIC     NOT NULL,
    permissions NUMERIC     NOT NULL DEFAULT 0
);

-- Media
CREATE TABLE media.files
(
    id            NUMERIC     NOT NULL PRIMARY KEY,
    last_accessed TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by    varchar(64) NOT NULL,
    metadata      jsonb       NOT NULL DEFAULT '{}'
);

CREATE TABLE media.message_attachments
(
    id         NUMERIC NOT NULL PRIMARY KEY,
    message_id NUMERIC NOT NULL,
    file_id    NUMERIC NOT NULL
);

CREATE TABLE media.guild_emojis
(
    id            NUMERIC     NOT NULL PRIMARY KEY,
    guild_id      NUMERIC     NOT NULL,
    created_by    varchar(64) NOT NULL,
    name          TEXT        NOT NULL,
    type          SMALLINT    NOT NULL DEFAULT 0,
    customisation jsonb       NOT NULL DEFAULT '{}',
    file_id       NUMERIC     NOT NULL
);

-- Secured
CREATE TABLE secure.certificates
(
    id        NUMERIC   NOT NULL PRIMARY KEY,
    signature bytea     NOT NULL,
    expires   TIMESTAMP NOT NULL,
    revoked   BOOLEAN   NOT NULL DEFAULT FALSE
);

CREATE TABLE secure.channel_commits
(
    id               NUMERIC     NOT NULL PRIMARY KEY,
    user_id          varchar(64) NOT NULL,
    channel_id       NUMERIC     NOT NULL,
    epoch            NUMERIC     NOT NULL,
    encrypted_commit bytea       NOT NULL
);

CREATE TABLE secure.mls_states
(
    id                NUMERIC   NOT NULL PRIMARY KEY,
    last_updated      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    channel_member_id NUMERIC   NOT NULL,
    nonce             bytea     NOT NULL,
    epoch             NUMERIC   NOT NULL,
    encrypted_state   bytea     NOT NULL
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

ALTER TABLE chat.channel_categories
    ADD CONSTRAINT fk_channel_categories_guild_id FOREIGN KEY (guild_id) REFERENCES chat.guilds (id);

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

ALTER TABLE media.guild_emojis
    ADD CONSTRAINT fk_guild_emojis_guild_id FOREIGN KEY (guild_id) REFERENCES chat.guilds (id);
ALTER TABLE media.guild_emojis
    ADD CONSTRAINT fk_guild_emojis_created_by FOREIGN KEY (created_by) REFERENCES public.users (id);
ALTER TABLE media.guild_emojis
    ADD CONSTRAINT fk_guild_emojis_file_id FOREIGN KEY (file_id) REFERENCES media.files (id);

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
    ADD CONSTRAINT fk_invites_created_by FOREIGN KEY (created_by) REFERENCES public.users (id);
ALTER TABLE public.invites
    ADD CONSTRAINT fk_invites_target_user FOREIGN KEY (target_user) REFERENCES public.users (id);

-- Secured
ALTER TABLE secure.channel_commits
    ADD CONSTRAINT fk_channel_commits_user_id FOREIGN KEY (user_id) REFERENCES public.users (id);
ALTER TABLE secure.channel_commits
    ADD CONSTRAINT fk_channel_commits_channel_id FOREIGN KEY (channel_id) REFERENCES chat.channels (id);

ALTER TABLE secure.mls_states
    ADD CONSTRAINT fk_mls_states_channel_member_id FOREIGN KEY (channel_member_id) REFERENCES chat.channel_members (id);

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Indexes
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-- TODO: Do indexes

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Views
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-- Message Count View
CREATE OR REPLACE VIEW chat.message_count AS
SELECT user_id,
       channel_id,
       COUNT(*) AS message_count
FROM chat.messages
GROUP BY user_id, channel_id;
