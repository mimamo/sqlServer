USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcTask_PJBUDSUM]    Script Date: 12/21/2015 16:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcTask_PJBUDSUM]   @project varchar(16),@pjt_entity varchar(32), @fsyear_num varchar(4), @acct varchar(16), @plannbr varchar(2) as
select * from PJBUDSUM where 
project = @project
and pjt_entity = @pjt_entity
and fsyear_num  = @fsyear_num
and acct = @acct
and planNbr = @plannbr
order by project, pjt_entity
GO
