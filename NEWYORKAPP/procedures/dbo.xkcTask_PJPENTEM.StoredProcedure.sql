USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcTask_PJPENTEM]    Script Date: 12/21/2015 16:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcTask_PJPENTEM]   @project varchar(16),@pjt_entity varchar(32), @employee varchar(10)     as
select * from PJPENTEM where 
project = @project
and pjt_entity = @pjt_entity
and employee = @employee
order by project, pjt_entity
GO
