USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xq_sp_pclhdr_dbnav]    Script Date: 12/21/2015 13:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[xq_sp_pclhdr_dbnav] (@parm1 char(16), @parm2 char(6))

as

select
	*
from
	xqpclmain
where
	customer = @parm1
and
	perpost like @parm2
GO
