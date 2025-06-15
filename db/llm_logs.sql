create table if not exists public.llm_logs
(
    interaction_id serial
        primary key,
    prompt         text not null,
    response       text not null,
    response_at    timestamp with time zone default CURRENT_TIMESTAMP,
    model          text,
    round          varchar,
    case_id        varchar
);

alter table public.llm_logs
    owner to lmsuture_user;

