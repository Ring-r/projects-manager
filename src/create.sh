#!/usr/bin/env sh

set -eu
set -o | grep -q pipefail && set -o pipefail


create() {
    PROJECTS_DIR=~/src

    echo "[1] shell-tool "
    echo "[2] python-tool"
    echo "[3] python-app"
    echo "[4] django-app"
    echo "[5] fastapi-app"
    read -p "project type: " PROJECT_TYPE_INDEX

    echo ""

    read -p "project name: " PROJECT_NAME
    PROJECT_DIR="$PROJECTS_DIR/$PROJECT_NAME"


    case "$PROJECT_TYPE_INDEX" in
        "1" )
            create_shell_tool
            ;;
        "2" )
            create_python_tool
            ;;
        "3" )
            create_python_app
            ;;
        "4" )
            create_django_app
            ;;
        "5" )
            create_fastapi_app
            ;;
        * )
            echo "'$PROJECT_TYPE_INDEX' is not recognized."
            ;;
    esac

    echo ""
    echo "done"
}

_create_base() {
    mkdir "$PROJECT_DIR"
    touch "$PROJECT_DIR/README.md"
}

_add_shell_templates() {
    cat >> "$PROJECT_DIR/script.sh" <<EOT
#!/usr/bin/env sh

set -eux
set -o | grep -q pipefail && set -o pipefail
EOT
}

create_shell_tool() {
    _create_base
    _add_shell_templates
}

_add_python_templates() {
    cat >> "$PROJECT_DIR/app.py" <<EOT
def _main() -> None:
    ...

if __name__ == '__main__':
    _main()
EOT
}

create_python_tool() {
    _create_base
    _add_python_templates
}

_add_poetry_templates() {
    cat >> "$PROJECT_DIR/poetry.toml" <<EOT
[virtualenvs]
create = true
in-project = true
path = ".venv"
EOT
}

_create_python_base() {
    _create_base
    _add_poetry_templates

    PREV_DIR=$( pwd )
    cd "$PROJECT_DIR"

    poetry init
    poetry add --group=dev flake8 mypy ruff

    cd "$PREV_DIR"
}

create_python_app() {
    _create_python_base
    _add_python_templates
}

create_django_app() {
    _create_python_base

    PREV_DIR=$( pwd )
    cd "$PROJECT_DIR"

    poetry add django djangorestframework drf-spectacular
    poetry run django-admin startproject base "$PROJECT_DIR"

    # TODO: implement
    # TODO: add settings to `./src/base/settings.py`
    # TODO: replace `./src/base/urls.py`

    poetry run ./manage.py migrate
    poetry run ./manage.py createsuperuser --username admin

    cd "$PREV_DIR"
}

_add_fastapi_templates() {
    mkdir -p "$PROJECT_DIR/src/"
    cat >> "$PROJECT_DIR/src/main.py" <<EOT
from fastapi import FastAPI

app = FastAPI()


@app.get('/ping')
async def ping() -> str:
    return 'pong'
EOT
}

create_fastapi_app() {
    _create_python_base

    PREV_DIR=$( pwd )
    cd "$PROJECT_DIR"

    poetry add fastapi uvicorn[standard]

    cd "$PREV_DIR"

    _add_fastapi_templates
}

create
