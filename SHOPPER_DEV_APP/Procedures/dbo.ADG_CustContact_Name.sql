USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CustContact_Name]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_CustContact_Name]
	@CustID varchar(15),
	@ContactID varchar(10)
AS
	SELECT Name
	FROM CustContact
	WHERE CustID = @CustID
	AND ContactID = @ContactID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
