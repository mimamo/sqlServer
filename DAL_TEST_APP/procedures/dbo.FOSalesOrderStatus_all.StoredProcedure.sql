USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FOSalesOrderStatus_all]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FOSalesOrderStatus_all]
	@parm1 varchar( 50 )
AS
	SELECT *
	FROM FOSalesOrderStatus
	WHERE SubscriberOrderID LIKE @parm1
	ORDER BY SubscriberOrderID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
