USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJChargD_LotSerNbr]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJChargD_LotSerNbr]
	@RecordID	varchar(25)

AS
	SELECT          *
	FROM            PJChargD
	WHERE           LotSerNbr = @RecordID
GO
