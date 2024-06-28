using {com.dev as my} from '../db/schema';

// service CatalogService {
//     entity productSrv         as projection on my.materials.Product;
//     entity supplierSrv        as projection on my.sales.Supplier;
//     entity categorySrv        as projection on my.materials.Category;
//     entity stockAvailibitySrv as projection on my.materials.StockAvailibity;
//     entity currenciesSrv      as projection on my.materials.Currencies;
//     entity unitOfMeasuresSrv  as projection on my.materials.UnitOfMeasures;
//     entity dimensionUnitsSrv  as projection on my.materials.DimensionUnits;
//     entity monthsSrv          as projection on my.sales.Months;
//     entity productReviewSrv   as projection on my.materials.ProductReview;
//     entity salesDateSrv       as projection on my.sales.SalesData;
//     entity OrderSrv           as projection on my.sales.Order;
//     entity OrderItemSrv       as projection on my.sales.OrderItem;
// }


define service CatalogService {
    entity Product           as
        select from my.report.Products {
            ID,
            Name                        as ProductName     @mandatory,
            Description                                    @mandatory,
            ReleasedDate,
            DiscontinuedDate,
            Price                                          @mandatory,
            Height,
            Width,
            Depth,
            Quantity,
            UnitOfMeasures              as ToUnitOfMeasure @mandatory,
            Currency                    as ToCurrency      @mandatory,
            Currency.Description        as CurrencyName    @readonly,
            Category                    as ToCategory      @mandatory,
            Category.Name               as CategoryDescription               @readonly,
            StockAvailibity             as ToStockAvailibity,
            StockAvailibity.Description as Stock           @readonly,
            DimensionUnit               as ToDimensionUnit,
            SalesData,
            Supplier,
            Reviews,
            Rating,
        };

    @readonly
    entity Supplier          as
        select from my.sales.Supplier {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct
        };

    entity Reviews           as
        select from my.materials.ProductReview {
            ID,
            Name,
            Comment,
            Raiting,
            Product as ToProduct,

        };

    @readonly
    entity SalesData         as
        select from my.sales.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as CurrencyKey,
            DeliveryMonth.ID          as DeliveryMonthKey,
            DeliveryMonth.Description as DeliveryMonth,
            Product                   as ToProduct,
        };

    @readonly
    entity stockAvailibity   as
        select from my.materials.StockAvailibity {
            ID,
            Description,
            Product as ToProduct,
        };

    @readonly
    entity VH_Categories     as
        select from my.materials.Category {
            ID   as Code,
            Name as Text,
        };

    @readonly
    entity VH_Currencies     as
        select from my.materials.Currencies {
            ID          as Code,
            Description as Text,
        };

    @readonly
    entity VH_UnitOfMeasure  as
        select from my.materials.UnitOfMeasures {
            ID          as Code,
            Description as Text,
        };

    @readonly
    entity VH_DimensionUnits as
        select from my.materials.DimensionUnits {
            ID          as Code,
            Description as Text,
        };
}

define service MyService {
    entity EntityInfix as
        select Supplier[Name = 'Supplier E'].Phone from my.materials.Product
        where
            Product.Name = 'Gamma Device';

    entity EntityJoin  as
        select Phone from my.materials.Product
        inner join my.sales.Supplier as supp
            on(
                supp.ID = Product.Supplier.ID
            )
            and supp.Name = 'Supplier E'

}

define service Reports {
    entity AvarageRating as projection on my.report.AvarageRating;

}

define service Order {
    entity OrderSrv as projection on my.training.Order;

}
