USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQFutDetProjLoad]    Script Date: 12/21/2015 14:17:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[RQFutDetProjLoad]
	@parm1 varchar(10), @parm2 varchar(16), @parm3 varchar(2)
as
	select * from RQitemreqdet where
	itemReqnbr = @parm1 and
	Project = @parm2 and
	status = 'SA' and
	AppvLevReq >= @parm3
	ORDER BY ItemReqNbr, LineNbr
GO
