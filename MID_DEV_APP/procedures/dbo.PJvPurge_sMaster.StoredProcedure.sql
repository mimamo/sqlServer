USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJvPurge_sMaster]    Script Date: 12/21/2015 14:17:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJvPurge_sMaster]  @parm1 char (1)   as
select * from PJVPURGE
where    master = @parm1
order by project
GO
