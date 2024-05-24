using {com.dev as my} from '../db/schema';

service CusomerService {
    entity customerSrv as projection on my.Customer;


}
