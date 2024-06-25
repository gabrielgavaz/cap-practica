const cds = require("@sap/cds");
const { rejects } = require("assert");
const { resolve } = require("path");
const { Order } = cds.entities("com.dev.training");

module.exports = (srv) => {

    //se ejecuta antes de culquier funcion/crud/action
    srv.before("*", (req)=>{
        console.log(`method: ${req.method}`)
        console.log(`target: ${req.target}` )
    });

    //READ//
    srv.on("READ", "Order", async (req) => {

        if (req.data.ClientEmail !== undefined) {
            return await SELECT.from`com.dev.training.Order`
                .where`ClientEmail = ${req.data.ClientEmail}`;
        }
        return await SELECT.from(Order)
    });

    srv.after("READ", "getOrder", async (data) => {

        const newData = data.map(x => { x.Reviewed = true })
        return newData;

    });


    //CREATE//

    srv.on("CREATE", "Order", async (req) => {
        let returnData = await cds.transaction(req)
            .run(
                INSERT.into(Order).entries({
                    ClientEmail: req.data.ClientEmail,
                    FirstName: req.data.FirstName,
                    LastName: req.data.LastName,
                    CreatedOn: req.data.CreatedOn,
                    Reviewed: req.data.Reviewed,
                    Approved: req.data.Approved
                })
            )
            .then((resolve, rejects) => {
                console.log("resolve", resolve);
                console.log("rejects", rejects);


                if (typeof resolve !== "undefined") {
                    return req.data;
                } else {
                    req.error(409, "Record not Inserted")
                };
            })

            .catch((error) => {
                console.log(error);
                req.error(error.code, err.message)
            })
        console.log("before data", returnData)
        return returnData;
    })

    srv.before("CREATE", "Order", async (req) => {
        req.data.CreatedOn = new Date().toISOString().slice(0, 10);
        return req;
    })



    //Update//
    srv.on("UPDATE", "Order", async (req) => {
        let returnData = await cds.transaction(req)
            .run(
                [
                    UPDATE(Order, req.data.ClientEmail).set({
                        FirstName: req.data.FirstName,
                        LastName: req.data.LastName,
                    })
                ]
            )
            .then((resolve, rejects) => {
                console.log("resolve: " + resolve);
                console.log("error : " + rejects);

                if (resolve[0] == 0) {
                    req.error(409, "Record not found")
                }
            })
            .catch((err) => {
                console.log(err);
                req.error(err.code, err.message)
            })
        console.log("before end: " + returnData)
        return returnData;
    })


    //delete//
    srv.on("DELETE", "Order", async (req) => {
        let returnData = await cds.transaction(req)
            .run(
                DELETE(Order).where({
                    ClientEmail: req.data.ClientEmail
                })
            )
            .then((resolve, rejects) => {
                console.log("r" + resolve);
                console.log("re" + rejects);

                if (resolve !== 1) {
                    req.error(409, "record not found")
                }
            })
            .catch((err) => {
                console.log(err);
                req.reject(err.code, err.message)
            })
        console.log("before end", returnData)
        return await returnData;
    });


    //funciones
    srv.on("getClientTaxRate", async (req) => {
        //No server side-effect
        const { ClientEmail } = req.data;
        const db = srv.transaction(req);
        const results = await db.read(Order, ["Country_code"])
            .where({ ClientEmail: ClientEmail });

        console.log(results[0])
        switch (results[0].Country_code) {
            case "ES":
                return 21.5;
                break;
            case "UK":
                return 24.6;
                break;

            default:
                break;
        }
    });


    //ACCIONES
    srv.on("cancelOrder", async (req) => {
        const { ClientEmail } = req.data;
        const db = srv.transaction(req);

        const resultsRead = await db.read(Order, ["FirstName", "LastName", "Approved"])
            .where({ ClientEmail: ClientEmail });

        let returnOrder = {
            status: "",
            message: "",
        };

        console.log(ClientEmail, resultsRead)
        if (resultsRead[0].Approved == false) {
            const resultsUpdate = await db.update(Order)
                                            .set({ Status: "C" })
                                            .where({ ClientEmail: ClientEmail })
            returnOrder.status="Success";
            returnOrder.message=`The order placed by ${resultsRead[0].FirstName} ${resultsRead[0].LastName} was cancel`
        } else {
            returnOrder.status="Failed";
            returnOrder.message=`The order placed by ${resultsRead[0].FirstName} ${resultsRead[0].LastName} was NOT cancel. it has been aproveed`
        }

        console.log("Action cancel order executed");
        return returnOrder;
    })

//APIO, PEPINO, ACELGA, JENGIBRE, MANZANA VERDE, LIMON,
}