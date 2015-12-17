USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDDepositor_All]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDDepositor_All]
	@VendCust	varchar(1),
	@ID 		varchar(15)
AS
	SELECT *
	FROM XDDDepositor
	WHERE VendCust = @VendCust
	and VendID like @ID
  	ORDER BY VendID
GO
