USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Customer_Name]    Script Date: 12/21/2015 15:36:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Customer_Name]
	@parm1 varchar(15)
AS
	SELECT Name
	FROM Customer
	WHERE CustID = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
