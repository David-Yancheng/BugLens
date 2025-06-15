create table if not exists public.cases
(
    var_name           text,
    analysis_result    varchar,
    case_id            varchar not null,
    sanitize_result    text,
    model              varchar not null,
    required_sanitizer text,
    constraint code_analysis_cases_pkey
        primary key (case_id, model)
);

alter table public.cases
    owner to lmsuture_user;

