# docker compose up --build


git add .
git commit -m "docs: publicar MkDocs"
git push -u origin main


Ingresar a la consola de docker del proyecto y correr esto 

mkdocs gh-deploy --force

