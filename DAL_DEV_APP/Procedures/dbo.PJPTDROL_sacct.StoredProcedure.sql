USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_sacct]    Script Date: 12/21/2015 13:35:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_sacct] @parm1 varchar (16)   as
select * from PJPTDROL
where acct = @parm1
GO
