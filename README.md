# BugLens

BugLens is a tool that uses LLMs to refine static analysis results. It focus on "taint-style" bugs. Experiments on Linux kernel code show that it can improve the precision by 7x and can also help with recall (for those bugs that are ignored by human reviewers).

The paper is available at https://arxiv.org/abs/2504.11711

# Quick Start

Based on docker (TODO: add docker image)


## Source Code

The source code is available at [BugLens-Code](https://github.com/seclab-ucr/BugLens-Code)

## Requirements

### Database 

BugLens relies on postgres database to store the results (cases), and also logging the interactions with the LLMs (llm-logs)

![Table Cases](figs/cases.png)

![Table LLM Logs](figs/llm-logs.png)

Their schema is defined in the `db` folder. You can use the `cases.sql` and `llm_logs` to create the database.

### Configuration

The configuration file is in `config.py` (`common/config.py`), by default, there are two main settings: `proj_config` and `db_config`:

For example, the `proj_config` is defined as follows:

```python
PROJ_CONFIG = { 
    "msm-sound":{
        "proj_dir": __MSM_DIR,
        "cmd_file": "all_sound.cmd",
    },
    "codeql/ioctl-to-cfu": {
        "proj_dir": "../msm-4.4-revision-2017-May-07--08-33-56/src/home/kev/work/QualComm/semmle_data/projects/msm-4.4/revision-2017-May-07--08-33-56/kernel",
        "sarif_file": "results.sarif",
    },
}
```

The "proj_dir" is the directory of the source code to be analyzed, "cmd_file" is the command file that contains the **results** of the static analysis tool (weird to call "cmd", but that's what Suture does). The "sarif_file" is the output file of the static analysis tool (for CodeQL, obviously).


And the `db_config` is defined as follows, indicating the database connection information:

```

DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "dbname": "lmsuture",
    "user": "lmsuture_user",
    "password": "password1",
}

```
