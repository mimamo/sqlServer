USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDCustomer_CustID]    Script Date: 12/21/2015 14:18:03 ******/
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
