USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJBSREV_sProj]    Script Date: 12/21/2015 15:43:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBSREV_sProj]  @parm1 varchar (16)  as
select * from PJBSREV
where    PJBSREV.Project = @parm1
GO
