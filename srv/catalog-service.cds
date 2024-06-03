using {com.dev as my} from '../db/schema';

service CatalogService {
    entity productSrv         as projection on my.Product;
    entity supplierSrv        as projection on my.Supplier;
    entity categorySrv        as projection on my.Category;
    entity stockAvailibitySrv as projection on my.StockAvailibity;
    entity currenciesSrv      as projection on my.Currencies;
    entity unitOfMeasuresSrv  as projection on my.UnitOfMeasures;
    entity dimensionUnitsSrv  as projection on my.DimensionUnits;
    entity monthsSrv          as projection on my.Months;
    entity productReviewSrv   as projection on my.ProductReview;
    entity salesDateSrv       as projection on my.SalesData;
    entity OrderSrv           as projection on my.Order;
    entity OrderItemSrv       as projection on my.OrderItem;
}
