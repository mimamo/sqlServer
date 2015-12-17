USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smcustomer_all]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smcustomer_all]
	@parm1 varchar(15)
AS
SELECT *
FROM customer
	left outer join smCustomer
		on customer.CustId = smCustomer.CustId
WHERE customer.custid LIKE @parm1
ORDER BY customer.custid
GO
