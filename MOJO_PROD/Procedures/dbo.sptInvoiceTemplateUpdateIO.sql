USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceTemplateUpdateIO]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceTemplateUpdateIO]
	@InvoiceTemplateKey int,
	@IOGroup1 int,
	@IOTotal1 tinyint,
	@IOGroup2 int,
	@IOTotal2 tinyint,
	@IOGroup3 int,
	@IOTotal3 tinyint,
	@IOGroup4 int,
	@IOTotal4 tinyint,
	@IOGroup5 int,
	@IOTotal5 tinyint,
	@IOHideDetails tinyint,
	@IOGroupByOrder tinyint,	
	@IOCol1 varchar(60),
	@IOColWidth1 decimal(9,3),
	@IOCol2 varchar(60),
	@IOColWidth2 decimal(9,3),
	@IOCol3 varchar(60),
	@IOColWidth3 decimal(9,3),
	@IOCol4 varchar(60),
	@IOColWidth4 decimal(9,3),
	@IOCol5 varchar(60),
	@IOColWidth5 decimal(9,3),
	@IOCol6 varchar(60),
	@IOColWidth6 decimal(9,3),
	@IOCol7 varchar(60),
	@IOColWidth7 decimal(9,3)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 04/22/07 GHL 8.5   Added IOGroupByOrder 
  ||                    
  */

	UPDATE
		tInvoiceTemplate
	SET
		IOGroup1 = @IOGroup1,
		IOTotal1 = @IOTotal1,
		IOGroup2 = @IOGroup2,
		IOTotal2 = @IOTotal2,
		IOGroup3 = @IOGroup3,
		IOTotal3 = @IOTotal3,
		IOGroup4 = @IOGroup4,
		IOTotal4 = @IOTotal4,
		IOGroup5 = @IOGroup5,
		IOTotal5 = @IOTotal5,
		IOCol1 = @IOCol1,
		IOColWidth1 = @IOColWidth1,
		IOCol2 = @IOCol2,
		IOColWidth2 = @IOColWidth2,
		IOCol3 = @IOCol3,
		IOColWidth3 = @IOColWidth3,
		IOCol4 = @IOCol4,
		IOColWidth4 = @IOColWidth4,
		IOCol5 = @IOCol5,
		IOColWidth5 = @IOColWidth5,
		IOCol6 = @IOCol6,
		IOColWidth6 = @IOColWidth6,
		IOCol7 = @IOCol7,
		IOColWidth7 = @IOColWidth7,
		IOHideDetails = @IOHideDetails,
		IOGroupByOrder = @IOGroupByOrder
	WHERE
		InvoiceTemplateKey = @InvoiceTemplateKey 

	RETURN 1
GO
