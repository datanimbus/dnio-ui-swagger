FROM data.stack.proxy:2.7.0_2023.07.19.07.37

COPY * /app/swaggerUI/

EXPOSE 32001

ENTRYPOINT ["./goroute","-config","goroute.json","-env","goroute-env.json"]
