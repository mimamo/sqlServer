USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBSREV_sUnrel]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBSREV_sUnrel]  @parm1 varchar (16)   as
select * from PJBSREV
where    PJBSREV.Project = @parm1
and PJBSREV.Rel_Status <> 'Y'
GO
