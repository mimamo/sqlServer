USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJALLOC_sProject]    Script Date: 12/21/2015 14:17:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALLOC_sProject]  @parm1 varchar (16)   as
select * from PJALLOC
where
post_project = @parm1 or
offset_project = @parm1
GO
