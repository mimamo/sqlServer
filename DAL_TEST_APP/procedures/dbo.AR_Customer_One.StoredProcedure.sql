USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AR_Customer_One]    Script Date: 12/21/2015 13:56:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AR_Customer_One    Script Date: 4/7/98 12:30:33 PM ******/
CREATE PROC [dbo].[AR_Customer_One] @parm1 varchar(15) AS
SELECT *
  FROM Customer
 WHERE custid = @parm1
 ORDER BY custid
GO
