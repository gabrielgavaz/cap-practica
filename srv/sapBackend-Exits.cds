using { sapBackend as external } from './external/sapBackend';


define service sapBackendExit {
    @cds.persistence : {
        table,
        skip: false
    }
    @cds.autoexpose
    entity Incidents as projection on external.IncidentsSet;

}

@protocol: 'rest'
service RestService {

    entity Incidents as projection on sapBackendExit.Incidents;

}

@graphql
service test{}