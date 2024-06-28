sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'cap/product/test/integration/FirstJourney',
		'cap/product/test/integration/pages/ProductList',
		'cap/product/test/integration/pages/ProductObjectPage',
		'cap/product/test/integration/pages/ReviewsObjectPage'
    ],
    function(JourneyRunner, opaJourney, ProductList, ProductObjectPage, ReviewsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('cap/product') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheProductList: ProductList,
					onTheProductObjectPage: ProductObjectPage,
					onTheReviewsObjectPage: ReviewsObjectPage
                }
            },
            opaJourney.run
        );
    }
);