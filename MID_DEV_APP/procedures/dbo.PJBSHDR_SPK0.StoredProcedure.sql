USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBSHDR_SPK0]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBSHDR_SPK0]  @parm1 varchar (16) , @parm2 varchar (6)   as
select * from PJBSHDR
where    project = @parm1 and
schednbr = @parm2
order by project, schednbr
GO
