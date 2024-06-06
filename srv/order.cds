using {com.dev.training as t} from '../db/schema';

service ManagedOrder {
    entity getOrder    as projection on t.Order;
    entity createOrder as projection on t.Order;


}
