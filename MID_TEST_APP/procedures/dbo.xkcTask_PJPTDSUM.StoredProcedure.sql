USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcTask_PJPTDSUM]    Script Date: 12/21/2015 15:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcTask_PJPTDSUM]  @project varchar(16),@pjt_entity varchar(32),  @acct varchar(16)     as
select * from PJPTDSUM where 
project = @project
and pjt_entity = @pjt_entity
and acct = @acct
order by project, pjt_entity
GO
