USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xAccSub_sub]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xAccSub_sub] @parm1 varchar (24) as
select sub from subacct
where sub = @parm1
order by sub
GO
