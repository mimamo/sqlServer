USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOPROJ_spk0]    Script Date: 12/21/2015 13:57:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOPROJ_spk0] @parm1 varchar (16)  as
select * from PJCOPROJ
where project = @parm1
order by PJCOPROJ.project, PJCOPROJ.change_order_num
GO
