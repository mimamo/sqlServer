USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDIS_SI01]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDIS_SI01] @parm1 varchar (6)  as
select  Count(*) from PJLABDIS
where   fiscalno =  @parm1 and
status_gl = 'U'
GO
