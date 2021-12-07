package de.adesso;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.eclipse.microprofile.config.ConfigProvider;

@Path("/json")
public class JsonResource {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String json() {
        return "{\"message\":\""+ ConfigProvider.getConfig().getValue("greeting.message", String.class) +"\"}";
    }
}