USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Customer_CustomerEDI_All]    Script Date: 12/21/2015 14:34:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Customer_CustomerEDI_All]
	@CustID varchar(15)
AS
	SELECT *
	FROM Customer
	WHERE Customer.CustId = @CustID
	AND Customer.Status IN ('A', 'O', 'R')
GO
