USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDD_LockBox_Customer_PV]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDD_LockBox_Customer_PV]
	@CustID		varchar(15)
AS
	SELECT * FROM XDD_vp_LB_Customer
	WHERE CustID LIKE @CustID
  	ORDER BY CustID
GO
