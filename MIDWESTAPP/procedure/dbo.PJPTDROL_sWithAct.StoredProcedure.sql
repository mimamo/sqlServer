USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_sWithAct]    Script Date: 12/21/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_sWithAct] @parm1 varchar (16)   as
select * from  PJPTDROL
where PJPTDROL.project =  @parm1 and
	 (PJPTDROL.act_amount <> 0 or PJPTDROL.com_amount <> 0)
GO
