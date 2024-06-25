using {com.dev.training as t} from '../db/schema';

service ManagedOrder {
    type cancelOrderReturn {
        status  : String enum {
            Success;
            Failed
        };
        message : String;
    };


    entity Order as projection on t.Order actions {
            function getClientTaxRate(ClientEmail : String(65)) returns Decimal(16, 2);
            action   cancelOrder(ClientEmail : String(65))      returns cancelOrderReturn;
        }

}
