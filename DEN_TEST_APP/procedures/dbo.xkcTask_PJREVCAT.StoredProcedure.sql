USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcTask_PJREVCAT]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcTask_PJREVCAT]  @project varchar(16),@pjt_entity varchar(32), @RevID varchar(4), @acct varchar(16)     as
select * from PJREVCAT where 
project = @project
and pjt_entity = @pjt_entity
and RevID  = @revid
and acct = @acct
order by project, pjt_entity
GO
