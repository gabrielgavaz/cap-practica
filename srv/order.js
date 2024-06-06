const cds = require("@sap/cds");
const { rejects } = require("assert");
const { resolve } = require("path");
const { Order } = cds.entities("com.dev.training");

module.exports = (srv) => {

    //READ//
    srv.on("READ", "getOrder", async (req) => {

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

    srv.on("CREATE", "createOrder", async (req) => {
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

    srv.before("CREATE", "createOrder", async (req) => {
        req.data.CreatedOn =  new Date().toISOString().slice(0,10);
        return req;  
    })



    
}