import vibe.vibe;
import virus_total;
import db_conn;

import std.stdio;

void main()
{

    auto dbClient = DBConnection("root", "example", "mongo", "27017", "testing");
    auto virusTotalAPI = new VirusTotalAPI(dbClient);

    auto router = new URLRouter;
    router.registerRestInterface(virusTotalAPI);

    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["0.0.0.0"];
    router.get("/", &hello);
    router.get("/login", &login);
    router.get("/url", &url_add);
    auto listener = listenHTTP(settings, router);
    scope (exit)
    {
        listener.stopListening();
    }

    writeln(router.getAllRoutes());
    runApplication();
}

void hello(HTTPServerRequest req, HTTPServerResponse res)
{
    render!("upload_files.dt")(res);
}

void login(HTTPServerRequest req, HTTPServerResponse res)
{
    render!("login.dt")(res);
}

void url_add(HTTPServerRequest req, HTTPServerResponse res)
{
    render!("upload_url.dt")(res);
}