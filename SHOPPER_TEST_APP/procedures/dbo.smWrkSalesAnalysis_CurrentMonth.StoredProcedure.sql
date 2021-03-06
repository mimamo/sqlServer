USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smWrkSalesAnalysis_CurrentMonth]    Script Date: 12/21/2015 16:07:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smWrkSalesAnalysis_CurrentMonth]
                @ri_id AS SMALLINT
              , @month AS SMALLINT
AS
	SET NOCOUNT ON
	INSERT INTO smWrkSalesAnalysis
		(CallType
		, CurCost
		, CurHours
		, CurNbrCalls
		, CurRevenue
		, CustClass
		, InvoiceType
		, PrintMonth
		, PrintYear
		, PriorCost
		, PriorHours
		, PriorNbrCalls
		, PriorRevenue
		, RecType
		, RI_ID
		, ServiceCallID
		, ServiceContractId)
	SELECT CallType
		, CurCost
		, CurHours
		, CurNbrCalls
		, CurRevenue
		, CustClass
		, InvoiceType
		, PrintMonth
		, PrintYear
		, PriorCost
		, PriorHours
		, PriorNbrCalls
		, PriorRevenue
		, 'M'
		, RI_ID
		, ServiceCallID
		, ServiceContractId
	FROM smWrkSalesAnalysis
	WHERE RI_ID = @ri_id
		AND PrintMonth = @month
		AND RecType <> 'M'
GO
