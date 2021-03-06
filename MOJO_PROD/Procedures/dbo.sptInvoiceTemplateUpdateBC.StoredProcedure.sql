USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceTemplateUpdateBC]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceTemplateUpdateBC]

	@InvoiceTemplateKey int,
	@BCGroup1 int,
	@BCTotal1 tinyint,
	@BCGroup2 int,
	@BCTotal2 tinyint,
	@BCGroup3 int,
	@BCTotal3 tinyint,
	@BCGroup4 int,
	@BCTotal4 tinyint,
	@BCGroup5 int,
	@BCTotal5 tinyint,
	@BCCol1 varchar(60),
	@BCColWidth1 decimal(9,3),
	@BCCol2 varchar(60),
	@BCColWidth2 decimal(9,3),
	@BCCol3 varchar(60),
	@BCColWidth3 decimal(9,3),
	@BCCol4 varchar(60),
	@BCColWidth4 decimal(9,3),
	@BCCol5 varchar(60),
	@BCColWidth5 decimal(9,3),
	@BCCol6 varchar(60),
	@BCColWidth6 decimal(9,3),
	@BCCol7 varchar(60),
	@BCColWidth7 decimal(9,3),
	@BCCol8 varchar(60),
	@BCColWidth8 decimal(9,3),
	@BCHideDetails tinyint,
	@BCGroupByOrder tinyint

AS --Encrypt

  /*
  || When     Who Rel   What
  || 04/22/07 GHL 8.5   Added BCGroupByOrder 
  ||                    
  */

	UPDATE
		tInvoiceTemplate
	SET
		BCGroup1 = @BCGroup1,
		BCTotal1 = @BCTotal1,
		BCGroup2 = @BCGroup2,
		BCTotal2 = @BCTotal2,
		BCGroup3 = @BCGroup3,
		BCTotal3 = @BCTotal3,
		BCGroup4 = @BCGroup4,
		BCTotal4 = @BCTotal4,
		BCGroup5 = @BCGroup5,
		BCTotal5 = @BCTotal5,
		BCCol1 = @BCCol1,
		BCColWidth1 = @BCColWidth1,
		BCCol2 = @BCCol2,
		BCColWidth2 = @BCColWidth2,
		BCCol3 = @BCCol3,
		BCColWidth3 = @BCColWidth3,
		BCCol4 = @BCCol4,
		BCColWidth4 = @BCColWidth4,
		BCCol5 = @BCCol5,
		BCColWidth5 = @BCColWidth5,
		BCCol6 = @BCCol6,
		BCColWidth6 = @BCColWidth6,
		BCCol7 = @BCCol7,
		BCColWidth7 = @BCColWidth7,
		BCCol8 = @BCCol8,
		BCColWidth8 = @BCColWidth8,
		BCHideDetails = @BCHideDetails,
		BCGroupByOrder = @BCGroupByOrder
	WHERE
		InvoiceTemplateKey = @InvoiceTemplateKey 

	RETURN 1
GO
