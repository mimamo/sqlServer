USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDIS_SI01]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDIS_SI01] @parm1 varchar (6)  as
select  Count(*) from PJLABDIS
where   fiscalno =  @parm1 and
status_gl = 'U'
GO
