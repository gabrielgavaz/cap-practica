namespace com.dev;

using {
    cuid,
    managed,
    Country
} from '@sap/cds/common';

context materials {

    entity Product : managed, cuid {
        Name             : localized String not null;
        Description      : localized String;
        ReleasedDate     : DateTime;
        DiscontinuedDate : DateTime;
        Price            : Decimal(16, 2);
        Height           : Decimal(16, 2);
        Width            : Decimal(16, 2);
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
        Supplier         : Association to sales.Supplier;
        UnitOfMeasures   : Association to one UnitOfMeasures;
        Currency         : Association to Currencies;
        DimensionUnit    : Association to DimensionUnits;
        Category         : Association to Category;
        SalesData        : Association to many sales.SalesData
                               on SalesData.Product = $self;
        Reviews          : Association to many ProductReview
                               on Reviews.Product = $self;
        AvgReview        : Decimal(16, 2)

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

    entity Currencies {
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

    entity ProductReview : cuid, managed {
        Name    : String;
        Raiting : Integer;
        Comment : String;
        Product : Association to Product;
    }

}

context sales {
    entity Order : cuid, managed {
        Date     : DateTime;
        Customer : String;
        Items    : Composition of many OrderItem
                       on Items.Order = $self;

    }

    entity OrderItem : cuid, managed {
        Order    : Association to Order;
        Product  : Association to materials.Product;
        Quantity : Integer;
    }

    entity Supplier : cuid, managed {
        Name       : String;
        Street     : String;
        City       : String;
        State      : String(2);
        PostalCode : String(5);
        Country    : String(3);
        Email      : String;
        Phone      : String;
        Fax        : String;
        Product    : Association to many materials.Product
                         on Product.Supplier = $self;

    }

    entity Months : managed {
        key ID               : String(2);
            Description      : localized String;
            ShortDescription : localized String(2);
    }

    entity SalesData : cuid, managed {
        DeliveryDate  : DateTime;
        Revenue       : Decimal(16, 2);
        Product       : Association to materials.Product;
        Currency      : Association to materials.Currencies;
        DeliveryMonth : Association to Months;
    }
}

context report {
    entity AvarageRating as
        select from materials.ProductReview {
            Product.ID   as productId,
            avg(Raiting) as AverageRating : Decimal(16, 2)
        }
        group by
            Product.ID;


    entity Products      as
        select from materials.Product
        mixin {
            ToAverageRating : Association to AvarageRating on ToAverageRating.productId = ID;
        }
        into {
            *,
            ToAverageRating.AverageRating as Rating,
        }

}


context training {
    entity Order  {
        key ClientEmail: String(65);
        FirstName: String(30);
        LastName:String(30);
        CreatedOn: Date;
        Reviewed: Boolean;
        Approved: Boolean;
        Country: Country;
        Status: String(1);
        
    }
}
