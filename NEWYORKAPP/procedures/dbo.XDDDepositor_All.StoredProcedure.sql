USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDDepositor_All]    Script Date: 12/21/2015 16:01:24 ******/
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
