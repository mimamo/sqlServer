USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_PCPR_Pjpentem]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_PCPR_Pjpentem]  @project varchar(16), @pjt_entity varchar(32), @employee varchar(10) as   
select * from pjpentem where 
project = @project
and pjt_entity = @pjt_entity
and employee = @employee
order by project
GO
