const cds = require("@sap/cds");
const { query } = require("express");

// module.exports = cds.service.impl(async function (srv) {
//     const { Incidents } = srv.entities;
//     const sapBackend = await cds.connect.to("sapBackend");
//     srv.on("READ", Incidents, async (req) => {
//         console.log("read");
//         console.log(srv);
//         return await sapBackend.tx(req).send({
//             query: req.query,
//             headers: {
//                 Authorization: "Basic c2FwdWk1OnNhcHVpNQ=="
//             }
//         })
//     })
// })

module.exports = async (srv) => {
    const sapBackend = await cds.connect.to("sapBackend");
    const { Incidents } = srv.entities;


    srv.on(["READ"], Incidents, async (req) => {
        let incidentsQuery = SELECT.from(req.query.SELECT.from).limit(req.query.SELECT.limit);

        console.log("1" + incidentsQuery)
        console.log("2" + req.query.SELECT.from)
        console.log("3" + req.query)
        console.log("4" + req)
        if (req.query.SELECT.where) {
            incidentsQuery.where(req.query.SELECT.where)
        }
        if (req.query.SELECT.orderBy) {
            incidentsQuery.orderBy(req.query.SELECT.orderBy)
        }

        let incident = await sapBackend.tx(req).send({
            query: incidentsQuery,
            headers: {
                Authorization: `${process.env.SAP_GATEWAY_AUTH}`
            }
        })

        let incidents = [];
        if(Array.isArray(incident)){
            incidents = incident;
        }else{
            incidents[0] = incident;
        }

        return incidents;
    })
}