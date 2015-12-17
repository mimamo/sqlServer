USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDLBView_All]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[XDDLBView_All]
	@ViewID			varchar(10)
AS
	SELECT * FROM XDDLBView
	WHERE ViewID LIKE @ViewID
	ORDER BY ViewID
GO
