USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcTask_PJACTSUM]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcTask_PJACTSUM]   @project varchar(16),@pjt_entity varchar(32), @fsyear_num varchar(4), @acct varchar(16)     as
select * from PJACTSUM where 
project = @project
and pjt_entity = @pjt_entity
and fsyear_num  = @fsyear_num
and acct = @acct
order by project, pjt_entity
GO
