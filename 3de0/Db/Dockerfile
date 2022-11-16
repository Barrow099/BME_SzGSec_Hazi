FROM mcr.microsoft.com/mssql/server:2022-latest
EXPOSE 1433

ENV SA_PASSWORD S3cur3P@ssW0rd!
ENV ACCEPT_EULA Y
ENV MSSQL_PID Express



COPY ["/Db/InitScript.sql", "/usr/src"]
COPY ["/Db/import-data.sh", "/usr/src"]
COPY ["/Db/entrypoint.sh", "/usr/src"]

USER root

# Grant permissions for the import-data script to be executable
RUN chmod +x /usr/src/import-data.sh

# Switch back to mssql user and run the entrypoint script
USER mssql
RUN command "/usr/src/entrypoint.sh"
