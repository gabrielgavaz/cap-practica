namespace com.dev;

using {
    cuid,
    managed
} from '@sap/cds/common';


entity Product : managed, cuid {
    Name             : localized String not null;
    Description      : localized String;
    ReleasedDate     : DateTime;
    DiscontinuedDate : DateTime;
    Price            : Decimal(16, 2);
    Height           : Decimal(16, 2);
    Weight           : Decimal(16, 2);
    Depth            : Decimal(16, 2);
    Quantity         : Decimal(16, 2);
    Supplier         : Association to Supplier;
    UnitOfMeasures   : Association to one UnitOfMeasures;
    Currency         : Association to Currencies;
    DimensionUnit    : Association to DimensionUnits;
    Category         : Association to Category;
    SalesData        : Association to many SalesData
                           on SalesData.Product = $self;
    Reviews          : Association to many ProductReview
                           on Reviews.Product = $self;
}

entity Order : cuid, managed {
    // key ID       : UUID;
    Date     : DateTime;
    Customer : String;
    Item     : Composition of many OrderItem
                   on Item.Order = $self;

}

entity OrderItem : cuid, managed {
    // key ID       : UUID;
    Order    : Association to Order;
    Product  : Association to Product;
    Quantity : Integer;
}

entity Supplier : cuid, managed {
    // key ID         : UUID;
    Name       : String;
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
    Email      : String;
    Phone      : String;
    Fax        : String;
    Product    : Association to many Product
                     on Product.Supplier = $self;

}

entity Category : managed {
    key ID   : String(1);
        Name : localized String;
}

entity StockAvailibity : managed {
    key ID          : Integer;
        Description : String;
        Product     : Association to Product;
}

entity Currencies  {
    key ID          : String(3);
        Description : localized String;
}

entity UnitOfMeasures : managed {
    key ID          : String(2);
        Description : localized String;
}

entity DimensionUnits : managed {
    key ID          : String(2);
        Description : localized String;
}

entity Months : managed {
    key ID               : String(2);
        Description      : localized String;
        ShortDescription : localized String(2);
}

entity ProductReview : cuid, managed {
    // key ID      : UUID;
    Name    : String;
    Raiting : Integer;
    Comment : String;
    Product : Association to Product;
}

entity SalesData : cuid, managed {
    // key ID            : UUID;
    DeliveryDate  : DateTime;
    Revenue       : Decimal(16, 2);
    Product       : Association to Product;
    Currency      : Association to Currencies;
    DeliveryMonth : Association to Months;
}
