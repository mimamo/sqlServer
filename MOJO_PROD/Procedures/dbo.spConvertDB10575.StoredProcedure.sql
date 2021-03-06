USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10575]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10575]
AS
	SET NOCOUNT ON 

	--Make these columns case sensitive to ensure we are pulling back the correct ID.  We saw an instance of 2 separate IDs
	--being the same with the exception of a single character that had a different case.
	ALTER TABLE [dbo].[tSyncItem] ALTER COLUMN DataStoreItemID
				varchar(2500) COLLATE SQL_Latin1_General_CP1_CS_AS NULL;
	ALTER TABLE [dbo].[tSyncItem] ALTER COLUMN DataStoreFolderID
				varchar(2500) COLLATE SQL_Latin1_General_CP1_CS_AS NULL;
	 
	-- Seed tPurchaseOrderDetail.GrossAmount = tPurchaseOrderDetail.BillableCost
	-- change for multicurrency functionality in the new PO flex screen
	update tPurchaseOrderDetail
	set    GrossAmount = BillableCost
	   

	-- added seeding for tTransactionUnpost
	update tTransactionUnpost
	set    ExchangeRate = 1
	      ,HDebit = Debit
		  ,HCredit = Credit


update tTransaction set HDebit = Debit
					,HCredit = Credit

update tCashTransaction set HDebit = Debit
					, HCredit = Credit

	RETURN
GO
