USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIWUsers_All]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[xIWUsers_All]
(@parm1 varchar(47))
as
	Select * from xIWUsers
	where UserID LIKE @parm1
	order by UserID
GO
