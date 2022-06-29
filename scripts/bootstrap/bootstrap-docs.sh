# Useful Docs for development.

# DOCS DIR
DOCS_DIR=${XDG_DATA_HOME:-"$HOME/.local/share"}/docs
mkdir -p $DOCS_DIR

wget \
-O "$DOCS_DIR/the-art-of-the-command-line.md" \
https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README.md

git clone https://github.com/eCoupa/awesome-cheatsheets ${DOCS_DIR}/awesome-cheatsheets
git clone https://github.com/typescript-cheatsheets/react ${DOCS_DIR}/react-typescript
git clone https://github.com/typescript-cheatsheets/node ${DOCS_DIR}/node-typescript

# VSCode editor docs
git clone https://github.com/microsoft/vscode-docs

