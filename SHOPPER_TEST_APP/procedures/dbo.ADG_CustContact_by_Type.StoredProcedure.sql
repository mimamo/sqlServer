USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CustContact_by_Type]    Script Date: 12/21/2015 16:06:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_CustContact_by_Type]
	@parm1 varchar(15),
	@parm2 varchar(2),
	@parm3 varchar(10)
AS
	SELECT *
	FROM CustContact
	WHERE CustID LIKE @parm1
	   AND Type LIKE @parm2
	   AND ContactID LIKE @parm3
	ORDER BY CustID,
	   ContactID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
