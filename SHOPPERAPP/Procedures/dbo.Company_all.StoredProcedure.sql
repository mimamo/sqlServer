USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Company_all]    Script Date: 12/21/2015 16:13:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Company_all]
	@CpnyID varchar( 10 )

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	SELECT *
	FROM vs_Company
	WHERE CpnyID LIKE @CpnyID
	ORDER BY CpnyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
