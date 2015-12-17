USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDCustomer_CustID]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDCustomer_CustID]
  @CustID	varchar(15)
AS
  Select      	*
  FROM        	Customer
  WHERE       	CustID LIKE @CustID
  ORDER BY    	CustID
GO
