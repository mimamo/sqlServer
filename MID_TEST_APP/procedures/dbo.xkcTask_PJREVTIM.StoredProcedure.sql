USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcTask_PJREVTIM]    Script Date: 12/21/2015 15:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcTask_PJREVTIM]   @project varchar(16),@pjt_entity varchar(32), @RevID varchar(4), @acct varchar(16), @fiscalno  varchar(6) as
select * from PJREVTIM where 
project = @project
and pjt_entity = @pjt_entity
and RevID  = @RevID
and acct = @acct
and fiscalno = @fiscalno
order by project, pjt_entity
GO
