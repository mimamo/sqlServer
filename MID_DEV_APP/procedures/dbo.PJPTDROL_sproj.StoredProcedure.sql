USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_sproj]    Script Date: 12/21/2015 14:17:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_sproj] @parm1 varchar (16)   as
select * from  PJPTDROL
where PJPTDROL.project =  @parm1
GO
