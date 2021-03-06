USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Customer_ARdoc_Batnbr]    Script Date: 12/21/2015 15:49:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Customer_ARdoc_Batnbr]  @parm1  AS VARCHAR (10), @parm2 AS VARCHAR (15) AS
SELECT DISTINCT customer.*
  FROM ardoc, customer
 WHERE ardoc.custid = customer.custid AND ardoc.batnbr LIKE @parm1
   AND ardoc.custid LIKE @parm2
 ORDER BY customer.custid
GO
